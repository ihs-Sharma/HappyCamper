//
//  ContestVC.swift
//  HappyCamper
//
//  Created by Baltej Singh on 16/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit
import MobileCoreServices
import Alamofire
import SwiftSpinner
import SwiftyJSON


class ContestVC: UIViewController,SelectAviatorImage,TopHeaderViewDelegate , SelectMenuOption{
    
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var nav_lbl: UILabel!
    @IBOutlet weak var desc_lbl: UILabel!
    @IBOutlet weak var item_image: UIImageView!
    @IBOutlet weak var tbl_contest: UITableView!
    @IBOutlet weak var VideoView: UIView!
    @IBOutlet weak var winner_lbl: UILabel!
    @IBOutlet weak var winner_Vw: UIView!
    @IBOutlet weak var btn_Upload: UIButton!
    
    var item_id = String()
    var item_dict = NSDictionary()
    var contenst_Arr = [NSDictionary]()
    var contest_winner = [NSDictionary]()
    
    var player: AVPlayer!
    var playerController  : AVPlayerViewController!
    
    var type_item = String()
    var isUser_Participant:Bool!
    var viewController : MenuDrawerController?
    
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
    
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getContest()
        
        self.tbl_contest.estimatedRowHeight = 300.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (UIDevice.current.userInterfaceIdiom == .pad){
        SelectAviatorImageObj = self
        headerDelegate = self
        
        let slectedAviator = Proxy.shared.selectedAviatorImage()
        if slectedAviator != "" {
            view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
        }
        
        targetVw.isHidden = true
        viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
        viewController?.delegate = self
        
        targetVw.addSubview(viewController!.view)
        viewController?.tblVw.delegate = viewController
        viewController?.tblVw.dataSource = viewController
        }
    }
    
    @IBAction func back_btn(_ sender : AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func upload_stuff(_ sender : AnyObject){
        
        let nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "UploadFilePopup") as! UploadFilePopup
        nav.isFromContest = true
        nav.type_item = type_item
        nav.contest_Id = self.item_id
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension ContestVC : UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contenst_Arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contest_cell") as! CampfireContestCell
        
        let contest = self.contenst_Arr[indexPath.row]
        
        cell.lbl_Title.text = contest.value(forKey: "title") as? String
        cell.lbl_Desc.text = contest.value(forKey: "description") as? String
        
        var imgLink = contest.value(forKey: "content") as! String
        
        let type = contest.value(forKey: "type") as! String
        let baseUrl = Apis.KContestImage
        if type == "video"
        {
            imgLink = contest.value(forKey: "thumbnail") as! String
            let urlStr = Apis.KContestVideo + imgLink
            cell.initializeVideos(videoString: urlStr)
            cell.view_Content.isHidden = false
        }
        else
        {
            cell.view_Content.isHidden = true
        }
        
        let imgUrl = URL.init(string: baseUrl + imgLink)
        
        cell.img_Item?.sd_setImage(with:imgUrl,placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        
        if type == "doc"
        {
            cell.img_Item.image = UIImage.init(named: "icon_File")
        }
        
        DispatchQueue.main.async {
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: cell.img_Item.frame.origin.y+cell.img_Item.frame.height+10, width: cell.contentView.frame.size.width, height: cell.contentView.frame.size.height))
            btn.addTarget(self, action: #selector(CampfireVC.didTapOnContest), for: .touchUpInside)
            btn.tag = indexPath.row
            cell.contentView.addSubview(btn)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //        return UITableView.automaticDimension
        
        return 400.0
        
    }
    
    
    @objc func didTapOnContest(_ sender: UIButton)
    {
        let contestObj = self.contenst_Arr[sender.tag]
        item_id = contestObj.value(forKey: "_id") as! String
        self.getContest()
    }
}
extension ContestVC
{
    
    func getContest()
    {
        
        let url = Apis.KServerUrl + Apis.KConsentGet
        
        let param = [
            "user_id":Proxy.shared.userId(),
            "item_id" : item_id
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData(url, params: param, showIndicator: true) { (JSON) in
            
            print(JSON)
            
            let appresponse = JSON.value(forKey: "app_response") as! Int
            
            if appresponse == 200
            {
                self.item_dict = JSON.value(forKey: "results") as! NSDictionary
                self.isUser_Participant =  JSON.value(forKey: "already_participated") as? Bool
                if self.isUser_Participant {
                    self.btn_Upload.isHidden=true
                }
                let contest = JSON.value(forKey: "contests") as! [NSDictionary]
                self.contenst_Arr = []
                self.contenst_Arr.append(contentsOf: contest)
                
                let contestWinner = JSON.value(forKey: "contest_winner") as! [NSDictionary]
                
                self.contest_winner = []
                self.contest_winner.append(contentsOf: contestWinner)
                
                Proxy.shared.hideActivityIndicator()
                self.setData()
                
            }
            else
            {
                Proxy.shared.hideActivityIndicator()
            }
            
        }
    }
    
    func setData()
    {
        
        self.title_lbl.text = (self.item_dict.value(forKey: "title") as? String)?.uppercased()
        self.nav_lbl.text = self.title_lbl.text
        self.desc_lbl.text = self.item_dict.value(forKey: "description") as? String
        self.item_id = self.item_dict["_id"] as! String

        let type = self.item_dict.value(forKey: "type") as! String
        let baseUrl = Apis.KContestImage
        var imgLink = self.item_dict.value(forKey: "content") as! String
        item_image.contentMode = .scaleAspectFill
        type_item = type
        if type == "video"
        {
            VideoView.isHidden = false
            imgLink = self.item_dict.value(forKey: "thumbnail") as! String
            
            let urlStr = Apis.KContestVideo + imgLink
            
            self.initializeVideos(videoString: urlStr)
            
        }
        else
        {
            VideoView.isHidden = true
        }
        
        let imgUrl = URL.init(string: baseUrl + imgLink)
        
        item_image.sd_setImage(with:imgUrl,placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        
        if type == "doc"
        {
            item_image.image = UIImage.init(named: "icon_File")
            item_image.contentMode = .scaleAspectFit
        }
        
        if self.contest_winner.count > 0
        {
            winner_Vw.isHidden = false
            winner_lbl.text = self.contestWinner()
        }
        else
        {
            winner_Vw.isHidden = true
        }
        
        self.tbl_contest.reloadData()
        
    }
    
    func contestWinner() -> String
    {
        var winner_name_arr = [String]()
        
        for winner in self.contest_winner
        {
            winner_name_arr.append(winner.value(forKey: "first_name") as! String)
        }
        
        return winner_name_arr.joined(separator: ",")
    }
    
    func initializeVideos(videoString:String!) {
        
        let videoUrl = URL.init(string: "\(Apis.KContestVideo)\(String(describing: videoString!))")
        
        self.player = AVPlayer(url: videoUrl!)
        playerController  = AVPlayerViewController()
        playerController.player = self.player
        playerController.view = VideoView
        
        playerController.view.frame = VideoView.bounds
        playerController.videoGravity = .resizeAspectFill
        playerController.view.backgroundColor = .black
        
        VideoView.addSubview(playerController.view)
        self.player.play()
        
        
    }
}
