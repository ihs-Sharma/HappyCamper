//
//  ProfileVC.swift
//  HappyCamper
//
//  Created by wegile on 31/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, SelectMenuOption, SelectAviatorImage,TopHeaderViewDelegate {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!

    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var imgVw: SetCornerImageView!
    
    @IBOutlet weak var lblUserNameSideMenu: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnToggle: SetCornerButton!
    @IBOutlet weak var btnMenuRef: UIButton!
    
    //MARK:--> VARIABLES
    var viewController : MenuDrawerController?
    var ProfileVMObj  = ProfileVM()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            targetVw.isHidden = true
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        } else {
            self.title  = "MY PROFILE"
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: false, currentViewController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headerDelegate = self
        SelectAviatorImageObj = self

        let slectedAviator = Proxy.shared.selectedAviatorImage()
        if slectedAviator != "" {
            view_HeaderView?.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            imgVw.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            targetVw.isHidden = true
        }
        
        let userName = Proxy.shared.selectedUserName()
        let user_Email = Proxy.shared.selectedUserEmail()
        
        if KAppDelegate.UserModelObj.userName == "" {
            lblUserNameSideMenu.text! = userName
            txtFldName.text!      = userName
        } else {
            lblUserNameSideMenu.text! = KAppDelegate.UserModelObj.userName
            txtFldName.text!      = KAppDelegate.UserModelObj.userName
        }
        
        if KAppDelegate.UserModelObj.userName == "" {
            txt_LastName.text!      = userName
        } else {
            txt_LastName.text!      = KAppDelegate.UserModelObj.userName
        }
        
        if KAppDelegate.UserModelObj.userEmail == "" {
            lblEmailAddress.text! = user_Email
            txtFldEmail.text!     = user_Email
        } else {
            lblEmailAddress.text! = KAppDelegate.UserModelObj.userEmail
            txtFldEmail.text!     = KAppDelegate.UserModelObj.userEmail
        }

        //varinder
        if UIDevice.current.userInterfaceIdiom == .phone {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imgVw.isUserInteractionEnabled = true
            imgVw.addGestureRecognizer(tapGestureRecognizer)
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
}

//MARK:- IBActions
extension ProfileVC {
    
    @IBAction func btnRecentVideos(_ sender: Any) {
        let nav =  KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "RecentVideosVC") as! RecentVideosVC
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    @IBAction func btnFavuoritesCamp(_ sender: Any) {
        let nav =  KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "FavouritesCampsVC") as! FavouritesCampsVC
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    @IBAction func btnFavouritesVideo(_ sender: Any) {
        let nav =  KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "FavouritesVideoVC") as! FavouritesVideoVC
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    @IBAction func btnMyTransactionsActions(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "MyTransactionVC", isAnimate: true, currentViewController: self)
    }
    
    
    @IBAction func btnManageSubscriptionAction(_ sender: Any) {
        let subscriptionDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionDetailVIew") as! SubscriptionDetailVIew
        
        subscriptionDetailVC.isFromManageSubscription = true
        self.navigationController?.pushViewController(subscriptionDetailVC, animated: true)
        
    }
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
        checkValidation()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignOut(_ sender: Any) {
        Proxy.shared.logout {
            Proxy.shared.rootWithoutDrawer("TabbarViewController")
        }
    }
    @IBAction func btnChangePassword(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "ChangePasswordVC", isAnimate: true, currentViewController: self)
    }
}
