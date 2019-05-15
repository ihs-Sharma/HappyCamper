//
//  CampfireVC.swift
//  HappyCamper
//
//  Created by Wegile on 08/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import SwiftyJSON
import MobileCoreServices

class AVPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

// Left Section Stull Cell
class CampfireStuffCell: UITableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var btn_ShareStuff: UIButton!
    
}

// Left Section Contest Cell
class CampfireContestCell: UITableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var img_Item: UIImageView!
    @IBOutlet weak var view_Content: UIView!
    
    var player: AVPlayer!
    var playerController  : AVPlayerViewController!
    
    override func awakeFromNib() {
        //        view_Content.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    func initializeVideos(videoString:String!) {
        
        // convert the path string to a url
        let videoUrl = URL.init(string: "\(Apis.KContestVideo)\(String(describing: videoString!))")
        
        self.player = AVPlayer(url: videoUrl!)
        playerController  = AVPlayerViewController()
        playerController.player = self.player
        playerController.view = view_Content
        
        playerController.view.frame = view_Content.bounds
        playerController.videoGravity = .resizeAspectFill
        playerController.view.backgroundColor = .black
        
        view_Content.addSubview(playerController.view)
        //        self.player.play()
        
    }
}

// Right Section updates Cell
class CampfireNewUpdatedCell: UITableViewCell {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var btn_Like: UIButton!
    @IBOutlet weak var btn_View: UIButton!
    @IBOutlet weak var btn_ClickLike: UIButton!
    @IBOutlet weak var img_Like: UIImageView!
    
    @IBOutlet weak var _VideoView: AVPlayerView!
    @IBOutlet weak var shadow_View: UIView!
    
    var player: AVPlayer!
    var playerController  : AVPlayerViewController!
    
    func initializeVideos(videoString:String!) {
        // convert the path string to a url
        let videoUrl = URL.init(string: "\(Apis.KCampfireVideoUrl)\(String(describing: videoString!))")
        
        // initialize the video player with the url
        self.player = AVPlayer(url: videoUrl!)
        playerController  = AVPlayerViewController()
        playerController.player = self.player
        playerController.view = _VideoView
        
        // make the layer the same size as the container view
        playerController.view.frame = _VideoView.bounds
        playerController.videoGravity = .resizeAspectFill
        playerController.view.backgroundColor = .black
        
        _VideoView.addSubview(playerController.view)
        //        self.player.play()
    }
}

class CampfireVC: UIViewController,TopHeaderViewDelegate ,SelectAviatorImage,AVPlayerViewControllerDelegate {
    
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var tblLeft_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var img_Top_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblCounselor_HeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var tbl_LeftItems: UITableView!
    @IBOutlet weak var tbl_Counselor: UITableView!
    
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var banner_VideoView: AVPlayerView!
    @IBOutlet weak var tour_VideoView: UIView!
    
    @IBOutlet weak var view_GradiantLeft: UIView!
    @IBOutlet weak var view_GradiantRight: UIView!
    @IBOutlet weak var view_Container: UIView!
    @IBOutlet weak var view_Container_HeightConstraint: NSLayoutConstraint!
    
    var player: AVPlayer?
    var player_Tour: AVPlayer!
    var playerController  : AVPlayerViewController!
    
    var notificationObserver:NSObjectProtocol?
    var viewController : MenuDrawerController?
    
    //Swift Array's
    var arr_StuffItems:[JSON] = [ ]
    var arr_Contests:[JSON] = [ ]
    var arr_Advertisements1:[Advertisement] = [ ]
    var arr_Advertisements2:[Advertisement] = [ ]
    var arr_HotNews:[FeaturedItems] = [ ]
    var arr_FeatNews:[FeaturedItems] = [ ]
    var arr_NewNews:[FeaturedItems] = [ ]
    var arr_CounselorsWeek:[JSON] = [ ]
    var arr_CamperWeek:[JSON] = [ ]
    var arr_Advertisements:[JSON] = [ ]

    var camperCount:Int = 0
    var counselorCount:Int = 0
    var numberOfAds:Int = 0
    var numberOfAdsData:Int = 0

    var isSection:String!
    //MARK:--> Select Profile Image
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
    
    func setBackToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
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
        isSection = "hot"
        self.title  = "CAMPFIRE"
        // Do any additional setup after loading the view.
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            view_HeaderView.btn_Campfire.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            
            for view in view_HeaderView.subviews {
                if let lbl = view.viewWithTag(105) as? UILabel { lbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)  }
            }
            
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            targetVw.isHidden = true
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        }
        
        //Set Content Size
        self.tbl_LeftItems.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        self.tbl_Counselor.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        
        
        //Play Tour Video
        self.initializeTourVideoPlayer()
        
        tbl_LeftItems.sectionHeaderHeight = 0.0;
        tbl_LeftItems.sectionFooterHeight = 0.0;
        
        //Load Data
        self.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getHotUpdatesConstraint), name: NSNotification.Name(rawValue: "UpdateHotNewsHeight"), object: nil)
        
    }
    
    
    @objc func getHotUpdatesConstraint(_ notification: Notification) {
        if (notification.userInfo!["Height"] as? Float) != nil {
            DispatchQueue.main.async {
                //                self.view_Container_HeightConstraint.constant = CGFloat(object)
            }
        }
    }
    
    func reloadData() {
        self.CampfireDetailApi { }
    }
    
    @IBAction func selectUpdates(sender:UIButton) { }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Content Size for Left Stuff Tableview
        if let obj = object as? UITableView {
            if obj == self.tbl_LeftItems && keyPath == "contentSize" {
                DispatchQueue.main.async {
                    self.tblLeft_HeightConstraint.constant = self.tbl_LeftItems.contentSize.height
                }
            }
        }
        
        // Content Size for Counselor Tableview
        if let obj = object as? UITableView {
            if obj == self.tbl_Counselor && keyPath == "contentSize" {
                DispatchQueue.main.async {
                    self.tblCounselor_HeightConstraint.constant = self.tbl_Counselor.contentSize.height
                }
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            SelectAviatorImageObj = self
            headerDelegate = self
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
            targetVw.isHidden = true
        }
        
        self.notificationObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.self.player?.currentItem, queue: .main) { [weak self] _ in
            //            if self?.playerController != nil && self?.player_Tour?.timeControlStatus == .playing {
            //                self?.player_Tour?.seek(to: CMTime.zero)
            //                self?.player_Tour?.play()
            //            }
            if  self?.player?.timeControlStatus == .playing {
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.notificationObserver!)
        if self.playerController != nil {
            self.player_Tour?.pause()
        }
        
        if  self.player != nil {
            self.player?.pause()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !KAppDelegate.isGradiantShownForCampfire {
        let gradientLayer2:CAGradientLayer = CAGradientLayer()
        gradientLayer2.frame.size = view_GradiantRight.frame.size
        gradientLayer2.colors =
            [UIColor.black.withAlphaComponent(0).cgColor,UIColor.black.withAlphaComponent(1).cgColor]
        //        Use diffrent colors
        gradientLayer2.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer2.endPoint = CGPoint(x: 1.0, y: 1.0)
        view_GradiantRight.layer.addSublayer(gradientLayer2)
        
        let gradientLayer1:CAGradientLayer = CAGradientLayer()
        gradientLayer1.frame.size = view_GradiantLeft.frame.size
        gradientLayer1.startPoint = CGPoint(x: 0.0, y: 0.5) //x = left to right
        gradientLayer1.endPoint = CGPoint(x: 1.0, y: 0.5) // x = right to left
        gradientLayer1.colors =
            [UIColor.black.withAlphaComponent(1).cgColor,UIColor.black.withAlphaComponent(0).cgColor]
        //        Use diffrent colors
        view_GradiantLeft.layer.addSublayer(gradientLayer1)
            KAppDelegate.isGradiantShownForCampfire=true

        } else {
        if self.player_Tour?.timeControlStatus != .playing {
            self.player_Tour?.play()
        }
        
        if self.player?.timeControlStatus != .playing {
            self.player?.play()
        }
        }
    }
    
}

//MARK:- Dropdown Options
extension CampfireVC:SelectMenuOption {
    
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
    
}

//MARK:- Initialized Players
extension CampfireVC {
    
    //Banner Video
    func initializeBannerVideoPlayer(videoString:String!) {
        
        // convert the path string to a url
        let videoUrl = URL.init(string: "\(Apis.KBannerVideo)\(String(describing: videoString!))")
        // initialize the video player with the url
        self.player = AVPlayer(url: videoUrl!)
        
        // create a video layer for the player
        let castedLayer = banner_VideoView.layer as! AVPlayerLayer
        castedLayer.player = self.player
        
        // make the video fill the layer as much as possible while keeping its aspect size
        castedLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // add the layer to the container view
        self.player?.play()
    }
    
    //Tour Video
    func initializeTourVideoPlayer() {
        
        // convert the path string to a url
        let videoUrl = URL.init(string: "\(Apis.KBannerVideo)1549459606995-UploadVideo_v3.mp4")
        
        playerController  = AVPlayerViewController()
        
        // initialize the video player with the url
        player_Tour = AVPlayer(url: videoUrl!)
        playerController.player = player_Tour
        playerController.view = tour_VideoView
        
        // make the layer the same size as the container view
        playerController.view.frame = tour_VideoView.bounds
        playerController.videoGravity = .resize
        playerController.view.backgroundColor = .black
        
        playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addChild(playerController)
        playerController.didMove(toParent: self)
        tour_VideoView.addSubview(playerController.view)
//        player_Tour.play()
    }
}

//MARK:- Left TableView Delegates and Datasources
extension CampfireVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tbl_LeftItems {
            return 2+self.arr_Advertisements.count
        } else {
            return self.camperCount+self.counselorCount
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tbl_LeftItems {
            if section == 0 {
               return 0
            } else {
               return 48
            }
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tbl_LeftItems {
            if section == 0 {
                return nil
            }  else if section == 1 {
                return addHeadersView(title: "CONTESTS")
            } else {
                if self.arr_Advertisements.count > 0 {
                    if section >= 3 {
                        self.numberOfAds += 1
                    }
                    return addHeadersView(title: self.arr_Advertisements[self.numberOfAds]["title"].stringValue)
                } else {
                    return addHeadersView(title: "CAMPFIRE 2")
                }
            }
        } else {
            if section == 0 {
                return addHeadersView(title: "CAMPERS OF THE WEEK")
            } else  {
                return addHeadersView(title: "COUNSELORS OF THE WEEK")
            }
        }
    }
    
    func addHeadersView(title:String) -> UIView {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tbl_LeftItems.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width+15, height: headerView.frame.height-10)
        label.text = title
        label.textAlignment = .center
        label.backgroundColor = UIColor(red:0.32, green:0.12, blue:0.52, alpha:1.0)
        label.font = UIFont.boldSystemFont(ofSize: 20) // my custom font
        label.textColor = .white
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl_LeftItems {
            if indexPath.section == 0 || indexPath.section == 1 {
                return UITableView.automaticDimension
            } else {
                return 250
            }
        } else {
            return 180
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_LeftItems {
            if section == 0 {
                return arr_StuffItems.count
            } else if section == 1 {
                return  self.arr_Contests.count
            } else {
                return  1
            }
        } else {
            if section == 0 {
                return self.camperCount
            } else {
                return  self.counselorCount
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_LeftItems {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StuffCell", for: indexPath) as! CampfireStuffCell
                cell.lbl_Title.text = self.arr_StuffItems[indexPath.row]["title"].stringValue
                cell.lbl_Desc.text = self.arr_StuffItems[indexPath.row]["desc"].stringValue
                cell.btn_ShareStuff.addTarget(self, action: #selector(self.UploadFile), for: .touchUpInside)
                
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContestCell", for: indexPath) as! CampfireContestCell
                cell.lbl_Title.text = self.arr_Contests[indexPath.row]["title"].stringValue
                cell.lbl_Desc.text = self.arr_Contests[indexPath.row]["description"].stringValue
                if self.arr_Contests[indexPath.row]["type"].stringValue == "image" {
                    cell.img_Item.sd_setImage(with: URL.init(string: "\(Apis.KContestImage)\(self.arr_Contests[indexPath.row]["content"].stringValue)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                } else if self.arr_Contests[indexPath.row]["type"].stringValue == "video" {
                    cell.img_Item.sd_setImage(with: URL.init(string: "\(Apis.KContestImage)\(self.arr_Contests[indexPath.row]["thumbnail"].stringValue)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                    cell.img_Item.isUserInteractionEnabled=true
                    
                    //Remove all subview before add
                    for views in cell.img_Item.subviews {
                        views.removeFromSuperview()
                    }
                    
                    let bnt_PlayVideo = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: cell.img_Item.frame.width, height: cell.img_Item.frame.height))
                    bnt_PlayVideo.tag = indexPath.row
                    bnt_PlayVideo.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                    bnt_PlayVideo.addTarget(self, action: #selector(self.openVideo(sender:)), for: .touchUpInside)
                    cell.img_Item.addSubview(bnt_PlayVideo)
                    
                    let img_PlayIcon = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 35, height: 35))
                    img_PlayIcon.center = CGPoint.init(x: bnt_PlayVideo.center.x, y: bnt_PlayVideo.center.y)
                    img_PlayIcon.isUserInteractionEnabled=false
                    img_PlayIcon.image = UIImage.init(named: "play-button copy")
                    bnt_PlayVideo.addSubview(img_PlayIcon)
                    
                } else if self.arr_Contests[indexPath.row]["type"].stringValue == "doc" {
                    cell.img_Item.image = UIImage.init(named: "icon_File")
                    cell.img_Item.contentMode = .scaleAspectFit
                }
                DispatchQueue.main.async {
                    let btn = UIButton.init(frame: CGRect.init(x: cell.lbl_Desc.frame.origin.x, y: 5, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height))
                    btn.addTarget(self, action: #selector(CampfireVC.didTapOnContest), for: .touchUpInside)
                    btn.tag = indexPath.row
                    cell.contentView.addSubview(btn)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdCell", for: indexPath) as! CampfireAdCell
                //                if indexPath.section == 2 {
                if indexPath.section >= 3 {
                    self.numberOfAdsData += 1
                }
                cell.setBannerData(ads: self.arr_Advertisements[self.numberOfAdsData]["items"].arrayValue)
                //             } else {
                //                   cell.setBannerData(ads: self.arr_Advertisements2)
                //             }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CounselorCell", for: indexPath) as! CounselorsCell
            if indexPath.section == 0 {
                cell.reloadCollectionData(json:arr_CamperWeek)
            } else if indexPath.section == 1 {
                cell.reloadCollectionData(json:arr_CounselorsWeek)
            }
      
            cell.delegate_SelectCounselor=self
            return cell
        }
    }
    
    @objc func didTapOnContest(_ sender: UIButton) {
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
        
        let contestObj = arr_Contests[sender.tag]
        let id = contestObj["_id"].stringValue
        let contestVC = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "ContestVC") as! ContestVC
        contestVC.item_id = id
        self.navigationController?.pushViewController(contestVC, animated: true)
    }
    
    @objc func UploadFile() {
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
        let nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "UploadFilePopup") as! UploadFilePopup
        self.present(nav, animated: true, completion: nil)
    }
    
    //Open Play video full screen
    @objc func openVideo(sender:UIButton) {
        let videoUrl = self.arr_Contests[sender.tag]["content"].stringValue
        if videoUrl != "" {
            let videoURL = URL(string: "\(Apis.KContestVideo)\(videoUrl)")
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.allowsPictureInPicturePlayback=true
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: .zero)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        KAppDelegate.isGradiantShownForCampfire=false
        numberOfAdsData=0
        numberOfAds=0
        if fromInterfaceOrientation.isLandscape {
            NSLayoutConstraint.setMultiplier(0.5, of: &self.img_Top_HeightConstraint)
        } else if fromInterfaceOrientation.isPortrait {
            NSLayoutConstraint.setMultiplier(0.5, of: &self.img_Top_HeightConstraint)
        }
        DispatchQueue.main.async {
            self.tbl_LeftItems.reloadData()
            self.tbl_Counselor.reloadData()
        }
        self.view.layoutIfNeeded()
    }
}

//MARK:- JSON
extension CampfireVC:SelectCounselorsDelegate {
    
    func selectCounselor(index: Int, isFrom: Bool,user_Name:String) {
        let nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "CastScreenVC") as! CastScreenVC
        nav.isFromCampfire="Campfire"
        nav.selectedUserIndex = index
        nav.castName = user_Name
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    //MARK:--> CAMPFIRE DETAILS
    func CampfireDetailApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "user_id":"\(Proxy.shared.userId())",
            "page_type" : "be_on_happy_camper_live"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCampFire)", params: param, showIndicator: true, completion: { (jsonData) in
            
            var appResponse = Int()
            
            appResponse = jsonData["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                guard let jsonResult = JSON.init(jsonData).dictionary else {
                    return
                }
                
                //Array Removed
                self.arr_StuffItems.removeAll()
                self.arr_Contests.removeAll()
                self.arr_Advertisements1.removeAll()
                self.arr_Advertisements2.removeAll()
                self.arr_FeatNews.removeAll()
                self.arr_HotNews.removeAll()
                
                if let arr_Ad = jsonResult["advertisementCamp"]?.arrayValue {
                    if arr_Ad.count > 0 {
                        for i in 0..<arr_Ad.count {
                            if let ad = arr_Ad[i].dictionary {
                                self.arr_Advertisements.append(JSON.init(ad))
                            }
                        }
                    }
                }
//
                
                // Get Advertisements Array
          /*      if let arr_Ads = jsonResult["advertisement_one"]?.arrayValue {
                    if arr_Ads.count > 0 {
                        for i in 0..<arr_Ads.count {
                            if let ad = arr_Ads[i].dictionary {
                                self.arr_Advertisements1.append(Advertisement.init(_adTitle: "", _id: 0, _status: "", _url: ad["url"]!.stringValue, _title: ad["title"]!.stringValue, _type: "", _banners: ad["banner"]!.stringValue))
                            }
                        }
                    }
                }
                
                // Get Advertisements Array
                if let arr_Ads = jsonResult["advertisement_two"]?.arrayValue {
                    if arr_Ads.count > 0 {
                        for i in 0..<arr_Ads.count {
                            if let ad = arr_Ads[i].dictionary {
                                self.arr_Advertisements2.append(Advertisement.init(_adTitle: "", _id: 0, _status: "", _url: ad["url"]!.stringValue, _title: ad["title"]!.stringValue, _type: "", _banners: ad["banner"]!.stringValue))
                            }
                        }
                    }
                }*/
                
                if let arr_Counselors = jsonResult["camper_ofday_results"]?.arrayValue {
                    if arr_Counselors.count > 0 {
                        for i in 0..<arr_Counselors.count {
                            if let dict = arr_Counselors[i].dictionary {
                                if dict["type"]!.stringValue == "camper" {
                                    self.camperCount = 1
                                    self.arr_CamperWeek.append(JSON.init(dict))
                                } else if dict["type"]!.stringValue == "counselor"{
                                    self.counselorCount = 1
                                    self.arr_CounselorsWeek.append(JSON.init(dict))
                                }
                            }
                        }
                    }
                }
                
                // Get banner Array
                if let bannerAry = jsonResult["banners"]?.arrayValue {
                    if bannerAry.count > 0 {
                        for i in 0..<bannerAry.count {
                            if let bannerDict = bannerAry[i].dictionary { self.initializeBannerVideoPlayer(videoString: bannerDict["content"]?.stringValue) }
                        }
                    }
                }
                
                // Get contests Array
                if let arr_contest = jsonResult["contests"]?.arrayValue {
                    if arr_contest.count > 0 {
                        for i in 0..<arr_contest.count { self.arr_Contests.append(arr_contest[i]) }
                    }
                }
                
                // Get left section data Array
                if let arr_StuffItems = jsonResult["left_section_content"]?.arrayValue {
                    if arr_StuffItems.count > 0 {
                        for i in 0..<arr_StuffItems.count { self.arr_StuffItems.append(arr_StuffItems[i]) }
                    }
                }
                
                if let campfireResultAry = jsonResult["campfires_video_results"]?.arrayValue {
                    if campfireResultAry.count > 0 {
                        for i in 0..<campfireResultAry.count {
                            if let dict = campfireResultAry[i].dictionary {
                                if let updateDict = dict["video_details"]?.dictionary {
                                    
                                    if updateDict["is_featured"]?.boolValue == true {
                                        self.arr_FeatNews.append(FeaturedItems.init(_id:updateDict["_id"]!.stringValue,_url: updateDict["video_url"]!.stringValue, _title: updateDict["video_title"]!.stringValue, _isFeatured: updateDict["is_featured"]!.boolValue, _desc: updateDict["video_description"]!.stringValue,_like:dict["video_is_liked"]!.boolValue,_views:dict["video_views"]!.intValue,_likes:dict["total_likes"]!.intValue))
                                    }
                                    //                                    if updateDict["is_featured"]?.boolValue == false || updateDict["is_hot"]?.boolValue == false {
                                    self.arr_NewNews.append(FeaturedItems.init(_id:updateDict["_id"]!.stringValue,_url: updateDict["video_url"]!.stringValue, _title: updateDict["video_title"]!.stringValue, _isFeatured: updateDict["is_featured"]!.boolValue, _desc: updateDict["video_description"]!.stringValue,_like:dict["video_is_liked"]!.boolValue,_views:dict["video_views"]!.intValue,_likes:dict["total_likes"]!.intValue))
                                    
                                    //                                    }
                                    if updateDict["is_hot"]?.boolValue == true {
                                        self.arr_HotNews.append(FeaturedItems.init(_id:updateDict["_id"]!.stringValue,_url: updateDict["video_url"]!.stringValue, _title: updateDict["video_title"]!.stringValue, _isFeatured: updateDict["is_featured"]!.boolValue, _desc: updateDict["video_description"]!.stringValue,_like:dict["video_is_liked"]!.boolValue,_views:dict["video_views"]!.intValue,_likes:dict["total_likes"]!.intValue))
                                    }
                                }
                            }
                        }
                    }
                }
             
                self.perform(#selector(self.setHotUpdatesData), with: nil, afterDelay: 1.5)
                
                DispatchQueue.main.async {
                    self.tbl_LeftItems.reloadData()
                    if self.arr_CamperWeek.count == 0 && self.arr_CounselorsWeek.count == 0 {
                        self.tblCounselor_HeightConstraint.constant=0
                    } else {
                    self.tbl_Counselor.reloadData()
                    }
                }
                completion()
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    @objc func setHotUpdatesData() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetHotUpdatesNews"), object: self.arr_HotNews)
        
        do {
            let dataOfNewUpdates = try JSONEncoder().encode(self.arr_NewNews)
            let dataOfFeaturedUpdates = try JSONEncoder().encode(self.arr_FeatNews)
            UserDefaults.standard.set(dataOfNewUpdates, forKey: "ArrayOfNewUpdates")
            UserDefaults.standard.set(dataOfFeaturedUpdates, forKey: "ArrayOfFeaturedUpdates")
        } catch {
            print(error)
        }
        
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetNewUpdatesNews"), object: self.arr_NewNews)
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetFeaturedUpdatesNews"), object: self.arr_FeatNews)
    }
    
}

