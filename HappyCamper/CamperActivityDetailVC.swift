//
//  CamperActivityDetailVC.swift
//  HappyCamper
//
//  Created by wegile on 18/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CamperActivityDetailVC: UIViewController {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var tblVw: UITableView!
    //MARK:--> VAARIABLES
    var camperActivityDetailVMObj = CamperActivityDetailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK:--> BUTTON ACTION
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }

}
