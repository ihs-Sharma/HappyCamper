//
//  NearMeCampsVC.swift
//  HappyCamper
//
//  Created by wegile on 11/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
class NearMeCampCVC: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
}

class NearMeCampsVC: UIViewController, SelectMenuOption, SelectAviatorImage,TopHeaderViewDelegate,UIScrollViewDelegate {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var txtFldSearchCamp: UITextField!
    @IBOutlet weak var menuVw: UIView!
    
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwAviator: SetCornerImageView!
    @IBOutlet weak var btn_Menu: UIButton!
    @IBOutlet weak var img_Back: UIImageView!
    @IBOutlet weak var btnBack_WidthConstraint: NSLayoutConstraint!

    //MARK:--> VARIABLES
    var NearMeCampVMObj = NearMeCampVM()
    var viewController : MenuDrawerController?
    var variableConst = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","R","S","T","W","X","Y","Z"]
    var comeFromAboutUs = false
    var Isscrollpage = false
    var page = 1
    var isBackEnabled = false
    
    @IBOutlet weak var colVw: UICollectionView!
    
    func setBackToHome() {
        Proxy.shared.rootWithoutDrawer("TabbarViewController")

//        self.navigationController?.popToRootViewController(animated: true)
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
    
    //varinder17
    func showNavigationBack(){
        let image3 = UIImage(named: "left_arrow")
        let frameimg = CGRect(x: 15, y: 5, width: 13, height: 22)
        
        let someButton = UIButton(frame: frameimg)
        someButton.setBackgroundImage(image3, for: .normal)
        someButton.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        someButton.showsTouchWhenHighlighted = false
        
        let mailbutton = UIBarButtonItem(customView: someButton)
        navigationItem.leftBarButtonItem = mailbutton
    }
    
    @objc func backBtnAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //varinder10
        if UIDevice.current.userInterfaceIdiom != .pad {
            if let leftMenuController = SideMenuManager.default.menuLeftNavigationController?.viewControllers.first as? LeftMenuViewController{
                leftMenuController.delegate = self;
            }
            
            self.navigationController?.navigationBar.topItem?.title  = "CAMP NEAR ME"

            if comeFromAboutUs == true {
                self.showNavigationBack()
            } else {
                //varinder15
                if let navController = self.navigationController, navController.viewControllers.count >= 2 {
                    let viewController = navController.viewControllers[navController.viewControllers.count - 2]
                    if viewController.isKind(of: MemberBenefitsVC.self) {
                        self.title = "CAMP NEAR ME"
                    } else {
                        if UIDevice.current.userInterfaceIdiom != .pad {
                            Proxy.shared.showNavigationOnTopMenu(controller: self)
                        }
                    }
                } else {
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        Proxy.shared.showNavigationOnTopMenu(controller: self)
                    }
                }
            }
        } else {
            if isBackEnabled == false {
                self.img_Back.isHidden=true
                self.btnBack_WidthConstraint.constant=0
            }
        }
        
        tblVw.tableFooterView = UIView()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        targetVw.isHidden = true
        SelectAviatorImageObj = self
        viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
        viewController?.delegate = self
        
        targetVw.isHidden = true
        targetVw.addSubview(viewController!.view)
        viewController?.tblVw.delegate = viewController
        viewController?.tblVw.dataSource = viewController
        }
        
        //varinder7
        txtFldSearchCamp.attributedPlaceholder = NSAttributedString(string: "Search Camp", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        txtFldSearchCamp.textColor = AppInfo.PlaceHolderPurplColor
        
        let leftView = UILabel(frame: CGRect(x: 10, y: 0, width: 7, height: 26))
        leftView.backgroundColor = .clear
        
        txtFldSearchCamp.leftView = leftView
        txtFldSearchCamp.leftViewMode = .always
        txtFldSearchCamp.contentVerticalAlignment = .center
        
        //Load Data
        self.reloadData()
    }
    
    func reloadData() {
         getCampApi()
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        if targetVw.isHidden == true{
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    
    @objc func btnMenuAction(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.page = 1
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            headerDelegate = self
            targetVw.isHidden = true
            SelectAviatorImageObj = self
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage:#imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let HEIGHT_VIEW = 60
        tblVw.tableFooterView?.frame.size = CGSize(width: tblVw.frame.width, height: CGFloat(HEIGHT_VIEW))
    }
    
    
    func getCampApi() {
        NearMeCampVMObj.CampListModelAry = []
        NearMeCampVMObj.getCampListApi {
            self.Isscrollpage = false
            self.tblVw.reloadData()
        }
    }
    
    //MARK:- Pagination APi
    func getCampApipagination(count:Int) {
        //NearMeCampVMObj.CampListModelAry = []
        self.Isscrollpage = false
        NearMeCampVMObj.getCampListApi12(_pagenumber: count) {
            self.tblVw.tableFooterView?.isHidden = true
            self.tblVw.reloadData()
        }
    }
    
    //MARK:--> BUTTONS ACTIONS
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnAviatorAction(_ sender: Any) {
        Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: true, currentViewController: self)
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
    
    @IBAction func bntSearchAction(_ sender: Any) {
        self.page = 1
        NearMeCampVMObj.SearchKeyString = txtFldSearchCamp.text!
        getCampApi()
    }
    
    @IBAction func btnViewAllAction(_ sender: Any) {
        txtFldSearchCamp.text = ""
        NearMeCampVMObj.SearchKeyString = ""
        getCampApi()
    }
    
    
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
}
