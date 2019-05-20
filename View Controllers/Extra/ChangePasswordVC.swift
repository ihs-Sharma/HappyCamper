//
//  ChangePasswordVC.swift
//  HappyCamper
//
//  Created by wegile on 24/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
@available(iOS 10.0, *)
@available(iOS 10.0, *)
class ChangePasswordVC: UIViewController, SelectMenuOption,UITextFieldDelegate, SelectAviatorImage,TopHeaderViewDelegate {
    //MARK:--> IBOUTLETS
    
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var txFldConfirmPassword: UITextField!
    @IBOutlet weak var txtFldNewPassword: UITextField!
    @IBOutlet weak var txtFldOldPassword: UITextField!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgVwSilde: SetCornerImageView!
    @IBOutlet weak var imgVwAviator: SetCornerImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblMenuUserName: UILabel!
    //MARK:--> VARIABLES
    var viewController :MenuDrawerController?
    
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
        if UIDevice.current.userInterfaceIdiom == .pad {
        viewController?.delegate = self
        } else {
            self.title  = "CHANGE PASSWORD"
        }
        
        //varinder
        if UIDevice.current.userInterfaceIdiom == .phone {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imgVwSilde.isUserInteractionEnabled = true
            imgVwSilde.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: false, currentViewController: self)
    }
   
    @IBAction func btnSignOutAction(_ sender: Any) {
        Proxy.shared.logout{
            Proxy.shared.rootWithoutDrawer("TabbarViewController")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
//        lblUserName.text! = KAppDelegate.UserModelObj.userName
//        lblMenuUserName.text! = KAppDelegate.UserModelObj.userName
//        lblUserEmail.text! = KAppDelegate.UserModelObj.userEmail
        SelectAviatorImageObj = self

        let userName = Proxy.shared.selectedUserName()
        let user_Email = Proxy.shared.selectedUserEmail()
        
        if KAppDelegate.UserModelObj.userName == "" {
            lblMenuUserName.text! = userName
        } else {
            lblMenuUserName.text! = KAppDelegate.UserModelObj.userName
        }
        
        if KAppDelegate.UserModelObj.userName == "" {
            lblUserEmail.text! = user_Email
        } else {
            lblUserEmail.text! = KAppDelegate.UserModelObj.userEmail
        }
        
        let slectedAviator = Proxy.shared.selectedAviatorImage()
        if slectedAviator != "" {
            view_HeaderView?.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            imgVwSilde.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            headerDelegate = self

            targetVw.isHidden = true
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        }
    }
   
    @IBAction func btnProfileAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "ProfileVC", isAnimate: true, currentViewController: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func btnStoreAction(_ sender: Any) {
    }
    
    @IBAction func btnManageSubscriptionAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SubscriptionDetailVIew", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSaveChangePassword(_ sender: Any) {
        checkValidation()
    }
    
    @IBAction func btnBackAPI(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnRecentVideos(_ sender: Any) {
        let nav =  KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "RecentVideosVC") as! RecentVideosVC
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    //MARK:--> BUTTON ACTIONS
//    @IBAction func btnFavuoritesCamp(_ sender: Any) {
//        let nav =  StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "FavouritesVideoVC") as! FavouritesVideoVC
//        nav.FavouritesVideoVMObj.fromCont = "favCamp"
//        self.navigationController?.pushViewController(nav, animated: true)
//    }
//
    @IBAction func btnFavouritesVideo(_ sender: Any) {
        let nav =  KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "FavouritesVideoVC") as! FavouritesVideoVC
        nav.FavouritesVideoVMObj.fromCont = "favVideo"
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    @IBAction func btnFavuoritesCamp(_ sender: Any) {
        let nav =  KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "FavouritesCampsVC") as! FavouritesCampsVC
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    @IBAction func btnMyTransactionsActions(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "MyTransactionVC", isAnimate: true, currentViewController: self)
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
   
    //MARK:--> delegate of text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldOldPassword {
            txtFldOldPassword.resignFirstResponder()
            txtFldNewPassword.becomeFirstResponder()
        } else if textField == txtFldNewPassword {
            txtFldNewPassword.resignFirstResponder()
            txFldConfirmPassword.becomeFirstResponder()
        } else if textField == txFldConfirmPassword {
            txFldConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    func checkValidation() {
        if txtFldOldPassword.text!.isEmpty {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.oldPassword, currentViewController: self)
        } else if txtFldNewPassword.text!.isEmpty {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.password, currentViewController: self)
        } else if !Proxy.shared.isValidPassword(txtFldNewPassword.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validPassword , currentViewController: self)
        } else if txtFldNewPassword.text! != txFldConfirmPassword.text! {
             Proxy.shared.presentAlert(withTitle: "", message: AlertValue.passwordNotMatch, currentViewController: self)
        } else {
            ChangePasswordApi(oldPassword : txtFldOldPassword.text!  , newPassword: txtFldNewPassword.text!)
        }
    }
    
    //MARK:--> SIGN UP API FUNCTION
    func ChangePasswordApi(oldPassword : String, newPassword: String)  {
        
        let param = [
            "oldpassword"     :  "\(oldPassword)",
            "password"        :  "\(newPassword)",
            "id"              :   Proxy.shared.userId()
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KChangePswrd)", params: param, showIndicator: true, completion: { (JSON) in
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.rootWithoutDrawer("TabbarViewController") 
        })
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
}


