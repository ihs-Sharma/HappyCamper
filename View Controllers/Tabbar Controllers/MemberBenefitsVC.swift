//
//  MemberBenefitsVC.swift
//  HappyCamper
//
//  Created by wegile on 29/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftSpinner

class MemberBenefitsVC: UIViewController,UIWebViewDelegate,TopHeaderViewDelegate,SelectMenuOption,SelectAviatorImage {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btn_Back: UIButton!

    @IBOutlet weak var imgVwDropDown: UIImageView!
    @IBOutlet weak var btnVW: UIView!
    @IBOutlet weak var imgVwAviator: UIImageView!
    @IBOutlet weak var btnAviatorImag: SetCornerButton!
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    var viewController : MenuDrawerController?
    
    @IBOutlet weak var webView: UIWebView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Back.isHidden=true
        if UIDevice.current.userInterfaceIdiom == .pad{
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            targetVw.isHidden = true
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        } else {
            self.navigationController?.navigationBar.topItem?.title = "CAMPER BENEFITS"
        }
        
        //        SwiftSpinner.show("Please wait..", animated: true)
        Proxy.shared.showActivityIndicator()
        let url = URL (string:Apis.KSiteUrl + Apis.KCamperBenifitLink)//"http://18.215.132.27/camper-benefit""\(Apis.)")
        
        webView.delegate = self
        
        
        //        var finalUlr : URL?
        //        CacheManager.shared.getFileWith(stringUrl: (url?.absoluteString)!) { result in
        //
        //            switch result {
        //            case .success(let url1):
        //                finalUlr = url1
        //
        //
        ////                videoUrl = (url1 as NSURL) as URL
        //                break
        //            case .failure( _):
        //                break
        //            }
        //        }
        
        DispatchQueue.main.async {

            var requestObj = URLRequest(url: url!)
            requestObj.timeoutInterval=7
            requestObj.cachePolicy = .returnCacheDataElseLoad
            
            self.webView.loadRequest(requestObj)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(observeTapOnLinks), name: NSNotification.Name("campfire_url"), object: nil)
    }
    
    // Notify on click on links
    @objc func observeTapOnLinks(_ notification: Notification) {
        if let object = notification.userInfo as NSDictionary? {
            
            let type = object["type"] as! String
            
            if type == "ipad-signup" { }
            
            if type == "web-series" {
                Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
            }
            
            if type == "campfire" {
                Proxy.shared.pushToNextVC(identifier: "CampfireVC", isAnimate: true, currentViewController: self)
            }
            
            if type == "nearbycamp" { }
            
            if type == "home" {
                Proxy.shared.rootWithoutDrawer("TabbarViewController")
                self.tabBarController?.selectedIndex = 0

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            Proxy.shared.showNavigationOnTopMenu(controller: self)
            
            if let leftMenuController = SideMenuManager.default.menuLeftNavigationController?.viewControllers.first as? LeftMenuViewController{
                leftMenuController.delegate = self;
            }
            
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            headerDelegate = self
            SelectAviatorImageObj = self
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //        SwiftSpinner.hide()
        if webView.canGoBack == true {
            btn_Back.isHidden=false
        } else {
            btn_Back.isHidden=true
        }
        
        Proxy.shared.hideActivityIndicator()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        if targetVw.isHidden == true {
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    
    @objc func btnMenuAction(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
}

//varinder10
//MARK:- Handle Side menu actions
extension MemberBenefitsVC: GuestLandingPageVCSideMenuDelegate {
    
    func didSelectSideMenu(itemNum : Int) {
        
        switch (itemNum){
        //varinder8
        case (0):
            //live
            self.tabBarController?.selectedIndex = 0
            //  Proxy.shared.pushToNextVC(identifier: "GuestLandingPageVC", isAnimate: true, currentViewController: self)
            break
        case (1):
            //live
            break
        case (2):
            //Web Serise
            Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
            break
        case (3):
            //360
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "360"
            nav.comeFromSideMenu = true
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (4):
            //store
            break
        case (5):
            //camp fire
            Proxy.shared.pushToNextVC(identifier: "CampfireVC", isAnimate: true, currentViewController: self)
            break
        case (6):
            //camp staff
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.comeFromSideMenu = true
            nav.fromCont = "CampStaff"
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (7):
            //community
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Community"
            nav.comeFromSideMenu = true
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (8):
            //faq
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "FAQs"
            nav.comeFromSideMenu = true
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (9):
            //contact us
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.comeFromSideMenu = true
            nav.fromCont = "ContactUs"
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (10):
            //terms and conditions
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.comeFromSideMenu = true
            nav.fromCont = "Terms & Conditions"
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (11):
            //privacy policy
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.comeFromSideMenu = true
            nav.fromCont = "Privacy Policies"
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (12):
            //Invite Freinds
            Proxy.shared.pushToNextVC(identifier: "InviteAFriendVC", isAnimate: true, currentViewController: self)
            break
        case (13):
            //Join Camp
            Proxy.shared.pushToNextVC(identifier: "JoinOurTeamVC", isAnimate: true, currentViewController: self)
            break
        default:
            break
        }
    }
}


