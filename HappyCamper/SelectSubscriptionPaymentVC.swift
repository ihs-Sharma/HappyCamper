//
//  SelectSubscriptionPaymentVC.swift
//  HappyCamper
//
//  Created by wegile on 21/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

protocol SubscruptionPaymentDelegate {
    func SubscruptionPaymentDetailAction()
}

var subscruptionPaymentDelegateObj:SubscruptionPaymentDelegate?

class SelectSubscriptionPaymentVC: UIViewController, SelectMenuOption {
    //MARK:--> VARIABLES
    var packDuration =  ["1 MONTH", "3 MONTH", "12 MONTH"]
    var packCost = ["$7.99", "$19.99", "$89.99"]
    var packBilling = ["Billed Once", "Billed Month", "Billed Every 3 Months", "Billed Every 12 Months"]
    var packMonthlyBilling = ["Billed One Month", "Billed Three Month", "Billed Annually"]
    
    var viewController :MenuDrawerController?
    var SelectSubscriptionPaymentVMObj = SelectSubscriptionPaymentVM()
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldCardNumber: UITextField!
    @IBOutlet weak var txtFldExpireDate: UITextField!
    @IBOutlet weak var txtFldCVC: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    override func viewWillAppear(_ animated: Bool) {
        //targetVw.isHidden = true
    }
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnPayNowAction(_ sender: Any) {
        subscruptionPaymentDelegateObj?.SubscruptionPaymentDetailAction()
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnDrawerAction(_ sender: Any) {
//        if targetVw.isHidden == true {
//            targetVw.isHidden = false
//        }else{
//            targetVw.isHidden = true
//        }
    }
    //MARK:-> PROTOCOL FUNCTION
    func didSelected(index: Int) {
        if index == 0 {
//            targetVw.isHidden = true
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        targetVw.isHidden = true
         dismiss(animated: false, completion: nil)
    }
    
    
}
