//
//  AboutUsVC.swift
//  HappyCamper
//
//  Created by wegile on 11/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import WebKit
import SwiftSpinner

class AboutUsVC: UIViewController,UIWebViewDelegate,TopHeaderViewDelegate,SelectMenuOption,SelectAviatorImage {
    
    @IBOutlet weak var btnBack_WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn_Back: UIButton!
    
    //MARK:--> IBOUTLETS
    var fromCont = String()
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var targetVw: UIView!
    var viewController : MenuDrawerController?
    var comeFromSideMenu = Bool()
    
    func setBackToHome() {
        self.navigationController?.popToRootViewController(animated: true)
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
    @objc func MenuBtnAction(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    //varinder14
    @objc func backBtnAction(){
        webView.goBack()
    }
    
    func showNavigation() {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3019607843, green: 0.1803921569, blue: 0.4862745098, alpha: 1)
        
        let image3 = UIImage(named: "menu (1)")
        let frameimg = CGRect(x: 15, y: 5, width: 22, height: 22)
        
        let someButton = UIButton(frame: frameimg)
        someButton.setBackgroundImage(image3, for: .normal)
        someButton.addTarget(self, action: #selector(MenuBtnAction), for: .touchUpInside)
        someButton.showsTouchWhenHighlighted = false
        
        let mailbutton = UIBarButtonItem(customView: someButton)
        navigationItem.leftBarButtonItem = mailbutton
        
    }
    func showNavigationBack(){
        let image3 = UIImage(named: "left_arrow")
        let frameimg = CGRect(x: 15, y: 5, width: 13, height: 22)
        
        let someButton = UIButton(frame: frameimg)
        someButton.setBackgroundImage(image3, for: .normal)
        someButton.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        someButton.showsTouchWhenHighlighted = false
        
        let mailbutton = UIBarButtonItem(customView: someButton)
        navigationItem.leftBarButtonItem = mailbutton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.topItem?.title = "ABOUT US"
        btn_Back.isHidden=true
        
        if comeFromSideMenu == true {
            btn_Back.isHidden = false
            if let image = UIImage(named: "menu (1)") {
                btn_Back.setImage(image, for: .normal)
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            targetVw.isHidden = true
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        }
        
        
        var urlStr = String()
        var url : URL!
        if fromCont == "FAQs" {
            urlStr = "\(Apis.KFaqLink)"
            url = URL (string: Apis.KSiteUrl + "\(urlStr)")
            self.navigationController?.navigationBar.topItem?.title = "FAQ"
        } else if fromCont == "ContactUs" {
            urlStr = "\(Apis.KContactUsLink)"
            url = URL (string: Apis.KSiteUrl + "\(urlStr)")
            self.navigationController?.navigationBar.topItem?.title  = "CONTACT US"
        } else if fromCont == "Community" {
            urlStr = "\(Apis.KCommunity)"
            url = URL (string: Apis.KSiteUrl + "\(urlStr)")
           self.navigationController?.navigationBar.topItem?.title  = "COMMUNITY"
        } else if fromCont == "Terms & Conditions" {
            urlStr = "\(Apis.KTermsAndPrivacy)"
            url = URL (string: Apis.KSiteUrl + "\(urlStr)")
            self.navigationController?.navigationBar.topItem?.title  = "TERMS AND CONDITIONS"
        } else if fromCont == "Privacy Policies" {
            urlStr = "\(Apis.KPrivacyPolicy)"
            url = URL (string: Apis.KSiteUrl + "\(urlStr)")
            self.navigationController?.navigationBar.topItem?.title  = "PRIVACY POLICY"
        } else if fromCont == "CampStaff" {
            urlStr = "\(Apis.KCampStaffUrl)"
            url = URL (string: Apis.KSiteUrl + "\(urlStr)")
            self.navigationController?.navigationBar.topItem?.title  = "CAMP STAFF"
        }  else if fromCont == "360" {
            self.navigationController?.navigationBar.topItem?.title  = "360˚"
            if UIDevice.current.userInterfaceIdiom == .pad {
                view_HeaderView.btn_360.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
                for view in view_HeaderView.subviews { if let lbl = view.viewWithTag(103) as? UILabel { lbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)  } }
            }
            
            urlStr = "\(Apis.K360Camp)"
            url = URL (string: "\(urlStr)")
        } else if fromCont == "Disclaimer" {
            url = URL (string: "https://www.happycamperlive.com/disclaimer/ipad")
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.btnBack_WidthConstraint.constant=0
            }
            urlStr = "\(Apis.KAboutUsLink)"
            if Proxy.shared.authNil() != "" {
                urlStr=""
                urlStr = "\(Apis.KAboutUsLink)" + "/abc"
            }
            url = URL (string: Apis.KSiteUrl + "\(urlStr)")
        }
        //
        //      SwiftSpinner.show("Please wait..", animated: true)
        Proxy.shared.showActivityIndicator()
        //      let url = URL (string: Apis.KSiteUrl + "\(urlStr)")
        let requestObj = URLRequest(url: url!)
        webView.delegate = self
        webView.loadRequest(requestObj)
        
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
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            self.showNavigation()
            if let leftMenuController = SideMenuManager.default.menuLeftNavigationController?.viewControllers.first as? LeftMenuViewController{
                leftMenuController.delegate = self;
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            headerDelegate = self
            targetVw.isHidden = true
            SelectAviatorImageObj = self
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //varinder8
        if webView.canGoBack == true {
            
            if UIDevice.current.userInterfaceIdiom != .pad {
                btn_Back.isHidden=true
                self.showNavigationBack()
            }else{
                btn_Back.isHidden=false
                if let image = UIImage(named: "left_arrow") {
                    btn_Back.setImage(image, for: .normal)
                }
                
            }
        } else {
            
            if UIDevice.current.userInterfaceIdiom != .pad {
                btn_Back.isHidden=true
                self.showNavigation()
            } else {
                btn_Back.isHidden=true
            }
            
        }
        Proxy.shared.hideActivityIndicator()
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnWebPageBack(_ sender: Any) {
        //varinder8
        if let image = UIImage(named: "menu (1)") {
            if btn_Back.imageView?.image == image{
                print("True")
                present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
            }else{
                webView.goBack()
            }
        }
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
    
}
//varinder10
//MARK:- Handle Side menu actions
extension AboutUsVC: GuestLandingPageVCSideMenuDelegate {
    
    func didSelectSideMenu(itemNum : Int) {
        
        switch (itemNum){
        //varinder8
        case (0):
            //live
            self.tabBarController?.selectedIndex = 0
            //   Proxy.shared.pushToNextVC(identifier: "GuestLandingPageVC", isAnimate: true, currentViewController: self)
            self.navigationController?.popViewController(animated: false)
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
