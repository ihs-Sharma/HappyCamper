//
//  SubCategoryDetailVC.swift
//  HappyCamper
//
//  Created by wegile on 30/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SubCategoryDetailCVC: UICollectionViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var view_Content: UIView!
    
    override func awakeFromNib() {
//        self.dropShadow(color: UIColor.gray, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
            view_Content.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }

    override var isSelected: Bool {
        didSet{
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
//                self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.1, y: 1.1) : CGAffineTransform.identity
//            }, completion: nil)
        }
    }
}

class SubCategoryDetailVC: UIViewController, SelectMenuOption ,SelectAviatorImage,TopHeaderViewDelegate {
   
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var videoVw: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnLikedRef: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var view_Gradiant: UIView!
    @IBOutlet weak var view_GradiantLeft: UIView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwAviator: SetCornerImageView!
    @IBOutlet weak var imgVwMenu: UIView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var img_MainBanner: UIImageView!
    var refreshControl = UIRefreshControl()
    
    //MARK:--> VARIABLES
    var player : AVPlayer?
    var playerController  : AVPlayerViewController?
    var strIdentifier : String?
    var likeState = Int()
    
    var str_ActivityType : String!
    var str_CategoryValue : String!
    
    var SubCategoryDetailVMObj = SubCategoryDetailVM()
    var viewController : MenuDrawerController?
    
    func setBackToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func selectOptionByName(name: String!) {
        switch name {
        case "live":
            Proxy.shared.pushToNextVC(identifier: "CampDetailVC", isAnimate: true, currentViewController: self)
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
        SelectedVideoObj = self
        tblVw.tableFooterView = UIView()
        tblVw.separatorStyle = .none
        SelectAviatorImageObj = self
        viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
        viewController?.delegate = self

        self.tblVw.estimatedRowHeight = 0.0
        self.tblVw.rowHeight = 309.0
        targetVw.isHidden = true
        targetVw.addSubview(viewController!.view)
        viewController?.tblVw.delegate = viewController
        viewController?.tblVw.dataSource = viewController
        addPullToRefresh()
        
        //Load Data
        reloadData()
    }
    
    func addPullToRefresh() {
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        tblVw.refreshControl = refreshControl
        tblVw.addSubview(refreshControl) // not required when using UITableViewController
        
    }
    
    @objc func reloadData() {
        getCategoryDetailData()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        if playerController != nil {
            player!.pause()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if Proxy.shared.authNil() != "" {
           
//            imgVwMenu.isHidden = false
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
//            lblUserName.text! = KAppDelegate.UserModelObj.userName
        } else{
//            imgVwMenu.isHidden = true
        }
        headerDelegate = self
        targetVw.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func getCategoryDetailData() {
        SubCategoryDetailVMObj.VideoDetailModelAry.removeAll()
        SubCategoryDetailVMObj.CategoryModelAry.removeAll()
        SubCategoryDetailVMObj.GuestLandingModelAry.removeAll()
        
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            SubCategoryDetailVMObj.getSubCategoriesApi {
                
                self.likeState = self.SubCategoryDetailVMObj.VideoLiked
                self.btnLikedRef.setTitle("  \(self.SubCategoryDetailVMObj.totalLike)", for: .normal)
                
                if self.likeState == 0 {
                    self.btnLikedRef.setImage(UIImage(named: "like"), for: .normal)
                } else{
                    self.btnLikedRef.setImage(UIImage(named: "like"), for: .normal)
                }
                
                self.videoPlayerPlay(Url: self.SubCategoryDetailVMObj.VideoDetailModelAry[0].videoUrl)
                self.btnView.setTitle("\(self.SubCategoryDetailVMObj.VideoDetailModelAry[0].dictCount)", for: .normal)
                self.lblTitle.text! = self.SubCategoryDetailVMObj.VideoDetailModelAry[0].videoTitle
                let string =  self.SubCategoryDetailVMObj.VideoDetailModelAry[0].videoDescription
                self.lblDescription.text! = string.htmlToString
                
                //                self.img_MainBanner.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(self.SubCategoryDetailVMObj.VideoDetailModelAry[0].videoImageThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                
                self.SubCategoryDetailVMObj.postHomeScreenApiWithActivityType(type: self.str_ActivityType, categoryValue: self.str_CategoryValue, completionHandler: {(success) -> Void in
                    if success {
                        self.tblVw.reloadData()
                        self.perform(#selector(SubCategoryDetailVC.scrollToTop), with: nil, afterDelay: 0.4)
                        

                    } else {
                        
                    }
                    Proxy.shared.hideActivityIndicator()
                })
                //                self.SubCategoryDetailVMObj.postHomeScreenApi {
                //                    self.tblVw.reloadData()
                //                }
                self.refreshControl.endRefreshing()
            }
        } else {
            Proxy.shared.presentAlert(withTitle: "", message: "Please Login", currentViewController: self)
        }
    }
    
    @objc func scrollToTop()
    {
        
        self.tblVw.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
        
        
    }
    
    
    
    
    

    
    //MARK:--> BUTTON ACTIONS

    @IBAction func btnCampStoreAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "CampStoreVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnCampFireAction(_ sender: Any) {
        Proxy.shared.presentAlert(withTitle: "", message: "In progress", currentViewController: self)
      //  Proxy.shared.pushToNextVC(identifier: "CamperUploadDetailVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func bntWebSeriesAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnLikedAction(_ sender: Any) {
        
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            if self.likeState == 0 {
                SubCategoryDetailVMObj.videoLikeApi {
                    self.viewWillAppear(true)
                }
            } else {
                SubCategoryDetailVMObj.videoDislikeApi {
                    self.viewWillAppear(true)
                }
            }
        } else{
            Proxy.shared.presentAlert(withTitle: "", message: "Please login", currentViewController: self)
        }
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        if targetVw.isHidden == true{
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnAddToCampVideo(_ sender: Any) {
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            SubCategoryDetailVMObj.addToMyCampApi {
            }
        } else {
            Proxy.shared.presentAlert(withTitle: "", message: "Please login", currentViewController: self)
        }
    }
    
    //MARK:--> PLAY VIDEO  FUNCTION
    func videoPlayerPlay(Url: String) {
        
        let videoURL = URL(string: "\(Apis.KVideoURl)\(Url)")
        
        if playerController  != nil {
//            player = nil
//            playerController?.player = nil
//
//            player = AVPlayer(url: videoURL!)
//            playerController?.player = player
//            player?.play()
            let currentItem = AVPlayerItem.init(url: videoURL!)
            player?.replaceCurrentItem(with: currentItem)
            player?.play()

        } else {
            playerController  = AVPlayerViewController()
            player = AVPlayer(url: videoURL!)
            
            playerController?.player = player
            playerController?.view = videoVw
            playerController?.view.frame = videoVw.bounds
            playerController?.videoGravity = .resizeAspectFill
            self.addChild(playerController!)
            videoVw.addSubview(playerController!.view )
            playerController!.view.frame = videoVw.bounds
            player!.play()
            
        }

//        player?.automaticallyWaitsToMinimizeStalling = false
    }
    
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
}
