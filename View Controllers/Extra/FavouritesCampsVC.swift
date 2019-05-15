//
//  FavouritesCampsVC.swift
//  HappyCamper
//
//  Created by wegile on 14/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class FavouritesCampsVC: UIViewController , UITableViewDelegate, UITableViewDataSource, SelectMenuOption, SelectAviatorImage,TopHeaderViewDelegate {
   
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btnBackAction: UIButton!
    //MARK:--> VARIABLES
    var currentPage = Int()
    var pageSize = 10
    var fromCont = String()
    
    var CampModelAry = [CampModel]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.tableFooterView = UIView()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            SelectAviatorImageObj = self
            targetVw.isHidden = true
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        } else {
            self.navigationController?.navigationBar.topItem?.title  = "MY FAVOURITE CAMPS"
        }
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            postFavVideosApi()
        } else {
            Proxy.shared.presentAlert(withTitle: "", message: "Please Login", currentViewController: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            headerDelegate = self
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
        }
    }
    
    @IBAction func bntLoginAction(_ sender: Any) {
        Proxy.shared
            .pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CampModelAry.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "NearMeCampTVC", for: indexPath) as! NearMeCampTVC
        
        if CampModelAry.count != 0 {
            
            let CampModelAryObj = CampModelAry[indexPath.row]
            cell.lblTitleCamp.text = CampModelAryObj.campTitle
            //cell.lblDescription
            if CampModelAryObj.campAddress != "" {
                cell.lblCampAddress.text = CampModelAryObj.campAddress
                // cell.imgVwaAdd.isHidden = false
            } else {
                // cell.imgVwaAdd.isHidden = true
            }
            
            cell.lblCampAddress.text! = CampModelAryObj.campAddress
            cell.imgVwbanner.sd_setImage(with: URL.init(string: "\(Apis.KCampTestUrl)\(CampModelAryObj.arr_campBannerLink[0])"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            
            if CampModelAryObj.campDescription != "Blank" {
                cell.lblCampDescriptions.isHidden = false
                let string = CampModelAryObj.campDescription
                cell.lblCampDescriptions.text! = string.htmlToString
            } else{
                cell.lblCampDescriptions.isHidden = true
            }
            
            cell.btnMore.tag = indexPath.row
            cell.btnMore.addTarget(self, action: #selector(btnLearnMoreAction), for: .touchUpInside)
            
            if CampModelAryObj.is_featured
            {
                cell.featured_img.isHidden = false
            }else{
                cell.featured_img.isHidden = true
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 420.0
        //        return 334.0
        
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared
            .pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }

    //MARK:--> FAV VIDEOS API FUNCTION
    func postFavVideosApi() {
        
        let param = [
            "page_no"     :  "\(currentPage+1)" ,
            "page_size"   :  "\(pageSize)"  ,
            "user_id"     :  "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
         
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KFavouritesCamps)", params: param, showIndicator: true, completion: { (JSON) in
            
            // self.alertMsg = JSON["message"] as? String ?? ""
            
            var appResponse = Int()
            // appResponse = JSON["app_response"] as? Int ?? 0
            
            //  if appResponse == 200 {
            if let resultAry = JSON["results"] as? NSArray {
                if resultAry.count > 0 {
                    for i in 0..<resultAry.count {
                        if let bnrDict = resultAry[i] as? NSDictionary {
                            if let videoDict = bnrDict["camp_id"] as? NSDictionary  {
                                let CampModelObj = CampModel()
                                CampModelObj.dictData(dict: videoDict)
                                self.CampModelAry.append(CampModelObj)
                            }
                        }
                    }
                }
            }
            Proxy.shared.hideActivityIndicator()
            self.tblVw.reloadData()
        })
    }
    
    //MARK:--> LEARN MORE ACTON
    @objc func btnLearnMoreAction(sender: UIButton)  {
        let CampModelObj = CampModelAry[sender.tag]
        
        let nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "CampDetailVC") as! CampDetailVC
        nav.CampDetailVMObj.campId = CampModelObj.campId
        self.navigationController?.pushViewController(nav, animated: true)
    }
}
