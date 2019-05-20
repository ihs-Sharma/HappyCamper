//
// CoinCanteenVC.swift
// HappyCamper
//
// Created by wegile on 01/03/19.
// Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CoinCanteenVC: UIViewController, SelectMenuOption ,SelectAviatorImage,TopHeaderViewDelegate {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    // @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var tblAdcoinVC: UITableView!
    @IBOutlet weak var btnBack_WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_WAYS: UILabel!
    @IBOutlet weak var btn_Menu: UIButton!

    //MARK:--> VARIABLES
    var CoinCanteenVMObj = CoinCanteenVM()
    var viewController : MenuDrawerController?
    var i = 0
//    var txt_Change = ["BECOME A MEMBER","INVITE A FRIEND","WATCH ACTIVITIES","SUBMIT YOUR VIDEOS","ENTER CONTESTS","AND MORE!","WAYS TO EARN COINS"];
    
    func setBackToHome() {
              Proxy.shared.rootWithoutDrawer("TabbarViewController")
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Select Options
    func selectOptionByName(name: String!) {
        switch name {
        case "live":
            // Proxy.shared.pushToNextVC(identifier: "CampDetailVC", isAnimate: true, currentViewController: self)
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
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            self.navigationController?.navigationBar.topItem?.title = "CANTEEN"
            Proxy.shared.showNavigationOnTopMenu(controller: self)
        }
        
        //varinder10
        if UIDevice.current.userInterfaceIdiom != .pad {
            if let leftMenuController = SideMenuManager.default.menuLeftNavigationController?.viewControllers.first as? LeftMenuViewController{
                leftMenuController.delegate = self;
            }
            
        }
    
        if KAppDelegate.isCoinCanteenTabSelected {
            //Devansh
            if UIDevice.current.userInterfaceIdiom == .pad{
                self.btnBack_WidthConstraint.constant=0
                KAppDelegate.isCoinCanteenTabSelected=false
            }
        }
        // Load Data
         self.reloadData()
    }
    
    // Play Text
    @objc func update() {
        if(i>CoinCanteenVMObj.arr_spinText.count-1){
            i=0
        }
        lbl_WAYS.text = (CoinCanteenVMObj.arr_spinText[i] as! String)
        i += 1
    }
    
    func changeText() {
        
        //inside viewDidLoad
        let animation = CAKeyframeAnimation()
        animation.keyPath = "opacity"
        animation.values = [0, 1, 1, 0]
        animation.keyTimes = [0, 0.1, 0.9, 1]
        animation.duration = 2.0 //same as your timer
        animation.repeatCount = Float.infinity
        
        lbl_WAYS.layer.add(animation, forKey: "fade")
    }
    
    func reloadData() {
        CoinCanteenVMObj.CanteenModelAry.removeAll()
        CoinCanteenVMObj.postCoinCanteenApi {
            
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            self.changeText()
            DispatchQueue.main.async {
                // self.colVw.reloadData()
                self.tblAdcoinVC.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom != .pad{
            return
        }
        SelectAviatorImageObj = self
        headerDelegate = self
        
        let slectedAviator = Proxy.shared.selectedAviatorImage()
        if slectedAviator != "" {
            view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
        }
        
        targetVw.isHidden = true
        
        viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
        viewController?.delegate = self
        
        targetVw.addSubview(viewController!.view)
        viewController?.tblVw.delegate = viewController
        viewController?.tblVw.dataSource = viewController
    }
    
        override func viewWillDisappear(_ animated: Bool) {
             KAppDelegate.isCoinCanteenTabSelected=false
        }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
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
    
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.tblAdcoinVC.reloadData()
        }
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func btnMenuAction(){
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}
