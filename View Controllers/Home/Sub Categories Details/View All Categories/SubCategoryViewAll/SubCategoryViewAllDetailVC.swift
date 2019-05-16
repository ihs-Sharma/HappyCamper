//
//  SubCategoryViewAllDetailVC.swift
//  HappyCamper
//
//  Created by wegile on 15/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit
import AVFoundation

class SubCategoryViewAllDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SelectMenuOption, SelectAviatorImage,TopHeaderViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var imgVwLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwAviator: SetCornerImageView!
    @IBOutlet weak var menuVw: UIView!
    @IBOutlet weak var txtFldSearch: UITextField!
    
    @IBOutlet weak var lbl_BannerTitle: UILabel!
    @IBOutlet weak var videoVw: UIView!
    @IBOutlet weak var view_Gradiant: UIView!
    @IBOutlet weak var view_GradiantLeft: UIView!
    @IBOutlet weak var img_Thumb: UIImageView!
    
    //PLAYER TASK
    var player : AVPlayer?
    var playerController  : AVPlayerViewController?
    var img_Thumbnail = String()

    //MARK:--> VARIABLES
    var userCatUrl = String()
    var currentPage = 1
    var numberItems = 10
    var VideoDetailModelAry = [VideoDetailModel]()
    var viewController : MenuDrawerController?
    
    var bannerContent = String()
    var bannerName = String()
    
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
    
    func reloadData() {
        VideoDetailModelAry.removeAll()
        self.getVideoDetailApi(searchString: "") { (banner_Data) in
            if banner_Data.count > 0 {
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.lbl_BannerTitle.text! = banner_Data["category_name"]!.stringValue
                
                    let thumbnail:URL!
                    if self.img_Thumbnail != "" {
                        thumbnail = URL.init(string: "\(Apis.KVideosThumbURL)\(self.img_Thumbnail)")
                    } else {
                        thumbnail = URL.init(string: "https://www.happycamperlive.com/assets/images/about-thumbnail.png")
                    }
                DispatchQueue.main.async {
                    self.videoPlayerPlay(Url: banner_Data["banner_content"]!.stringValue,thumbURL: thumbnail)
                }
                }
            }
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
        colVw.delegate = self
        colVw.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !KAppDelegate.isGradiantShownForSubEpisodes {
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
        
            KAppDelegate.isGradiantShownForSubEpisodes=true
        } else {
            if self.player?.timeControlStatus != .playing {
                if videoVw != nil {
                    self.player?.play()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.img_Thumb.isHidden=false
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        KAppDelegate.isGradiantShownForSubEpisodes=false
}
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared
            .popToBackVC(isAnimate: true, currentViewController: self)
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
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        VideoDetailModelAry.removeAll()
//        getVideoDetailApi(searchString : txtFldSearch.text!)
        self.getVideoDetailApi(searchString: txtFldSearch.text!) { (banner_Data) in
            
        }
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VideoDetailModelAry.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let VideoDetailModelAryObj = VideoDetailModelAry[indexPath.row]
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "SubCategoryViewAllDetailCVC", for: indexPath) as! SubCategoryViewAllDetailCVC
        cell.lblTitle.text! =  VideoDetailModelAryObj.videoTitle
        
        cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(VideoDetailModelAryObj.videoImageThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        
        let string = VideoDetailModelAryObj.videoDescription
        cell.lblDescription.text! = string.htmlToString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VideoDetailModelAryObj = VideoDetailModelAry[indexPath.row]
        Proxy.shared.pushToNextSubCatVC(identifier: "SubCategoryDetailVC", isAnimate: true, currentViewController: self, VideoId: VideoDetailModelAryObj.videoId,headerName:VideoDetailModelAryObj.headerCategoryUrl , currentContName: "", activityType: "\(userCatUrl)", categorySubValue: "1", fromController: "DetailSubVideos")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 226.0, height: 191.0)
        } else {
//            return CGSize(width: colVw.frame.width/2, height: 140.0)
            return CGSize(width : UIScreen.main.bounds.width/2.2, height : 150.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 10
        } else {
            return 5
        }
    }
    
    //MARK:--> SIGN UP API FUNCTION
    func getVideoDetailApi(searchString : String,completionHandler: @escaping (_ banner_Data:[String : JSON]) -> Void) {
        
        let param = [
            "page_no"             :   NSNumber(integerLiteral: currentPage),
            "page_size"           :   NSNumber(integerLiteral: numberItems),
            "activity_type"       :   "\(userCatUrl)" ,
            "form_search_key"     :   "\(searchString)" ,
            "all_videos"          :   NSNumber(booleanLiteral: true),
            "sub_category"        :   NSNumber(booleanLiteral: true)
            
            ] as [String:Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetCategoriesItems)", params: param, showIndicator: true, completion: { (jsonData) in
            var AppResponse = Int()
            AppResponse = jsonData["app_response"] as? Int ?? 0
            
            if AppResponse == 200 {
                if let CatImageVwAry = jsonData["categories_with_images"] as? NSDictionary {
                    
                    if let resultDict = jsonData["categories_details"] as? NSDictionary {
                        self.bannerName = resultDict["category_name"] as? String ?? ""
                        self.bannerContent = resultDict[""] as? String ?? "banner_content"
                    }
                    
                    if let videoItemAry = CatImageVwAry["video_items"] as? NSArray {
                        if videoItemAry.count > 0 {
                            for i in 0..<videoItemAry.count {
                                if let videoDict = videoItemAry[i] as? NSDictionary {
                                    let VideoDetailModelObj = VideoDetailModel()
                                    VideoDetailModelObj.getVideoDetailDict(dict: videoDict)
                                    self.VideoDetailModelAry.append(VideoDetailModelObj)
                                }
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.colVw.reloadData()
                }

                guard let jsonResult = JSON.init(jsonData).dictionary else {
                    return
                }
                
                if let banner_Data = jsonResult["results"]?.dictionary {
                    self.img_Thumbnail = jsonResult["cat_thumbnail"]!.stringValue
                    completionHandler(banner_Data)
                }
                
            }
            Proxy.shared.hideActivityIndicator()
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
    
    //MARK:--> PLAY VIDEO  FUNCTION
    func videoPlayerPlay(Url: String,thumbURL:URL!) {
        self.img_Thumb.isHidden=false
        
        let videoURL = URL(string: "\(Apis.KVideoURl)\(Url)")
        if self.playerController != nil {
            
            self.img_Thumb.sd_setImage(with: thumbURL,placeholderImage: nil, completed: nil)
            
            let currentItem = AVPlayerItem.init(url: videoURL!)
            self.player?.replaceCurrentItem(with: currentItem)
            self.player?.play()
            
        } else {
            self.img_Thumb.sd_setImage(with: thumbURL,placeholderImage: nil, completed: nil)
            
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
                    self.img_Thumb.isHidden=true
                }
            }
        })
    }
}
