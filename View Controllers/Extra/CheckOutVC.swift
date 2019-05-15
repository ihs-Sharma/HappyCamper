//
//  CheckOutVC.swift
//  HappyCamper
//
//  Created by wegile on 01/03/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CheckOutCVC: UICollectionViewCell {
    @IBOutlet weak var imgVw: UIImageView!
}

class CheckOutVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SelectAviatorImage, SelectMenuOption,TopHeaderViewDelegate,UICollectionViewDelegateFlowLayout {
  
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var txtFldLastName: UITextField!
    @IBOutlet weak var txtFldAddress: UITextField!
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldCity: UITextField!
    @IBOutlet weak var txtFLdState: UITextField!
    @IBOutlet weak var txtFldZipCode: UITextField!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var txtFldCountry: UITextField!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var user_Coins: UILabel!
    //varinder7
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var view_Fields: UIView!
    @IBOutlet weak var msg_NotSufficientCoinConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwAviator: SetCornerImageView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var menuVw: UIView!
    
    //MARK:--> VARIABLES
    var ImagAry = NSArray()
    var coinObj : coinModel?
    var CanteenModelAry = [CanteenModel]()
    var viewController : MenuDrawerController?
    
    func setBackToHome() {
              Proxy.shared.rootWithoutDrawer("TabbarViewController")
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
        
        lblDescription.text!    = coinObj!.description.htmlToString
        lblTitle.text!          = coinObj!.title.htmlToString
        lblHeaderTitle.text!    = coinObj!.title.htmlToString
        lblCoins.text!          = "\(coinObj!.coins)"
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            targetVw.isHidden = true
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        }
        
        if UserDefaults.standard.object(forKey: "User_Coins") != nil {
            let coins = UserDefaults.standard.integer(forKey: "User_Coins")
            user_Coins.text = String.init(coins)
            
            if Int(user_Coins.text ?? "") ?? 0 < coinObj!.coins {
                view_Fields.isHidden=true
                if UIDevice.current.userInterfaceIdiom != .pad{
                    scrollViewBottomConstraints.constant = scrollViewBottomConstraints.constant-600
                }
            } else {
                msg_NotSufficientCoinConstraint.constant = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad{
            SelectAviatorImageObj = self
            headerDelegate = self
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
            
            targetVw.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        view_Fields.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    @IBAction func btnBuyWithCoins(_ sender: Any) {
        ValidationTextField()
    }
    
    //MARK:-> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImagAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "CheckOutCVC", for: indexPath) as! CheckOutCVC
      
        if ImagAry.count != 0 {
                cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KCoinProduct)\(ImagAry[indexPath.item])"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        return cell
    }
    
    //varinder8
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.size.width ) - 10
        return CGSize(width:width, height: collectionView.frame.size.height)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnToogleAction(_ sender: Any) {
        Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        if targetVw.isHidden == true{
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    
    func ValidationTextField(){
        if txtFldFirstName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.firstname)", currentViewController: self)
        } else if txtFldLastName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.lastName)", currentViewController: self)
        } else if txtFldAddress.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.Address)", currentViewController: self)
        } else if txtFldCity.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.city)", currentViewController: self)
        } else if txtFLdState.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.state)", currentViewController: self)
        } else if txtFldZipCode.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.zipCode)", currentViewController: self)
        } else if txtFldCountry.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.country)", currentViewController: self)
        } else {
           
            BuyProductWithCoin(address: txtFldAddress.text! , city: txtFldCity.text! , country: txtFldCountry.text!, zipCode: txtFldZipCode.text!, state: txtFLdState.text!, lastName: txtFldLastName.text!, firstName: txtFldFirstName.text!)
        }
    }
    
    func BuyProductWithCoin(address: String, city: String, country: String, zipCode: String, state: String, lastName: String, firstName: String) {
    
            let param = [
                    "address"       :   "\(address)",
                    "city"          :   "\(city)",
                    "country"       :   "\(country)",
                    "first_name"    :   "\(firstName)",
                    "last_name"     :   "\(lastName)",
                    "product_id"    :   "\(coinObj!.Id)",
                    "state"         :   "\(state)",
                    "user_id"       :   "\(Proxy.shared.userId())",
                    "zipcode"       :   "\(zipCode)"
                ] as [String:AnyObject]
            
            WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KBuyWithCoins)", params: param, showIndicator: true, completion: { (JSON) in
                
                var appResponse = Int()
                
                appResponse = JSON["app_response"] as? Int ?? 0
                
                if appResponse == 200 {
                    var msg = String()
                    msg = JSON["message"] as? String ?? ""
                    Proxy.shared.presentAlert(withTitle: "", message: msg, currentViewController: self)
                   Proxy.shared.rootWithoutDrawer("TabbarViewController")
                }
                Proxy.shared.hideActivityIndicator()
        })
    }
    
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
        } else if index == 2 {
            Proxy.shared.pushToNextVC(identifier: "CamperStaffVC", isAnimate: true, currentViewController: self)
        } else if index == 3 {
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
        } else if index == 10 {
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
    
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
}
