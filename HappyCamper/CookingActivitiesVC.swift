//
//  CookingActivitiesVC.swift
//  HappyCamper
//
//  Created by wegile on 03/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CookingActivitiesVC: UIViewController, SelectMenuOption {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var tblVw: UITableView!
    
    //MARK:--> VARIABLES
    var cookingActivitiesVMObj = CookingActivitiesVM()
    var sectionHeader = ["LIVE COOKING","COOKING","CAMP LEADER"]

    //MARK:--> VIEW CONTROLLER DELEGATE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
  
    @IBAction func btnCampfireAction(_ sender: Any) {
    }
    
    @IBAction func btnLiveAction(_ sender: Any) {
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self) 
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    //MARK:--> PROTOCOLS FUNCTIONS
    func didSelected(index: Int) {
        Proxy.shared.pushToNextVC(identifier: "SettingPopUpVC", isAnimate: true, currentViewController: self)
    }
}
