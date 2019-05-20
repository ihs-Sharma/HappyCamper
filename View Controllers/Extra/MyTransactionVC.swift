//
//  MyTransactionVC.swift
//  HappyCamper
//
//  Created by wegile on 12/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class MyTransactionTVC: UITableViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubscriptionId: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCreatedAt: UILabel!
    @IBOutlet weak var btnCancelPlan: UIButton!
    @IBOutlet weak var btnChangePlan: UIButton!
     @IBOutlet weak var status_lbl: UILabel!
    @IBOutlet weak var bgView: UIView!
}

class MyTransactionVC: UIViewController, SelectMenuOption ,SelectAviatorImage,TopHeaderViewDelegate {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var targetVw: UIView!
    //MARK:--> VARIABLES
    var MyTransactionVMObj = MyTransactionVM()
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            SelectAviatorImageObj = self
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            
            targetVw.isHidden = true
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        } else {
            self.navigationController?.navigationBar.topItem?.title = "MY TRANSACTIONS"
        }
        tblVw.tableFooterView = UIView()
        if  Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            MyTransactionVMObj.myTransactionGetApi {
                self.tblVw.reloadData()
                //                Proxy.shared.presentAlert(withTitle: "", message: "\(self.MyTransactionVMObj.alertMsg)", currentViewController: self)
            }
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
            targetVw.isHidden = true
        }
    }
    
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func bntAviatorAction(_ sender: Any) {
        Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnMenuAcion(_ sender: Any) {
        if targetVw.isHidden == true{
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
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
