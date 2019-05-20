//
//  GuestLandingPageVC.swift
//  HappyCamper
//
//  Created by wegile on 23/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import StoreKit

class GuestLandingPageVC: UIViewController, SelectMenuOption ,SelectAviatorImage,TopHeaderViewDelegate,ManagePlyersDelegte {
    //MARK:--> IBOUTLETS
    
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var tblVwMain: UITableView!
    @IBOutlet weak var colVwBanner: UICollectionView!
    @IBOutlet weak var colVwAds: UICollectionView!
    @IBOutlet weak var videoVw: UIView!
    @IBOutlet weak var view_Gradiant: UIView!
    @IBOutlet weak var view_GradiantLeft: UIView!
    @IBOutlet weak var view_GradiantRight: UIView!
    @IBOutlet weak var img_Thumb: UIImageView!
    var notifObserver:NSObjectProtocol?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var img_TodayCampGif: UIImageView!
    //    @IBOutlet var imgVwbanner: UIImageView!
    //    @IBOutlet weak var btn_OpenAds: UIButton!
    
    @IBOutlet weak var btnGetAllAccess: UIButton!
    @IBOutlet weak var btn_Mute: UIButton!
    
    @IBOutlet weak var videoViewHeight_Constraints: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    //PLAYER TASK
    var player : AVPlayer?
    //    var videoLayer : AVPlayerLayer?
    var playerController  = AVPlayerViewController()
    var currentItem : AVPlayerItem!
    var refreshControl = UIRefreshControl()
    
    var playCount:Int = 0
    //MARK:--> VARIABLES
    var viewController : MenuDrawerController?
    var guestLandingVMObj = GuestLandingVM()
    
    func setBackToHome() {    }
    
    //MARK:- Select Options
    func selectOptionByName(name: String!) {
        switch name {
        case "live":
            //            Proxy.shared.pushToNextVC(identifier: "CampDetailVC", isAnimate: true, currentViewController: self)
            break
        case "series":
            Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
            break
        case "360":
            if Proxy.shared.authNil() == "" {
                Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
                return
            }
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
    
    
    //MARK:--> VIEW CONTROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //varinder16
        if UIDevice.current.userInterfaceIdiom == .pad {
            let isIpadPro:Bool = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) > 1024
            
            if isIpadPro != true {
                videoViewHeight_Constraints.constant = 500//720
                // headerView
                
                var newFrame: CGRect = headerView.frame
                newFrame.size.height = 820//1020
                headerView.frame = newFrame
            }
        }
        
        tblVwMain.separatorStyle = .none
        let auth = Proxy.shared.authNil()
        if auth != "" {
            btnGetAllAccess.isHidden = true
            self.fetchProducts()
            //            self.getSubscriptionStatus()
        } else {
            btnGetAllAccess.isHidden = false
        }
        
        addPullToRefresh()
        
        let url:URL! = Bundle.main.url(forResource: "TimeCamp", withExtension: "gif")
        img_TodayCampGif.image = UIImage.sd_animatedGIF(with: NSData.init(contentsOf: url)! as Data)
        
        //COLLECTION VIEW SPACING B/W CELLS
        let layout = colVwBanner.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 15
        
        reloadData()
        manageForIPhone()
        NotificationCenter.default.addObserver(self, selector: #selector(GuestLandingPageVC.checkSubscription(_:)), name: Notification.Name("checkSubscription"), object: nil)
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            self.navigationController?.navigationBar.topItem?.title  = "HOME"
            Proxy.shared.showNavigationOnTopMenu(controller: self)
        }
    }
    
    
    @objc func btnMenuAction(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func checkSubscription(_ notification: NSNotification) {
        
        //Varinder8
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("checkSubscription"), object: nil)
        
        let userInfo = notification.object as! NSDictionary
        let type = userInfo.value(forKey: "API") as! String
        if type == "API" {
            
            let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "SubscriptionDetailVIew") as! SubscriptionDetailVIew
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let plan = userInfo.value(forKey: "plan") as! String
            self.getSubscriptionStatus()
        }
    }
    
    func addPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControl.Event.valueChanged)
        tblVwMain.refreshControl = refreshControl
        tblVwMain.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func reloadData() {
        getLandingPageData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.notifObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            if self?.playerController != nil && self?.player?.timeControlStatus == .playing {
                if (self?.guestLandingVMObj.BannerModelAry.count ?? 0) > 0 {
                    self?.playCount += 1
                    if self?.playCount ?? 0 < self?.guestLandingVMObj.BannerModelAry.count ?? 0 {
                        
                        let indexPath = NSIndexPath.init(row: self?.playCount ?? 0, section: 0)
                        self?.colVwBanner.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: .right)
                        
                        let bannerModelAryObj = self?.guestLandingVMObj.BannerModelAry[self?.playCount ?? 0]
                        self?.videoPlayerPlay(Url: bannerModelAryObj?.videoPlayLink ?? "", thumbURL:URL.init(string: "\(Apis.KVideosThumbURL)\(bannerModelAryObj?.bannerVideoImgThumb ?? "")"), isAutoPlay: true)
                    } else {
                        self?.playCount = 0
                        
                        let indexPath = NSIndexPath.init(row: self?.playCount ?? 0, section: 0)
                        self?.colVwBanner.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: .left)
                        
                        let bannerModelAryObj = self?.guestLandingVMObj.BannerModelAry[self?.playCount ?? 0]
                        self?.videoPlayerPlay(Url: bannerModelAryObj?.videoPlayLink ?? "", thumbURL:URL.init(string: "\(Apis.KVideosThumbURL)\(bannerModelAryObj?.bannerVideoImgThumb ?? "")"), isAutoPlay: true)
                    }
                    
                }
            }
            //            self?.player?.seek(to: CMTime.zero)
            //            self?.player?.play()
        }

        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            SelectAviatorImageObj = self
            headerDelegate = self
            view_HeaderView.btn_Home.isEnabled=false
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
            //        if KAppDelegate.isHomeScreenCalled {
            //        } else {
            //            KAppDelegate.isHomeScreenCalled = true
            //        }
            targetVw.isHidden = true
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        }
}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.view.setNeedsDisplay()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if !KAppDelegate.isGradiantShownForHome {
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
            
            let gradientLayer2:CAGradientLayer = CAGradientLayer()
            gradientLayer2.frame.size = view_GradiantRight.frame.size
            gradientLayer2.colors =
                [UIColor.white.withAlphaComponent(0).cgColor,UIColor.white.withAlphaComponent(1).cgColor]
            //        Use diffrent colors
            gradientLayer2.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer2.endPoint = CGPoint(x: 1.0, y: 1.0)
            //        view_GradiantRight.layer.addSublayer(gradientLayer2)
            KAppDelegate.isGradiantShownForHome=true
        } else {
            if self.player?.timeControlStatus != .playing {
                if videoVw != nil {
                self.player?.play()
                }
            }
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        KAppDelegate.isGradiantShownForHome=false
        self.viewDidAppear(false)
    }
    
    func getLandingPageData() {
        guestLandingVMObj.postHomeScreenApi(completionHandler: {(success) -> Void in
            if success {
                let bannerModelAryObj = self.guestLandingVMObj.BannerModelAry[0]
                
                var extraSpace = "\n"
                if UIDevice.current.userInterfaceIdiom != .pad { extraSpace = "" }
                
                let dict_BeforeLogin =  UserDefaults.standard.object(forKey: "BannerTextBeforeLogin") as! NSDictionary
                let dict_AfterLogin =  UserDefaults.standard.object(forKey: "BannerTextAfterLogin") as! NSDictionary
                
                let finalAfterLogin = "\(dict_AfterLogin["banner_text_1"] as! String) \n\(dict_AfterLogin["banner_text_2"] as! String) \n\(dict_AfterLogin["banner_text_3"] as! String) \n\(dict_AfterLogin["banner_text_4"] as! String)\n" + extraSpace
                
                let finalBeforeLogin = "\(dict_BeforeLogin["text_before_login_1"] as! String) \n\(dict_BeforeLogin["text_before_login_2"] as! String) \n\(dict_BeforeLogin["text_before_login_3"] as! String) \n\(dict_BeforeLogin["text_before_login_4"] as! String)" + extraSpace

                let auth = Proxy.shared.authNil()
                if auth != "" {
                    self.lblDescription.attributedText! = self.getAttributedText(text: "\(dict_AfterLogin["banner_text_5"] as! String)", completeText: finalAfterLogin)
                } else {
                    self.lblDescription.attributedText! = self.getAttributedText(text: "\(dict_BeforeLogin["text_before_login_5"] as! String)", completeText: finalBeforeLogin)
                }
                
                    DispatchQueue.main.async {
                        self.videoPlayerPlay(Url: bannerModelAryObj.videoPlayLink,thumbURL: URL.init(string: "\(Apis.KVideosThumbURL)\(bannerModelAryObj.bannerVideoImgThumb)"), isAutoPlay: false)
                    }

                self.tblVwMain.reloadData()
                self.colVwBanner.reloadData()
                self.refreshControl.endRefreshing()
                
                if !kisSubscribed {
                       //Varinder
                       NotificationCenter.default.removeObserver(self, name: NSNotification.Name("checkSubscription"), object: nil)
                    
                    let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "SubscriptionDetailVIew") as! SubscriptionDetailVIew
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }
    
    func getAttributedText(text:String!,completeText:String!) -> NSMutableAttributedString!{
        let attrString = NSMutableAttributedString(string: completeText)
        var sizes:CGFloat = 33.0
        if UIDevice.current.userInterfaceIdiom != .pad { sizes = 18 }
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Helvetica Bold", size: sizes)! ]
        let changedString = NSMutableAttributedString(string: text, attributes: myAttribute )
        let myRange = NSRange(location: 0, length: changedString.length) // range starting at location 17 with a lenth of 7: "Strings"
        changedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 61/255, green: 163/255, blue: 225/255, alpha: 1), range: myRange)
        
        attrString.append(changedString)
        return attrString
    }
    
        override func viewWillDisappear(_ animated: Bool) {
            if playerController != nil {
                //            if self.player?.timeControlStatus == .playing {
                self.player?.pause()
                //            }
                //            self.player = nil
                //            self.playerController.player = nil
                //            self.playerController = nil
                //            self.playerController.willMove(toParent: self)
                //            self.playerController.view.removeFromSuperview()
                //            self.playerController.removeFromParent()
            }
            
            NotificationCenter.default.removeObserver(self.notifObserver!)

//            if UIDevice.current.userInterfaceIdiom != .pad {
//                return
//            }
            self.img_Thumb.isHidden=false
        }
    
    //MARK:--> BUTTONS ACTIONS
    @IBAction func buttonOpenAd(_ sender: Any) {
        if self.guestLandingVMObj.AdvertisementModelAry.count != 0 {
            let ads_Model:AdvertisementModel = self.guestLandingVMObj.AdvertisementModelAry[0]
            
            guard let url = URL(string: ads_Model.bannerURL) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK:--> BUTTONS ACTIONS
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func btnGetAllAccess(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnStoreACtion(_ sender: Any) {
        //Proxy.shared.pushToNextVC(identifier: "CampStoreVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnExploreAction(_ sender: Any) { }
    
    @IBAction func btnCampFireAction(_ sender: Any) {
        Proxy.shared.presentAlert(withTitle: "", message: "In Progress", currentViewController: self)
        //Proxy.shared.pushToNextVC(identifier: "CamperUploadDetailVC", isAnimate: true, currentViewController: self)
    }
    
    //MARK:--> PROTOCOL FUNCTIONS
    func didSelected(index: Int) {
        if index == 0 {
            targetVw.isHidden = true
        } else if index == 1 {
            let auth = Proxy.shared.authNil()
            if auth != ""{
                Proxy.shared.pushToNextVC(identifier: "ProfileVC", isAnimate: true, currentViewController: self)
            } else {
                Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.login)", currentViewController: self)
            }
        }else if index == 2 {
            //            Proxy.shared.pushToNextVC(identifier: "CamperStaffVC", isAnimate: true, currentViewController: self)
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "CampStaff"
            self.navigationController?.pushViewController(nav, animated: true)
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
    
    @IBAction func btnRightFlow(_ sender: Any) {
        //        advertisementBanner(advertisementCountType: "Add" )
        
        self.colVwAds.scrollToItem(at:IndexPath(item: 1, section: 0), at: .right, animated: false)
        
        
    }
    
    @IBAction func btnLeftFlow(_ sender: Any) {
        //        advertisementBanner(advertisementCountType: "Subtract" )
    }
    
    func advertisementBanner(advertisementCountType : String) {
        
        /*
         if guestLandingVMObj.advertiementAry.count != 0 {
         if advertisementCountType == "Add" {
         for i in 0...guestLandingVMObj.advertiementAry.count+1  {
         let imgString = guestLandingVMObj.advertiementAry[i]
         
         imgVwbanner.sd_setImage(with: URL.init(string: "\(Apis.KAvertisementBannerUrl)\(imgString)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
         }
         } else {
         for i in 0...guestLandingVMObj.advertiementAry.count-1  {
         let imgString = guestLandingVMObj.advertiementAry[i]
         
         imgVwbanner.sd_setImage(with: URL.init(string: "\(Apis.KAvertisementBannerUrl)\(imgString)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
         }
         }
         }*/
    }
    
    //MARK:--> BUTTON TOUCH SCROLL COLLECTION VIEW ACTION
    @IBAction func btnLeftArrowAction(_ sender: Any) {
        let collectionBounds = self.colVwBanner.bounds
        let contentOffset = CGFloat(floor(self.colVwBanner.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func btnRightArrowAction(_ sender: Any) {
        let collectionBounds = self.colVwBanner.bounds
        let contentOffset = CGFloat(floor(self.colVwBanner.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
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
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.colVwBanner.contentOffset.y ,width : self.colVwBanner.frame.width,height : self.colVwBanner.frame.height)
        self.colVwBanner.scrollRectToVisible(frame, animated: true)
    }
    
    //MARK:--> PLAY VIDEO FUNCTION
    func videoPlayerPlay(Url: String,thumbURL:URL!,isAutoPlay:Bool) {
        if videoVw != nil {
            
            self.img_Thumb.isHidden=false
            let videoURL = URL(string: "\(Apis.KVideoURl)\(Url)") //http://techslides.com/demos/sample-videos/small.mp4
            
            if playerController != nil && isAutoPlay==true {
                
                self.img_Thumb.sd_setImage(with: thumbURL,placeholderImage: nil, completed: nil)
                
                currentItem = AVPlayerItem.init(url: videoURL!)
                player?.replaceCurrentItem(with: currentItem)
                player?.play()
                
            } else {
                
                self.img_Thumb.sd_setImage(with: thumbURL,placeholderImage: nil, completed: nil)
                
//                playerController  = AVPlayerViewController()
                player = AVPlayer(url: videoURL!)
                playerController.videoGravity = .resizeAspectFill
                playerController.player = player
                playerController.view = videoVw
                
                playerController.view.frame = videoVw.bounds
                playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                playerController.showsPlaybackControls=false
                //Devansh
                if (UIDevice.current.userInterfaceIdiom != .pad){
                    playerController.view.backgroundColor = .clear
                }else{
                    playerController.view.backgroundColor = .white
                }
                self.addChild(playerController)
                playerController.didMove(toParent: self)
                videoVw.addSubview(playerController.view)
                player?.play()
            }
            
            self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 600), queue: DispatchQueue.main, using: { time in
                if self.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
                    if let isPlaybackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp {
                        //do what ever you want with isPlaybackLikelyToKeepUp value, for example, show or hide a activity indicator.
                        self.img_Thumb.isHidden=true
                    }
                }
            })
        }
        // player?.automaticallyWaitsToMinimizeStalling = false
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

//MARK:- Subcription Functions
extension GuestLandingPageVC:SKProductsRequestDelegate
{
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print(response)
        
    }
    
    func fetchProducts() {
        
        let productIDs = Set(IAP_Products)
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error for request: \(error.localizedDescription)")
    }
    
    //MARK:- Check Subscription status
    func getSubscriptionStatus() {
        
        SubscriptionService.shared.uploadReceipt { (success, subscription) in
            if success {
                
                if subscription != nil {
                    let expiryDate = subscription?.expiresDate
                    let currentDate = Date()
                    
                    if expiryDate?.compare(currentDate) == .orderedSame || expiryDate?.compare(currentDate) == .orderedDescending {
                        print("acrive")
                    } else {
                        Proxy.shared.logout {
                            Proxy.shared.rootWithoutDrawer("TabbarViewController")
                        }
                    }
                } else {
                    
                    // push Baltej
                    
                    //                    let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "SubscriptionDetailVIew") as! SubscriptionDetailVIew
                    //
                    //                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    //                                        Proxy.shared.logout
                    //                                            {
                    //                                                Proxy.shared.rootWithoutDrawer("TabbarViewController")
                    //                                        }
                }
            }
        }
    }
}

//MARK:- Manage Home screen UI for iPhone
extension GuestLandingPageVC {
    
    func manageForIPhone() {
        if UIDevice.current.userInterfaceIdiom != .pad {
        if let leftMenuController = SideMenuManager.default.menuLeftNavigationController?.viewControllers.first as? LeftMenuViewController{
            leftMenuController.delegate = self;
        }
        
        DispatchQueue.main.async {
            self.btnGetAllAccess.layer.cornerRadius = self.btnGetAllAccess.frame.height/2
            self.btnGetAllAccess.layer.masksToBounds = true
        }
        }
    }
    
}
