//
//  CampDetailVC.swift
//  HappyCamper
//
//  Created by wegile on 11/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CampDetailTableVC: UITableViewCell {
    //MARK:--> IBOUTLETS
    
    @IBOutlet weak var LblDetail: UILabel!
    @IBOutlet weak var LblTitle: UILabel!
}

class CampDetailCVC: UICollectionViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var imgVw: UIImageView!
}

class CampDetailVC: UIViewController, SelectMenuOption ,SelectAviatorImage,TopHeaderViewDelegate {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblCampType: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblTitleHeader: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYearFounded: UILabel!
    @IBOutlet weak var lblAccreditations: UILabel!
    @IBOutlet weak var lblActivities: UILabel!
    @IBOutlet weak var lblDirectors: UILabel!
    @IBOutlet weak var lblFoundedYears: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var lblCampSpace: UILabel!
    
    @IBOutlet weak var vwActivities: UIView!
    @IBOutlet weak var vwCampType: UIView!
    @IBOutlet weak var vwCampCapacity: UIView!
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet weak var vwAge: UIView!
    
    @IBOutlet weak var vwYearFounded: UIView!
    @IBOutlet weak var vwDirectors: UIView!
    @IBOutlet weak var vwAccreditations: UIView!
    @IBOutlet weak var imgVwBanner: UIImageView!
    @IBOutlet weak var vwPhone: UIView!
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var lblDemoSpace: UILabel!
    @IBOutlet weak var vwSignUp: UIView!
    
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var imgVwLike: UIImageView!
    @IBOutlet weak var tblviewMain: UITableView!
    @IBOutlet weak var tbl_HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var info_BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var coll_BottomConstraint: NSLayoutConstraint!

    //MARK:--> VARIABLES
    var CampDetailVMObj = CampDetailVM()
    var viewController : MenuDrawerController?
    
    func setBackToHome() {
        Proxy.shared.rootWithoutDrawer("TabbarViewController")
//        self.navigationController?.popToRootViewController(animated: true)
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
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            targetVw.isHidden = true
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        
            
            CampDetailVMObj.postCampDetailApi {
                self.updateConstraints()
                if self.CampDetailVMObj.campLike == true {
                    self.imgVwLike.image =  UIImage(named: "like")
                } else {
                    self.imgVwLike.image = UIImage(named: "like (2)")
                }
                
                if self.CampDetailVMObj.CampModelAry[0].campAddress != "" {
                    self.vwAddress.isHidden = false
                    self.lblAddress.text!   = self.CampDetailVMObj.CampModelAry[0].campLocation
                } else {
                    self.vwAddress.isHidden = true
                }
                
                if self.CampDetailVMObj.CampModelAry[0].campLongDescription != "Blank" {
                    self.lblDescriptions.isHidden = false
                    self.lblDescriptions.text! = self.CampDetailVMObj.CampModelAry[0].campLongDescription.htmlToString
                } else {
                    self.lblDescriptions.isHidden = true
                }
                
                self.lblTitleHeader.text! = self.CampDetailVMObj.CampModelAry[0].campTitle
                self.lblTitle.text!       = self.CampDetailVMObj.CampModelAry[0].campTitle
                
                self.colVw.reloadData()
                
                self.tblviewMain.reloadData()
                
            }
            
            self.tblviewMain.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
            
        }else{
            //Load Data
            self.reloadData()
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Content Size for Left Stuff Tableview
        if let obj = object as? UITableView {
            if obj == self.tblviewMain && keyPath == "contentSize" {
                DispatchQueue.main.async {
                    self.tbl_HeightConstraint.constant = self.tblviewMain.contentSize.height
                }
            }
        }
    }
    
    func reloadData() {
        CampDetailVMObj.postCampDetailApi {
            if self.CampDetailVMObj.campLike == true {
                self.imgVwLike.image =  UIImage(named: "like")
            } else {
                self.imgVwLike.image = UIImage(named: "like (2)")
            }
            
            self.lblTitleHeader.text! = self.CampDetailVMObj.CampModelAry[0].campTitle
            self.lblTitle.text!       = self.CampDetailVMObj.CampModelAry[0].campTitle
            
            if self.CampDetailVMObj.CampModelAry[0].campSpace != "" {
                self.lblDemoSpace.isHidden = false
                self.lblCampSpace.text!   = self.CampDetailVMObj.CampModelAry[0].campSpace
            } else {
                self.lblDemoSpace.isHidden = true
            }
            
            if self.CampDetailVMObj.CampModelAry[0].foundedYear != "" {
                self.vwYearFounded.isHidden = false
                self.lblFoundedYears.text! = self.CampDetailVMObj.CampModelAry[0].foundedYear
            } else {
                self.vwYearFounded.isHidden = true
            }
            
            if self.CampDetailVMObj.CampModelAry[0].accreditations != "" {
                self.vwAccreditations.isHidden = false
                self.lblAccreditations.text! =  self.CampDetailVMObj.CampModelAry[0].accreditations
            } else{
                self.vwAccreditations.isHidden = true
            }
            
            if self.CampDetailVMObj.CampModelAry[0].age != "" {
                self.vwAge.isHidden = false
                self.lblAge.text! = self.CampDetailVMObj.CampModelAry[0].age
            } else {
                self.vwAge.isHidden = true
            }
            if self.CampDetailVMObj.CampModelAry[0].campLongDescription != "Blank" {
                self.lblDescriptions.isHidden = false
                self.lblDescriptions.text! = self.CampDetailVMObj.CampModelAry[0].campLongDescription.htmlToString
            } else {
                self.lblDescriptions.isHidden = true
            }
//            self.imgVwBanner.sd_setImage(with: URL.init(string: "\(Apis.KFavCompressImage)\(self.CampDetailVMObj.CampModelAry[0].campBannerLink)"),placeholderImage: #imageLiteral(resourceName: "banner"), completed: nil)
            
            if self.CampDetailVMObj.CampModelAry[0].director != "" {
                self.vwDirectors.isHidden = false
                self.lblDirectors.text! = self.CampDetailVMObj.CampModelAry[0].director
            } else {
                self.vwDirectors.isHidden = true
            }
            if self.CampDetailVMObj.CampModelAry[0].campAddress != "" {
                self.vwAddress.isHidden = false
                self.lblAddress.text!   = self.CampDetailVMObj.CampModelAry[0].campLocation
            } else {
                self.vwAddress.isHidden = true
            }
            if self.CampDetailVMObj.CampModelAry[0].campPhone != "" {
                self.vwPhone.isHidden = false
                self.lblPhoneNumber.text! = self.CampDetailVMObj.CampModelAry[0].campPhone
            } else {
                self.vwPhone.isHidden = true
                self.lblPhoneNumber.text! = self.CampDetailVMObj.CampModelAry[0].campPhone
            }
            if self.CampDetailVMObj.CampModelAry[0].campCapacity != "" {
                self.vwCampCapacity.isHidden = false
                self.lblCapacity.text!   = self.CampDetailVMObj.CampModelAry[0].campCapacity
            } else {
                self.vwCampCapacity.isHidden = true
            }
            if self.CampDetailVMObj.CampModelAry[0].gender != "" {
                self.vwGender.isHidden = false
                self.lblGender.text!   = self.CampDetailVMObj.CampModelAry[0].gender
            } else {
                self.vwGender.isHidden = true
            }
            if self.CampDetailVMObj.CampModelAry[0].age != "" {
                self.vwAge.isHidden = false
                self.lblAge.text!     = self.CampDetailVMObj.CampModelAry[0].age
            } else {
                self.vwAge.isHidden = true
            }
            if self.CampDetailVMObj.CampModelAry[0].campType != "" {
                self.vwCampType.isHidden = false
                self.lblCampType.text!    = self.CampDetailVMObj.CampModelAry[0].campType
            } else {
                self.vwCampType.isHidden = true
            }
            self.colVw.reloadData()
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
        }
    }
    
    //MARK:--> BUTTON TOUCH SCROLL COLLECTION VIEW ACTION
    @IBAction func btnLeftArrowAction(_ sender: Any) {
        let collectionBounds = self.colVw.bounds
        let contentOffset = CGFloat(floor(self.colVw.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    @IBAction func btnRightArrowAction(_ sender: Any) {
        let collectionBounds = self.colVw.bounds
        let contentOffset = CGFloat(floor(self.colVw.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
    }
    
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.colVw.contentOffset.y ,width : self.colVw.frame.width,height : self.colVw.frame.height)
        self.colVw.scrollRectToVisible(frame, animated: true)
    }
    
    //MARK:--> BUTTONS ACTIONS
    @IBAction func btnLoginAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnRequestInfo(_ sender: Any) {
        // Proxy.shared.pushToNextVC(identifier: "CampInformationVC", isAnimate: true, currentViewController: self)
        
        if CampDetailVMObj.campId != "" || CampDetailVMObj.campId.isEmpty == false{
            
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "PopEnterInformationVC") as! PopEnterInformationVC
            nav.userCampId  = CampDetailVMObj.campId
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnLikeAction(_ sender: Any) {
        
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
        
        if Proxy.shared.userId() != "" {
            CampDetailVMObj.likeButtonAction {
                if self.CampDetailVMObj.campLike == true {
                    self.imgVwLike.image =  UIImage(named: "like")
                } else {
                    self.imgVwLike.image = UIImage(named: "like (2)")
                }
            }
        } else {
            Proxy.shared.presentAlert(withTitle: "", message: "Login required", currentViewController: self)
        }
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        if targetVw.isHidden == true{
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    
    @IBAction func btnAviatorAction(_ sender: Any) {
        Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: true, currentViewController: self)
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
    
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.layoutIfNeeded()
        colVw.reloadData()
    }
}
