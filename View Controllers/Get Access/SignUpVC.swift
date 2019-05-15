//
//  SignUpVC.swift
//  HappyCamper
//
//  Created by wegile on 19/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import StoreKit

class ConstanTVC: UITableViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblTitle: UILabel!
}

class SignUpVC: UIViewController,  SelectMenuOption, SelectAviatorImage, SKPaymentTransactionObserver,TopHeaderViewDelegate {
    
    var demoText = ["Tons of fun.","First 24 hours free.","Live and On Demand.","Watch from your laptop, iphone, or iPad.","Unlimited access to camp activities (cooking, baseball, etc.).","Chances to appear on Happy Camper Live."]
    
    var demoTextTwo = ["Explore camp in 360°.","Special discounts in the camp store.","Earn coins to redeem in the canteen.","Special contests.","Exclusive premiere of the Happy Camper Live original web series.","Cancel Anytime."]
    
    var packDuration = ["1 MONTH", "3 MONTH", "12 MONTH"]
    var packCost = ["$7.99", "$19.99", "$89.99"]
    var packBilling = ["Billed Month", "Billed Every 6 Months", "Billed Every 12 Months"]
    var packMonthlyBilling = ["Billed One Month", "Billed Six Month", "Billed Annually"]
    var priceAmountAry = NSMutableArray()
    
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!

    @IBOutlet weak var btnCheck: SetCornerButton!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldCreatePassword: UITextField!
    @IBOutlet weak var txtFldConfirmPassword: UITextField!
    @IBOutlet weak var txtFldZipCode: UITextField!
    @IBOutlet weak var menuVw: UIView!
    @IBOutlet weak var imgVwAvaitor: SetCornerImageView!
    
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var tblVwTwo: UITableView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var signUpButton: UIButton!

    //MARK:--> VARIABLES
    var SignUpVMObj     = SignUpVM()
    var viewController  : MenuDrawerController?
    
    var options: [Subscription]?
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CHECK SUBSCRIPTIONS PACKAGES
        SubscriptionService.shared.loadSubscriptionOptions()
        
        //PLAN PURCHASED
        options = SubscriptionService.shared.options
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOptionsLoaded(notification:)),
                                               name: SubscriptionService.optionsLoadedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseSuccessfull(notification:)),
                                               name: SubscriptionService.purchaseSuccessfulNotification,
                                               object: nil)
        
        btnCheck.isSelected = false
        if UIDevice.current.userInterfaceIdiom != .phone {
        targetVw.isHidden     = true
        
        viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
        viewController?.delegate         = self
        
        targetVw.isHidden                = true
        targetVw.addSubview(viewController!.view)
        viewController?.tblVw.delegate   = viewController
        viewController?.tblVw.dataSource = viewController
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
            signUpButton.layer.cornerRadius = signUpButton.frame.height/2
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom != .phone {
        SelectAviatorImageObj = self
        headerDelegate = self
        targetVw.isHidden = true

        }
//        let slectedAviator = Proxy.shared.selectedAviatorImage()
//        if slectedAviator != "" {
//            imgVwAvaitor.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
//        }
    }
    
    //MARK:--> IN APP PURCHASE FUNCTIONS
    @objc func handleOptionsLoaded(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.options = SubscriptionService.shared.options
            //self?.tableView.reloadData()
            self!.printvalueOfOptions()
        }
    }
    
    @objc func handlePurchaseSuccessfull(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            //self?.tableView.reloadData()
            self!.printvalueOfOptions()
        }
    }
    
    func printvalueOfOptions() {
        for index in options! {
            print("Title:-\(index.product.localizedTitle)")
            print("Description:-\(index.product.localizedDescription)")
            print("Price:-\(index.formattedPrice)")
            
            priceAmountAry.add(index.formattedPrice)
            
            if let currentSubscription = SubscriptionService.shared.currentSubscription {
                if index.product.productIdentifier == currentSubscription.productId {
                    //cell.isCurrentPlan = true
                    print("currentplant:-\(true)")
                }
            }
        }
       //tblVw.reloadData()
    }
    

    //MARK:--> BUTTON ACTIONS    
    @IBAction func btnCamperAction(_ sender: Any) {
        Proxy.shared.presentAlert(withTitle: "", message: "In Progress", currentViewController: self)
    }
    
    @IBAction func btnLiveAction(_ sender: Any) {
    }
    
    @IBAction func btnCheckAction(_ sender: Any) {
        if btnCheck.isSelected == true {
            btnCheck.isSelected = false
        } else {
            btnCheck.isSelected = true
        }
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        validationTextfield()
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        var isExists : Bool = false
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                
                if viewController.isKind(of: SignInVC.self){
                    isExists = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        if isExists == false {
            Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
        }
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        if targetVw.isHidden == true {
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    
    @IBAction func btnAviatorAction(_ sender: Any) {
    }
    
    @IBAction func btnCampFireAction(_ sender: Any) {
    }
    
    @IBAction func btnWebSeriesAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
    
    //MARK:--> PROTOCOAL FUNCTIONS
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
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        if sender.tag == 0 {
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        } else {
            Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)

        }
    }
    
    @IBAction func btnPicOrntAction(_ sender: Any) {
    }
    
    @IBAction func btnLoginTopAction(_ sender: Any) {
        var isExists : Bool = false
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                // some process
                if viewController.isKind(of: SignInVC.self){
                    isExists = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        if isExists == false{
            Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
        }
    }
    
    
    
    //MARK:--> PAYMENTS  DELEGATE FUNCTION
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                handlePurchasingState(for: transaction, in: queue)
            case .purchased:
                handlePurchasedState(for: transaction, in: queue)
            case .restored:
                handleRestoredState(for: transaction, in: queue)
            case .failed:
                handleFailedState(for: transaction, in: queue)
            case .deferred:
                handleDeferredState(for: transaction, in: queue)
            }
        }
    }
    
    func handlePurchasingState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User is attempting to purchase product id: \(transaction.payment.productIdentifier)")
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User purchased product id: \(transaction.payment.productIdentifier)")
        
        queue.finishTransaction(transaction)
        
        SubscriptionService.shared.uploadReceipt { (success, subscription) in
            
            if success
            {
                let expiryDate = subscription?.expiresDate
                
                let currentDate = Date()
                
                if expiryDate?.compare(currentDate) == .orderedSame || expiryDate?.compare(currentDate) == .orderedDescending
                {
                    print("running subscription")
                }
                else
                {
                    print("cancelled or expired subscription")
                }
                
                
            }
            else
            {
                
            }
        }
    }
    
    func handleRestoredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase restored for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        
        SubscriptionService.shared.uploadReceipt { (success, subscription) in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: SubscriptionService.restoreSuccessfulNotification, object: nil)
            }
        }
    }
    
    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase failed for product id: \(transaction.payment.productIdentifier)")
    }
    
    func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase deferred for product id: \(transaction.payment.productIdentifier)")
    }
}
