//
//  RegisterCampPaymentVC.swift
//  HappyCamper
//
//  Created by wegile on 07/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class RegisterCampPaymentVC: UIViewController {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    //MARK:--> VARIABLES
    var RegisterCampPaymentVMObj = RegisterCampPaymentVM()
    let plans = ["Monthly","Annually"]
    let planBill = ["Billed Monthly","Billed Annually"]
    let price = ["$15.00","$99.00"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //MARK:--> BUTTON ACTION
    @IBAction func btnSelectAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "RequestApprovalScreenVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
}
