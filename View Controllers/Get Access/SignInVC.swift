//
//  ViewController.swift
//  HappyCamper
//
//  Created by wegile on 18/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class SignInVC: UIViewController,TopHeaderViewDelegate {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var txtfldPassWord: UITextField!
    @IBOutlet weak var txtFldEmailAdd: UITextField!
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    var SignInVMObj = SignInVM()
    
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
 
    //MARK:--> VIEW CONTROLLER DELEGATW
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldEmailAdd.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.PlaceHolderPurplColor])

        txtfldPassWord.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.PlaceHolderPurplColor])
        
//        let controller:UIViewController! = self.topMostViewController()
//        if controller is SignInVC {
        if UIDevice.current.userInterfaceIdiom != .phone {
            view_HeaderView.btn_OptionBeforeLogin.isHidden = true
        }
            self.tabBarController?.tabBar.isHidden = true
//        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.loginButton.layer.cornerRadius = self.loginButton.frame.height/1.5
            self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height/1.5
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom != .phone {
        view_HeaderView.btn_OptionBeforeLogin.isHidden = false
        }
        self.tabBarController?.tabBar.isHidden = false
    }
 
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnForgotPasswordACtion(_ sender: Any) {
        Proxy.shared.presentToVC(identifier: "RecoverPasswordVC", isAnimate: true, currentViewController: self)
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        validationTextfield()
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "GuestLandingPageVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func privacyPolicyButtonAction(_ sender: UIButton) {
        
        let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
        nav.fromCont = "Privacy Policies"
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    @IBAction func termsOfUseButtonAction(_ sender: UIButton) {
        
        let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
        nav.fromCont = "Terms & Conditions"
        self.navigationController?.pushViewController(nav, animated: true)
        
    }
    
    @IBAction func btnSignUpMenuAction(_ sender: Any) {
        var isExists : Bool = false
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController.isKind(of: SignUpVC.self){
                    isExists = true
                    self.navigationController?.popViewController(animated: true)

                }
            }
        }
        if isExists == false{
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
        }
    }
    
    @IBAction func bntStoreAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "CampStoreVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnWebSeriesAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnCmapFireAction(_ sender: Any) {
        Proxy.shared.presentAlert(withTitle: "", message: "In Progress", currentViewController: self)
        //Proxy.shared.pushToNextVC(identifier: "CamperUploadDetailVC", isAnimate: true, currentViewController: self)
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func didSelected(index: Int) {
      //  Proxy.shared.pushToNextVC(identifier: "SettingPopUpVC", isAnimate: true, currentViewController: self)
    }
   
}



extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
