//
//  CampFireVC.swift
//  HappyCamper
//
//  Created by wegile on 22/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class CastScreenVC: UIViewController,TopHeaderViewDelegate,SelectAviatorImage,SelectMenuOption {
    
    func setBackToHome() {
       self.navigationController?.popToRootViewController(animated: true)
    }
    
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
    
    //MARK:--> IBOUTLETS
    
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var lblBioDescription: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblActivityDesignation: UILabel!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var btn_BackTo: UIButton!
    @IBOutlet weak var lbl_Credential: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_FunFactsList: UILabel!
    @IBOutlet weak var lbl_CampMotto: UILabel!
    @IBOutlet weak var lbl_Facts: UILabel!
    
    
    @IBOutlet weak var lbl_PreUserName: UILabel!
    @IBOutlet weak var lbl_NextUserName: UILabel!
    @IBOutlet weak var img_PreProfile: UIImageView!
    @IBOutlet weak var img_NextProfile: UIImageView!
    @IBOutlet weak var view_Next: UIView!
    @IBOutlet weak var view_Previous: UIView!
    //Devansh
    @IBOutlet weak var profileBckgrdImageView: UIImageView!
    
    var arr_CastUsers = [CastDictModel]()
    var selectedUserIndex:Int!
    var isFromCampfire : String = ""
    
    var viewController : MenuDrawerController?
    //MARK:--> VARIABLES
    var castDescription = String()
    var castName = String()
    var castImage = String()
    var castActivity = String()
    
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
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            targetVw.isHidden = true
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        }
        
        if isFromCampfire == "Campfire" {
            imgVwProfile.contentMode = .scaleAspectFill
            imgVwProfile.clipsToBounds=true
            getCounselorsUsers {}
        } else {
            updateData()
        }
    }
    
    func updateData() {
        //  lblTitle.text!               = cast
        lblBioDescription.text!      = castDescription.htmlToString
        lblUserName.text!            = castName
        imgVwProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        lblActivityDesignation.text! = castActivity
        lbl_Credential.text!         = arr_CastUsers[selectedUserIndex].cast_Credential.htmlToString
        
        //        if UIDevice.current.userInterfaceIdiom == .pad {
        if arr_CastUsers[selectedUserIndex].castTitle == "" {
            lbl_CampMotto.isHidden=true
            //Varinder10
            lbl_CampMotto.text! = ""
        }
        lbl_Title.text!         = arr_CastUsers[selectedUserIndex].castTitle.htmlToString
        
        if isFromCampfire == "WebSeries" {
            lblTitle.text! = "MEET THE HAPPY CAMPER LIVE CAST"
        } else {
            lblTitle.text! = "MEET YOUR " + arr_CastUsers[selectedUserIndex].cast_Counselor.htmlToString.uppercased()
        }
        
        if arr_CastUsers[selectedUserIndex].arr_Facts.count > 0 &&  isFromCampfire != "WebSeries" {
            var str_FactsList = ""
            for i in 0..<arr_CastUsers[selectedUserIndex].arr_Facts.count {
                let str_Data = arr_CastUsers[selectedUserIndex].arr_Facts[i].stringValue
                str_FactsList.append("*" + str_Data + "\n")
            }
            lbl_FunFactsList.text! = str_FactsList
        } else {
            lbl_Facts.isHidden=true
            //Varinder10
            lbl_Facts.text! = ""
            lbl_FunFactsList.isHidden=true
        }
        //        }
        
        //Devansh
        if UIDevice.current.userInterfaceIdiom != .pad {
            profileBckgrdImageView?.image = imgVwProfile.image
        }
        
        let arr_FirstObject1 = arr_CastUsers[..<selectedUserIndex] // 1, 2, 3, 4, 5
        let arr_lastObject2 = arr_CastUsers[selectedUserIndex..<arr_CastUsers.count] // last object
        
        let firstObject:[CastDictModel]  = Array(arr_FirstObject1)
        let lastObject:[CastDictModel]  = Array(arr_lastObject2)
        
        if firstObject.count > 0 {
            self.lbl_PreUserName.text            = firstObject.last!.castName
            self.img_PreProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(firstObject.last!.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        } else {
            view_Previous.isHidden=true
        }
        
        if lastObject.count > 1 {
            self.lbl_NextUserName.text            = lastObject[1].castName
            self.img_NextProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(lastObject[1].castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        } else {
            view_Next.isHidden=true
        }
    }
    
    func getCounselorsUsers(_ completion:@escaping() -> Void) {
        let param = [
            "user_type"           :   "counsler"
            ] as [String : Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetCast)", params: param as Dictionary<String, Any>, showIndicator: true, completion: { (JSON) in
            
            let appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                if let resultDictAry = JSON["results"] as? NSArray {
                    if resultDictAry.count > 0 {
                        for i in 0..<resultDictAry.count {
                            if let bnrDict = resultDictAry[i] as? NSDictionary {
                                let CastDictModelObj = CastDictModel()
                                CastDictModelObj.getCastDict(dict: bnrDict)
                                self.arr_CastUsers.append(CastDictModelObj)
                                
                                if (bnrDict["name"] as? String)!.components(separatedBy: " ")[0] == self.castName {
                                    self.selectedUserIndex=i
                                    self.castDescription = bnrDict["description"] as! String
                                    self.castImage = bnrDict["image"] as! String
                                    self.castName  = bnrDict["name"] as! String
                                    self.castActivity  = bnrDict["activity"] as! String
                                }
                            }
                        }
                    }
                }
                completion()
                DispatchQueue.main.async {
                    self.updateData()
                }
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Devansh
        if UIDevice.current.userInterfaceIdiom == .pad{
            headerDelegate = self
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
        }
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnBackAction(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)

//        if sender.tag == 0 {
//            Proxy.shared.rootWithoutDrawer("TabbarViewController")
//        } else {
//            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
//        }
    }
    
    //MARK:- Handle Next and Previous button
    @IBAction func buttonActions(_ sender: UIButton) {
        if arr_CastUsers.count > 0 {
            if sender.tag == 0 { // Left
                var previousValue:NSInteger!
                var nextValue:NSInteger!
                
                // Change Previous User
                if selectedUserIndex > 0 {
                    selectedUserIndex  = selectedUserIndex-1
                    nextValue = selectedUserIndex+1
                    previousValue = selectedUserIndex-1
                    
                    let CastDictModelObj = arr_CastUsers[selectedUserIndex]
                    imgVwProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(CastDictModelObj.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                    //Devansh
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        profileBckgrdImageView?.image = imgVwProfile.image
                    }
                    lblBioDescription.text!      = CastDictModelObj.castDescription.htmlToString
                    lblUserName.text!            = CastDictModelObj.castName
                    lbl_Credential.text!         = CastDictModelObj.cast_Credential.htmlToString
                    
                    lbl_Title.text!         = CastDictModelObj.castTitle.htmlToString
                    
                    if isFromCampfire != "WebSeries" {
                        lblTitle.text! = "MEET YOUR " + CastDictModelObj.cast_Counselor.htmlToString.uppercased()
                    }
                    
                    var str_FactsList = ""
                    for i in 0..<CastDictModelObj.arr_Facts.count {
                        let str_Data = CastDictModelObj.arr_Facts[i].stringValue
                        str_FactsList.append("*" + str_Data + "\n")
                    }
                    lbl_FunFactsList.text! = str_FactsList
                    
                    // if Next value found
                    if nextValue <= arr_CastUsers.count-1 {
                        let nextData = arr_CastUsers[nextValue]
                        self.lbl_NextUserName.text            = nextData.castName
                        self.img_NextProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(nextData.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                    }
                    
                    if selectedUserIndex != arr_CastUsers.count-1 {
                        view_Next.isHidden=false
                        
                    }
                    
                    if selectedUserIndex == 0 {
                        view_Previous.isHidden=true
                        return
                    }
                    
                    // If old value found
                    if previousValue >= 0 {
                        let nextData = arr_CastUsers[previousValue]
                        
                        self.lbl_PreUserName.text            = nextData.castName
                        self.img_PreProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(nextData.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                        
                    }
                    
                    
                }
            } else { // Right
                
                // Change next User
                
                var nextValue:NSInteger!
                var oldValue:NSInteger!
                
                if selectedUserIndex < arr_CastUsers.count-1 {
                    
                    //Set main frame
                    selectedUserIndex  = selectedUserIndex+1
                    
                    //Set left previous data
                    oldValue = selectedUserIndex-1
                    
                    //Set right next data
                    nextValue = selectedUserIndex+1
                    
                    let CastDictModelObj = arr_CastUsers[selectedUserIndex]
                    imgVwProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(CastDictModelObj.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                    //Devansh
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        profileBckgrdImageView?.image = imgVwProfile.image
                    }
                    lblBioDescription.text!      = CastDictModelObj.castDescription.htmlToString
                    lblUserName.text!            = CastDictModelObj.castName
                    lbl_Credential.text!         = CastDictModelObj.cast_Credential.htmlToString
                    
                    
                    lbl_Title.text!         = CastDictModelObj.castTitle.htmlToString
                    if isFromCampfire != "WebSeries" {
                        lblTitle.text! = "MEET YOUR " + CastDictModelObj.cast_Counselor.htmlToString.uppercased()
                    }
                    var str_FactsList = ""
                    for i in 0..<CastDictModelObj.arr_Facts.count {
                        let str_Data = CastDictModelObj.arr_Facts[i].stringValue
                        str_FactsList.append("*" + str_Data + "\n")
                    }
                    lbl_FunFactsList.text! = str_FactsList
                    
                    // If old value found
                    if selectedUserIndex > 0 {
                        let oldData = arr_CastUsers[oldValue]
                        self.lbl_PreUserName.text            = oldData.castName
                        self.img_PreProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(oldData.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                    }
                    
                    if selectedUserIndex > 0 {
                        view_Previous.isHidden=false
                    }
                    
                    if selectedUserIndex == arr_CastUsers.count-1 {
                        view_Next.isHidden=true
                        return
                    }
                    
                    // if Next value found
                    if nextValue <= arr_CastUsers.count-1 {
                        let nextData = arr_CastUsers[nextValue]
                        self.lbl_NextUserName.text            = nextData.castName
                        self.img_NextProfile.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(nextData.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                    }
                }
            }
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
    
}



