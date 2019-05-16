//
//  SubCategoriesVideoVC.swift
//  HappyCamper
//
//  Created by wegile on 29/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SubCategoriesVideoVC: UIViewController , SelectMenuOption ,SelectAviatorImage,TopHeaderViewDelegate,ManagePlyersDelegte {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var videoVw: UIView!
    @IBOutlet weak var lblTitleGroup: UILabel!
    @IBOutlet weak var imgVwTitleLogo: UIImageView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var view_Gradiant: UIView!
    @IBOutlet weak var view_GradiantLeft: UIView!
    @IBOutlet weak var lbl_BannerTitle: UILabel!
    @IBOutlet weak var lbl_BannerDescp: UILabel!
    @IBOutlet weak var videoViewHeight_Constraints: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var imgVwAviator: SetCornerImageView!
    @IBOutlet weak var menuVw: SetCornerImageView!
    var notificationObserver:NSObjectProtocol?
    
    var isThisViewDismissed:Bool = false
    //MARK:--> VARIABLES
    var SubCategoriesVideoVMObj =  SubCategoriesVideoVM()
    //PLAYER TASK
    var player : AVPlayer?
    var playerController  : AVPlayerViewController?
    var viewController : MenuDrawerController?
    
    func setBackToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func selectOptionByName(name: String!) {
        switch name {
        case "live":
            //            Proxy.shared.pushToNextVC(identifier: "CampDetailVC", isAnimate: true, currentViewController: self)
            break
        case "series":
            Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
            break
        case "360":
            let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "HCStaticLinkVC") as! HCStaticLinkVC
            vc.str_URL = Apis.K360Camp
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "campFire":
            Proxy.shared.pushToNextVC(identifier: "CampfireVC", isAnimate: true, currentViewController: self)
            break
        case "store":
            break
        case "profilePic":
            Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: false, currentViewController: self)
            break
        case "Options":
            if targetVw.isHidden == true {
                targetVw.isHidden = false
            }else{
                targetVw.isHidden = true
            }
            break
        case "SignIn":
            Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
            break
        case "getAccess":
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            break
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //varinder16
        if UIDevice.current.userInterfaceIdiom == .pad {
            let isIpadPro:Bool = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) > 1024
            
            if isIpadPro != true {
                videoViewHeight_Constraints.constant = 500//650
                // headerView
                
                var newFrame: CGRect = headerView.frame
                newFrame.size.height = 700//848
                headerView.frame = newFrame
            }
        }
        
        SelectedViewAllVideoObj = self
        tblVw.tableFooterView = UIView()
        tblVw.separatorStyle = .none
        
        
        tblVw.register(UINib(nibName: "AdvertisementTVC", bundle: nil), forCellReuseIdentifier: "AdvertisementTVC")
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        targetVw.isHidden = true
        SelectAviatorImageObj = self
        viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
        viewController?.delegate = self
        
        
        targetVw.isHidden = true
        targetVw.addSubview(viewController!.view)
        viewController?.tblVw.delegate = viewController
        viewController?.tblVw.dataSource = viewController
        }
        //Load Data
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !KAppDelegate.isGradiantShownForSubCategory {
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size = view_Gradiant.frame.size
            gradientLayer.colors =
                [UIColor.white.withAlphaComponent(0).cgColor,UIColor.white.withAlphaComponent(1).cgColor]
            //        Use diffrent colors
            view_Gradiant.layer.sublayers=nil
            view_Gradiant.layer.addSublayer(gradientLayer)
            
            let gradientLayer1:CAGradientLayer = CAGradientLayer()
            gradientLayer1.frame.size = view_GradiantLeft.frame.size
            gradientLayer1.startPoint = CGPoint(x: 0.0, y: 0.5) //x = left to right
            gradientLayer1.endPoint = CGPoint(x: 1.0, y: 0.5) // x = right to left
            gradientLayer1.colors =
                [UIColor.white.withAlphaComponent(1).cgColor,UIColor.white.withAlphaComponent(0).cgColor]
            //        Use diffrent colors
            view_GradiantLeft.layer.sublayers=nil
            view_GradiantLeft.layer.addSublayer(gradientLayer1)
            
            KAppDelegate.isGradiantShownForSubCategory=true
        } else {
            if self.player?.timeControlStatus != .playing {
                self.player?.play()
            }
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        KAppDelegate.isGradiantShownForSubCategory=false
        self.viewDidAppear(false)
        
    }
    
    func reloadData() {
        SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry.removeAll()
        SubCategoriesVideoVMObj.postSubCategoryViewAllApi {
            self.dataResponseHandling()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.imgVw.isHidden=false
        NotificationCenter.default.removeObserver(self.notificationObserver!)
        
        if self.playerController != nil {
            self.player!.pause()
            self.isThisViewDismissed=true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
            
            headerDelegate = self
            targetVw.isHidden = true
        }
        self.notificationObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            if self?.self.playerController != nil && self?.isThisViewDismissed == false {
                self?.self.player?.seek(to: CMTime.zero)
                self?.self.player?.play()
            }
        }
    }
    
    //MARK:--> BUTTON ACTIONS
    
    @IBAction func buttonMuteUnmute( button: UIButton) {
        
        if self.player?.isMuted == true {
            self.player?.isMuted=false
            button.setImage(UIImage.init(named: "icon_SpeakerLoud"), for: .normal)
        } else {
            self.player?.isMuted=true
            button.setImage(UIImage.init(named: "icon_SpeakerMute"), for: .normal)
        }
        
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        //        if txtFldSearch.isBlank {
        //            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.search, currentViewController: self)
        //        } else {
        SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry.removeAll()
        SubCategoriesVideoVMObj.searchString = txtFldSearch.text!
        SubCategoriesVideoVMObj.postSubCategoryViewAllApi {
            self.dataResponseHandling()
            //            }
        }
    }
    
    func dataResponseHandling() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.lblTitleGroup.text! = self.SubCategoriesVideoVMObj.categoryName
            self.imgVwTitleLogo.sd_setImage(with: URL.init(string: "\(Apis.KCategoryImage)\(self.SubCategoriesVideoVMObj.CategoryLogoImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        self.lbl_BannerTitle.text! = self.SubCategoriesVideoVMObj.categoryName
        
        if self.SubCategoriesVideoVMObj.categoryType == "image" {
            //            self.imgVw.isHidden = false
            //            self.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KCategoryImage)\(self.SubCategoriesVideoVMObj.catBannerImage)"),placeholderImage: #imageLiteral(resourceName: "banner"), completed: nil)
        } else {
            //            self.imgVw.isHidden = true
            let thumbnail:URL!
            if self.SubCategoriesVideoVMObj.bannerThumbnail != "" {
                thumbnail = URL.init(string: "\(Apis.KVideosThumbURL)\(self.SubCategoriesVideoVMObj.bannerThumbnail)")
            } else {
                thumbnail = URL.init(string: "https://www.happycamperlive.com/assets/images/about-thumbnail.png")
            }
            
            self.videoPlayerPlay(Url: self.SubCategoriesVideoVMObj.catBannerImage,thumbURL: thumbnail)
        }
        
        self.tblVw.reloadData()
    }
    
    @IBAction func buttonCross(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        if targetVw.isHidden == true{
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnBackAction(_ sender: Any) {
        KAppDelegate.isGradiantShownForSubCategory=false
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    //MARK:--> PLAY VIDEO  FUNCTION
    func videoPlayerPlay(Url: String,thumbURL:URL!) {
        self.imgVw.isHidden=false
        
        let videoURL = URL(string: "\(Apis.KCategoryVideo)\(Url)")
        if self.playerController != nil {
            //            player = nil
            //            self.playerController?.player = nil
            //
            //            player = AVPlayer(url: videoURL!)
            //            self.playerController?.player = player
            //            self.player?.play()
            
            self.imgVw.sd_setImage(with: thumbURL,placeholderImage: nil, completed: nil)
            
            let currentItem = AVPlayerItem.init(url: videoURL!)
            self.player?.replaceCurrentItem(with: currentItem)
            self.player?.play()
            
            
        } else {
            self.imgVw.sd_setImage(with: thumbURL,placeholderImage: nil, completed: nil)
            
            self.playerController  = AVPlayerViewController()
            self.player = AVPlayer(url: videoURL!)
            self.playerController?.videoGravity = .resizeAspectFill
            self.playerController?.player = self.player
            self.playerController?.view = videoVw
            self.playerController?.view.frame = videoVw.bounds
            
            self.playerController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.playerController?.showsPlaybackControls=false
            self.playerController?.view.backgroundColor = .white
            self.addChild(self.playerController!)
            videoVw.addSubview(self.playerController!.view )
            self.playerController!.view.frame = videoVw.bounds
            self.player!.play()
            
        }
        
        self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main, using: { time in
            
            if self.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                
                if let isPlaybackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp {
                    //do what ever you want with isPlaybackLikelyToKeepUp value, for example, show or hide a activity indicator.
                    self.imgVw.isHidden=true
                }
            }
        })
    }
    
    //MARK:--> PROTOCOL FUNCTIONS
    func didSelected(index: Int) {
        if index == 0 {
            targetVw.isHidden = true
        } else if index == 1 {
            let auth = Proxy.shared.authNil()
            if auth != ""{
                Proxy.shared.pushToNextVC(identifier: "ProfileVC", isAnimate: true, currentViewController: self)
            } else{
                Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.login)", currentViewController: self)
            }
        }else if index == 2 {
            Proxy.shared.pushToNextVC(identifier: "CamperStaffVC", isAnimate: true, currentViewController: self)
        }
        else if index == 3 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Community"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 4 {
            let auth = Proxy.shared.authNil()
            if auth != ""{
                Proxy.shared.pushToNextVC(identifier: "InviteAFriendVC", isAnimate: true, currentViewController: self)
            } else {
                Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            }
        } else if index == 5 {
            let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "HCStaticLinkVC") as! HCStaticLinkVC
            vc.str_URL = Apis.KBlog
            self.navigationController?.pushViewController(vc, animated: true)
        } else if index == 6 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "FAQs"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 7 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "ContactUs"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 8 {
            Proxy.shared.pushToNextVC(identifier: "JoinOurTeamVC", isAnimate: true, currentViewController: self)
        } else if index == 9 {
            // Register Camp
        }else if index == 10 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Terms & Conditions"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 11 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Privacy Policies"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 12 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Disclaimer"
            self.navigationController?.pushViewController(nav, animated: true)
        } else  if index == 101 {
            Proxy.shared.pushToNextVC(identifier: "CoinCanteenVC", isAnimate: true, currentViewController: self)
        } else {
            Proxy.shared.rootWithoutDrawer("TabbarViewController")
        }
        
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
    
    func didPlayVideo(status: Bool) {
        if status {
            if self.playerController != nil {
                self.player!.play()
            }
        }
    }
}
