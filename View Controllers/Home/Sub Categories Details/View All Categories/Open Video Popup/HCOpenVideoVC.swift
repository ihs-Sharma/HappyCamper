//
//  HCOpenVideoVC.swift
//  HappyCamper
//
//  Created by wegile on 02/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit
import AVFoundation

typealias CompletionWithImage = (_ image:UIImage) -> Void
protocol ManagePlyersDelegte{
    func didPlayVideo(status:Bool)
    
}
var playDelegate : ManagePlyersDelegte?

class HCOpenVideoVC: UIViewController {
    
    @IBOutlet weak var tbl_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_Video: UIView!
    @IBOutlet weak var view_GradiantBottom: UIView!
    @IBOutlet weak var view_GradiantLeft: UIView!
    @IBOutlet weak var view_GradiantRight: UIView!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnLikedRef: UIButton!
    @IBOutlet weak var btn_ReadAlong: UIButton!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var img_Thumb: UIImageView!
    @IBOutlet weak var scroll_: UIScrollView!
    
    @IBOutlet weak var tblVw: UITableView!
    var SubCategoriesVideoVMObj =  SubCategoriesVideoVM()
    var SubCategoryViewAllTopModelAry = [SubCategoryViewAllTopModel]()
    
    var likeState = Int()
    var str_ActivityType : String!
    var str_CategoryValue : String!
    var str_VideoId : String!
    var str_VideoUrl : String!
    var str_FromController : String!
    
    var str_Transcription : String = ""
    var str_VideoTitle : String = ""
    
    var player : AVPlayer?
    var playerController  : AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            //only apply the blur if the user hasn't disabled transparency effects
            if !UIAccessibility.isReduceTransparencyEnabled {
                self.view.backgroundColor = .clear
                
                let blurEffect = UIBlurEffect(style: .light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //always fill the view
                blurEffectView.frame = self.view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
                self.view.sendSubviewToBack(blurEffectView)
            } else {
                self.view.backgroundColor = .black
            }
        }
        
        self.perform(#selector(self.getData), with: nil, afterDelay: 2)
        self.tblVw.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            if !(self.tblVw.contentSize.height >= 300) {
                self.tbl_HeightConstraint.constant = 300
            } else {
                self.tbl_HeightConstraint.constant = self.tblVw.contentSize.height
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SelectedVideoObj = self
    }
    
    @objc func getData() {
        getCategoryDetailData()
    }
    
    override func viewDidAppear(_ animated: Bool)  {
        if !KAppDelegate.isGradiantShown {
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size = view_GradiantBottom.frame.size
            gradientLayer.colors =
                [UIColor.black.withAlphaComponent(0).cgColor,UIColor.black.withAlphaComponent(1).cgColor]
            //        Use diffrent colors
            view_GradiantBottom.layer.sublayers=nil
            view_GradiantBottom.layer.addSublayer(gradientLayer)
            
            let gradientLayer1:CAGradientLayer = CAGradientLayer()
            gradientLayer1.frame.size = view_GradiantLeft.frame.size
            gradientLayer1.startPoint = CGPoint(x: 0.0, y: 0.5) //x = left to right
            gradientLayer1.endPoint = CGPoint(x: 1.0, y: 0.5) // x = right to left
            gradientLayer1.colors =
                [UIColor.black.withAlphaComponent(1).cgColor,UIColor.black.withAlphaComponent(0).cgColor]
            //        Use diffrent colors
            view_GradiantLeft.layer.sublayers=nil
            view_GradiantLeft.layer.addSublayer(gradientLayer1)
            KAppDelegate.isGradiantShown=true
        }
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        KAppDelegate.isGradiantShown=false
        self.viewDidAppear(false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if playerController != nil {
            if self.player?.timeControlStatus == .playing {
                self.player?.pause()
            }
            self.player = nil
            self.playerController?.player = nil
            self.playerController = nil
            self.playerController?.willMove(toParent: self)
            self.playerController?.view.removeFromSuperview()
            self.playerController?.removeFromParent()
        }
    }
    
    @IBAction func buttonCross(_ sender: Any) {
        
        playDelegate?.didPlayVideo(status: true)
        self.tblVw.removeObserver(self, forKeyPath: "contentSize", context: nil)
        if playerController != nil {
            if self.player?.timeControlStatus == .playing {
                self.player?.pause()
            }
            self.player = nil
            self.playerController?.player = nil
            self.playerController = nil
            self.playerController?.willMove(toParent: self)
            self.playerController?.view.removeFromSuperview()
            self.playerController?.removeFromParent()
        }
//        self.willMove(toParent: nil)
//        self.view.removeFromSuperview()
//        self.removeFromParent()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func playVideo(_ sender: Any) {
        if (str_VideoUrl != nil) {
            if str_VideoUrl != "" {
                let videoURL = URL(string: str_VideoUrl)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.allowsPictureInPicturePlayback=true
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
    }
    
    @IBAction func btnLikedAction(_ sender: Any) {
        
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            if self.likeState == 0 {
                self.videoLikeApi {
                    //                    self.getData()
                }
            } else {
                self.videoDislikeApi {
                    //                    self.getData()
                }
            }
        } else{
            Proxy.shared.presentAlert(withTitle: "", message: "Please login", currentViewController: self)
        }
    }
    
    @IBAction func btnAddToCampVideo(_ sender: Any) {
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            self.addToMyCampApi { }
        }
        else{
            Proxy.shared.presentAlert(withTitle: "", message: "Please login", currentViewController: self)
        }
    }
    
    @IBAction func btnReadAlongAction(_ sender: Any) {

        let alertController = UIAlertController(title: str_VideoTitle, message: str_Transcription, preferredStyle: UIAlertController.Style.alert)
        // Background color.
        let backView = alertController.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        
        // Change Title With Color and Font:
        
        let myString  = str_VideoTitle
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont.init(name: "Montserrat-Bold", size: 25)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:myString.characters.count))
        alertController.setValue(myMutableString, forKey: "attributedTitle")
        
        // Change Message With Color and Font
        
        let message  = str_Transcription
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message , attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 18.0)!])
        messageMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:message.characters.count))
        alertController.setValue(messageMutableString, forKey: "attributedMessage")
        
        
        // Action.
        let action = UIAlertAction(title: "CLOSE", style: UIAlertAction.Style.default, handler: nil)
        action.setValue(UIColor.blue, forKey: "titleTextColor")
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


//MARK:- Get Categories
extension HCOpenVideoVC {
    func getCategoryDetailData() {
        self.SubCategoryViewAllTopModelAry.removeAll()
        
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != "" {
            self.getSubCategoriesApi (completion: {(bannerData) -> Void in
                
                self.videoPlayerPlay(Url: bannerData[0]["video"].stringValue,thumbURL: URL.init(string: "\(Apis.KVideosThumbURL)\(bannerData[0]["image_thumbnail"].stringValue)"))
                self.btnView.setTitle("\(bannerData[0]["views"].arrayValue.count)", for: .normal)
                self.lblTitle.text! = bannerData[0]["video_title"].stringValue
                let string =  bannerData[0]["video_description"].stringValue
                self.str_Transcription = bannerData[0]["transcription"].stringValue.htmlToString
                self.str_VideoTitle = bannerData[0]["video_title"].stringValue.htmlToString

                self.lblDescription.text! = string.htmlToString
                
                
                self.postHomeScreenApiWithActivityType(type: self.str_ActivityType, categoryValue: self.str_CategoryValue, completionHandler: {(success) -> Void in
                    if success {
                        self.tblVw.reloadData()
                        //                        self.perform(#selector(SubCategoryDetailVC.scrollToTop), with: nil, afterDelay: 0.4)
                        
                        Proxy.shared.hideActivityIndicator()
                        
                    } else {
                        
                    }
                })
            })
        } else {
            Proxy.shared.presentAlert(withTitle: "", message: "Please Login", currentViewController: self)
        }
    }
    
    //MARK:--> PLAY VIDEO  FUNCTION
    func videoPlayerPlay(Url: String,thumbURL:URL!) {
        
        let videoURL = URL(string: "\(Apis.KVideoURl)\(Url)")
        str_VideoUrl = videoURL?.absoluteString
        if playerController  != nil {
            //            let thumbnail = UIImageView( )
            //            thumbnail.frame = view_Video.bounds
            //            thumbnail.sd_setImage(with: thumbURL,placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            img_Thumb.sd_setImage(with: thumbURL,placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            //            self.playerController?.contentOverlayView?.addSubview(img_Thumb)
            //            let currentItem = AVPlayerItem.init(url:... videoURL!)
            //            player?.replaceCurrentItem(with: currentItem)
            //            player?.play()
            
        } else {
            
            playerController  = AVPlayerViewController()
            //            player = AVPlayer(url: videoURL!)
            playerController?.videoGravity = .resizeAspectFill
            //            playerController?.player = player
            playerController?.view = view_Video
            
            playerController?.view.frame = view_Video.bounds
            playerController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            playerController?.showsPlaybackControls=false
            playerController?.view.backgroundColor = .black
            //            let thumbnail = UIImageView( )
            //            thumbnail.frame = playerController!.view.frame
            
            img_Thumb.sd_setImage(with: thumbURL,placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            //            self.playerController?.contentOverlayView?.addSubview(img_Thumb)
            self.addChild(playerController!)
            playerController?.didMove(toParent: self)
            view_Video.addSubview(playerController!.view )
            //            player?.actionAtItemEnd = .none
            //            player?.play()
            
        }
    }
    
}


//MARK:- JSON
extension HCOpenVideoVC {
    
    //MARK:--> SIGN UP API FUNCTION
    func getSubCategoriesApi(completion: @escaping Completion) {
        let param = [
            "video_id"     :  "\(String(describing: str_VideoId!))",
            "udid"         :  "\(Proxy.shared.userId())",//"\(Proxy.shared.userId())",
            "ip"           :  "12421351sdgwe4t324543"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetVideoDetail)", params: param, showIndicator: true, completion: { (jsonResults) in
            
            //            self.VideoLiked = jsonResults["is_video_liked"] as? Int ?? 0
            //            self.totalLike = jsonResults["totallikes"] as? Int ?? 0
            //image_thumbnail
            self.likeState = jsonResults["is_video_liked"] as? Int ?? 0
            if self.likeState == 0 {
                self.btnLikedRef.setImage(UIImage(named: "like"), for: .normal)
            } else{
                self.btnLikedRef.setImage(UIImage(named: "like"), for: .normal)
            }
            self.setLikeButtonStatus(status: self.likeState)
            self.btnLikedRef.setTitle("  \(jsonResults["totallikes"] as? Int ?? 0)", for: .normal)
            
            var jsonObj = JSON()
            
            // Get results in SwiftyJSON
            if let results = jsonResults["results"] as? NSArray {
                jsonObj = JSON(results)
            }
            completion(jsonObj)
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    //MARK:--> GET HOME SCREEN API
    func postHomeScreenApiWithActivityType(type:String!,categoryValue:String!,completionHandler: @escaping CompletionHandler) {
        
        let param = [
            "activity_type": "\(String(describing: type!))",
            "all_videos": "1",
            "form_search_key": "",
            "page_no": "1",
            "page_size": "100",
            "sub_category": "\(String(describing: categoryValue!))",
            "user_id"     :  "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
        
        var url:String = ""
        if str_FromController == "FavVideos" {
            url = Apis.KFavouritesVideo
        } else if str_FromController == "RecentVideos" {
            url = Apis.KRecentVideos
        } else if str_FromController == "DetailSubVideos" {
            url = Apis.KGetCategoriesItems
        } else {
            url = Apis.KGetCategoriesItems
        }
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(url)", params: param, showIndicator: true, completion: { (jsonResults) in
            
            var appResponse = Int()
            
            appResponse = jsonResults["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                self.SubCategoryViewAllTopModelAry.removeAll()
                
                if let dictBanAry = jsonResults["categories_with_images"] as? NSArray
                {
                    if dictBanAry.count > 0
                    {
                        for i in 0..<dictBanAry.count
                        {
                            if let bnrDict = dictBanAry[i] as? NSDictionary {
                                let SubCategoryViewAllTopModelObj = SubCategoryViewAllTopModel()
                                SubCategoryViewAllTopModelObj.getTopBanner(dict: bnrDict)
                                self.SubCategoryViewAllTopModelAry.append(SubCategoryViewAllTopModelObj)
                            }
                            
                        }
                    }
                    completionHandler(true)
                    return;
                }
                
                if let dictBanAry = jsonResults["categories_with_images_ipad"] as? NSArray {
                    if dictBanAry.count > 0 {
                        for i in 0..<dictBanAry.count {
                            if let bnrDict = dictBanAry[i] as? NSDictionary {
                                let SubCategoryViewAllTopModelObj = SubCategoryViewAllTopModel()
                                SubCategoryViewAllTopModelObj.getTopBanner(dict: bnrDict)
                                self.SubCategoryViewAllTopModelAry.append(SubCategoryViewAllTopModelObj)
                                
                            }
                        }
                    }
                }
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    //MARK:--> VIDEO LIKE
    func videoLikeApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "udid"      :   "\(Proxy.shared.userId())",
            "video_id"  :   "\(String(describing: str_VideoId!))"
            ] as [String:Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KPostLike)", params: param, showIndicator: true, completion: { (JSON) in
            Proxy.shared.displayStatusCodeAlert(JSON["message"] as? String ?? "")
            self.likeState = JSON["video_liked"] as? Int ?? 0
            self.setLikeButtonStatus(status: self.likeState)
            self.btnLikedRef.setTitle("  \(JSON["totallikes"] as? Int ?? 0)", for: .normal)
            Proxy.shared.hideActivityIndicator()
            completion()
        })
    }
    
    //MARK:--> VIDEO LIKE
    func videoDislikeApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "udid"      :   "\(Proxy.shared.userId())",
            "video_id"  :   "\(String(describing: str_VideoId!))"
            ] as [String:Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KDeleteVideolike)", params: param, showIndicator: true, completion: { (JSON) in
            self.likeState = JSON["video_liked"] as? Int ?? 0
            self.setLikeButtonStatus(status: self.likeState)
            self.btnLikedRef.setTitle("  \(JSON["totallikes"] as? Int ?? 0)", for: .normal)
            Proxy.shared.hideActivityIndicator()
            completion()
        })
    }
    
    func setLikeButtonStatus(status:Int) {
        if status == 0 {
            let image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
            btnLikedRef.setImage(image, for: .normal)
            btnLikedRef.tintColor = .gray
        } else {
            let image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
            btnLikedRef.setImage(image, for: .normal)
            btnLikedRef.tintColor = .blue
        }
    }
    
    //MARK:--> ADD TO MY CAMP API
    func addToMyCampApi(_ completion:@escaping() -> Void) {
        let param = [
            "udid"      :   "\(Proxy.shared.userId())",
            "video_id"  :   "\(String(describing: str_VideoId!))"
            ] as [String:Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KAddToMyCamp)", params: param, showIndicator: true, completion: { (JSON) in
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.displayStatusCodeAlert(JSON["message"] as? String ?? "")
            Proxy.shared.presentAlert(withTitle: "", message: JSON["message"] as? String ?? "", currentViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
            completion()
        })
    }
    
}


extension HCOpenVideoVC: UITableViewDataSource, UITableViewDelegate, SelectedVideo {
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SubCategoryViewAllTopModelAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "SubCategoryDetailTVC", for: indexPath) as! SubCategoryDetailTVC
        
        if self.SubCategoryViewAllTopModelAry.count != 0 {
            let SubVideoCategoryModelAryObj = self.SubCategoryViewAllTopModelAry[indexPath.row]
            cell.lblheader.text = SubVideoCategoryModelAryObj.categoryTitle
            if SubVideoCategoryModelAryObj.categoryTitle == "MORE EPISODES" {
                cell.btnViewAll.isHidden = true
            }
            
        }
        if self.SubCategoryViewAllTopModelAry[indexPath.row].VideoModelAry.count != 0 {
            let SubCategoryViewAllTopModelAryObj =  self.SubCategoryViewAllTopModelAry[indexPath.row]
            cell.VideoModelAry = SubCategoryViewAllTopModelAryObj.VideoModelAry
        }
        
        //        cell.btnLeftAction.tag = indexPath.row
        cell.colVw.tag = indexPath.row
        //        cell.btnLeftAction.addTarget(self, action: #selector(leftSlideAction(_:)), for: .touchUpInside)
        //
        //        cell.btnRightAction.tag = indexPath.row
        //        cell.btnRightAction.addTarget(self, action: #selector(rightSlideAction(_:)), for: .touchUpInside)
        //
//                cell.btnViewAll.tag = indexPath.row
//                cell.btnViewAll.addTarget(self, action: #selector(btnViewAllAction), for: .touchUpInside)
        cell.colVw.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 270
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func didSelected(selectedVideoId: String, videoUrl: String) {
        self.str_VideoId = selectedVideoId
        let videoURL = URL(string: "\(Apis.KVideoURl)\(videoUrl)")
        str_VideoUrl = videoURL?.absoluteString
        
        self.playVideo(UIButton())
        //      getCategoryDetailData()
    }
    
}
