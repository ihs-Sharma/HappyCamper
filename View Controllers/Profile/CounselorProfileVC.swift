//
//  CounselorProfileVC.swift
//  HappyCamper
//
//  Created by wegile on 17/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CouselorProfileCVC: UICollectionViewCell {
    
}


class CounselorProfileVC: UIViewController {
    //MARK--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
     //MARK--> VARIABLES
    var counselorProfileVMObj = CounselorProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnSignInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSendMsgs(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "ActivityLiveVC", isAnimate: true, currentViewController: self)
    }
}
