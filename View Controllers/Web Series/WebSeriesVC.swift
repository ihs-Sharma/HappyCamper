//
//  EpisodesDetailsVC.swift
//  HappyCamper
//
//  Created by wegile on 21/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class WebSeriesVC: UIViewController, UITableViewDelegate, SelectMenuOption, SelectAviatorImage,TopHeaderViewDelegate,ManagePlyersDelegte {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btn_GetAccess: UIButton!
    @IBOutlet weak var lblDirectorName: UILabel!
    @IBOutlet weak var videoVw: UIView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var view_Gradiant: UIView!
    @IBOutlet weak var view_GradiantLeft: UIView!
    @IBOutlet weak var videoViewHeight_Constraints: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    //MARK:--> VARIABLES
    var WebSeriesVMObj = WebSeriesVM()
    
    //PLAYER TASK
    var player : AVPlayer?
    var playerController  : AVPlayerViewController?

    var sectionHeader = ["EPISODES",""]
    var tableViewControlr :EpisodesDetailsTVC?
    var viewController : MenuDrawerController?
    var notificationObserver:NSObjectProtocol?
    
    func setBackToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func selectOptionByName(name: String!) {
        switch name {
        case "live":
            //            Proxy.shared.pushToNextVC(identifier: "CampDetailVC", isAnimate: true, currentViewController: self)
            break
        case "series":
            //                       Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
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
    
    //MARK:--> VIEW CONTROLLER FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //varinder16
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let isIpadPro:Bool = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) > 1024
            
            if isIpadPro != true {
                videoViewHeight_Constraints.constant = 500//615
                // headerView
                
                var newFrame: CGRect = headerView.frame
                newFrame.size.height = 510//623
                headerView.frame = newFrame
            }
        }
        
        //Load Data
        reloadData()
        SelectedWebVideoObj = self
        
        if Proxy.shared.authNil() == "" {
            btn_GetAccess.setTitle("GET ACCESS", for: .normal)
        } else {
            btn_GetAccess.setTitle("WATCH EPISODES", for: .normal)
            btn_GetAccess.backgroundColor = UIColor.init(red: 71/255, green: 185/255, blue: 57/255, alpha: 1.0)
        }

        if UIDevice.current.userInterfaceIdiom != .pad {
             self.title  = "WEB SERISE"
            return
        }
        
         targetVw.isHidden = true
        view_HeaderView.btn_Series.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)

        for view in view_HeaderView.subviews {
            if let lbl = view.viewWithTag(102) as? UILabel { lbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)  }
        }
        tblVw.register(UINib(nibName: "AdvertisementTVC", bundle: nil), forCellReuseIdentifier: "AdvertisementTVC")
        
        viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
        viewController?.delegate = self
        
        targetVw.addSubview(viewController!.view)
        viewController?.tblVw.delegate = viewController
        viewController?.tblVw.dataSource = viewController
    
    }
    
    func reloadData() {
         getWebSeries()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom != .pad {
            return
        }
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view_Gradiant.frame.size
        gradientLayer.colors =
            [UIColor.black.withAlphaComponent(0).cgColor,UIColor.black.withAlphaComponent(1).cgColor]
        //        Use diffrent colors
        view_Gradiant.layer.addSublayer(gradientLayer)
        
        let gradientLayer1:CAGradientLayer = CAGradientLayer()
        gradientLayer1.frame.size = view_GradiantLeft.frame.size
        gradientLayer1.startPoint = CGPoint(x: 0.0, y: 0.5) //x = left to right
        gradientLayer1.endPoint = CGPoint(x: 1.0, y: 0.5) // x = right to left
        gradientLayer1.colors =
            [UIColor.black.withAlphaComponent(1).cgColor,UIColor.black.withAlphaComponent(0).cgColor]
        //        Use diffrent colors
        view_GradiantLeft.layer.addSublayer(gradientLayer1)
    
    }

    override func viewWillAppear(_ animated: Bool) {
        self.notificationObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            if self?.self.playerController != nil && self?.player?.timeControlStatus == .playing {
                self?.self.player?.seek(to: CMTime.zero)
                self?.self.player?.play()
            }
        }
        
        if self.player?.timeControlStatus != .playing {
            self.player?.play()
        }
        if UIDevice.current.userInterfaceIdiom != .pad {
            return
        }
        headerDelegate = self

        let slectedAviator = Proxy.shared.selectedAviatorImage()
        if slectedAviator != "" {
            view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.notificationObserver!)
        self.imgVw.isHidden=false

        if self.playerController != nil {
//            if self.player?.timeControlStatus == .playing {
                self.player?.pause()
//            }
//            self.player = nil
//            self.playerController?.player = nil
//            self.playerController = nil
//            self.playerController?.willMove(toParent: self)
//            self.playerController?.view.removeFromSuperview()
//            self.playerController?.removeFromParent()
        }
    }
    
    func getWebSeries() {
        WebSeriesVMObj.SubCategoryViewAllTopModelAry = []
        WebSeriesVMObj.SubVideoCategoryModelAry      = []
        WebSeriesVMObj.CastDictModelAry              = []
        
        WebSeriesVMObj.postWebSeriesApi(completion: {(bannerData) -> Void in
            
            var videoUrl:URL!

            DispatchQueue.main.async {
                if self.WebSeriesVMObj.SubCategoryViewAllTopModelAry[0].VideoModelAry.count > 0 {
                    videoUrl = URL.init(string: "\(Apis.KVideosThumbURL)\(self.WebSeriesVMObj.SubCategoryViewAllTopModelAry[0].VideoModelAry[0].videoImgThumb)")
                } else {
                    videoUrl = URL.init(string: "https://www.happycamperlive.com/assets/images/about-thumbnail.png")
                }
                self.videoPlayerPlay(Url: bannerData["banner_content"].stringValue,thumbURL: videoUrl)
            }
            self.tblVw.reloadData()
            self.collVw.reloadData()
//            self.btnNumberEpisodes.setTitle("Number of Episodes: \(self.WebSeriesVMObj.totalItems)", for: .normal)
            
            //            self.WebSeriesVMObj.postCastApi {
            //            }
        })
    }

    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnGetAllAccess(_ sender: Any) {
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
        } else {             // Watch Episodes
            if kisSubscribed {
                if WebSeriesVMObj.SubCategoryViewAllTopModelAry.count > 0 {
                    let VideoModelAryObj = WebSeriesVMObj.SubCategoryViewAllTopModelAry[0].VideoModelAry[0]
                    SelectedWebVideoObj?.didSelected(selectedVideoId: VideoModelAryObj.videoId)
                    SelectedWebVideoObj?.didPauseVideoForSeries(status: true)
                }
            } else {
                let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "SubscriptionDetailVIew") as! SubscriptionDetailVIew
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func buttonMuteUnmute( button: UIButton) {
        
        if player?.isMuted == true {
            player?.isMuted=false
            button.setImage(UIImage.init(named: "icon_SpeakerLoud"), for: .normal)
        } else {
            player?.isMuted=true
            button.setImage(UIImage.init(named: "icon_SpeakerMute"), for: .normal)
        }
        
    }
    
    //MARK:--> PLAY VIDEO  FUNCTION
    func videoPlayerPlay(Url: String,thumbURL:URL!) {
        self.imgVw.isHidden=false
        let videoURL = URL(string: "\(Apis.KCategoryVideo)\(Url)")
        
        if self.playerController  != nil {
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
            self.playerController?.view.backgroundColor = .black
            self.addChild(self.playerController!)
            self.playerController?.didMove(toParent: self)
            videoVw.addSubview(self.playerController!.view )
//            self.player?.actionAtItemEnd = .none
            //            self.player?.playImmediately(atRate: 1.0)
            self.player?.play()
            
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
