//
//  RecoverPasswordVC.swift
//  HappyCamper
//
//  Created by wegile on 23/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class RecoverPasswordVC: UIViewController, SelectMenuOption {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var txtFldEmailAddress: UITextField!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    //MARK:--> VARIABLES
    var viewController :MenuDrawerController?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.delegate = self
    }
    
    //MARK:--> BUTTONS ACTIONS
    @IBAction func btnRecoverPasswordAction(_ sender: Any) {
        if txtFldEmailAddress.isBlank {
             Proxy.shared.presentAlert(withTitle: "", message: AlertValue.email, currentViewController: self)
        } else if !Proxy.shared.isValidEmail(txtFldEmailAddress.text!) {
             Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validEmail, currentViewController: self)
        } else {
            forgotPasswordApi(emailString: txtFldEmailAddress.text!)
        }
        
    }
    @IBAction func btnDrawerAction(_ sender: Any) {
        if targetVw.isHidden == true {
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: nil)
    }
    //MARK:--> PROTOCOLS FUNCTIONS
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
    
    //MARK:--> SIGN UP API FUNCTION
    func forgotPasswordApi(emailString: String) {
        
        let param = [
            "email"  :  "\(emailString)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KRecoverPassword)", params: param, showIndicator: true, completion: { (JSON) in
            let alertMsg = JSON["message"] as? String ?? ""
            Proxy.shared.presentAlert(withTitle: "", message: alertMsg, currentViewController: self)
        
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                self.dismiss(animated: false, completion: nil)
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
}
