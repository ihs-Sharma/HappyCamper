//
//  PopUpLogInVC.swift
//  HappyCamper
//
//  Created by wegile on 22/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class PopUpLogInVC: UIViewController, SelectMenuOption {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var txtFldUserName: UITextField!
    @IBOutlet weak var btnCheck: SetCornerButton!
    @IBOutlet weak var targetVw: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    //MARK:--> VARIABLES
    var viewController :MenuDrawerController?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
        targetVw.isHidden = true
        targetVw.addSubview(viewController!.view)
        viewController?.tblVw.delegate = viewController
        viewController?.tblVw.dataSource = viewController
        viewController?.delegate = self
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnLogInAction(_ sender: Any) {
         self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
         Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         targetVw.isHidden = true
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnDrawerAction(_ sender: Any) {
        if targetVw.isHidden == true{
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    
    //MARK:--> PROTOCOLS FUNCTIONS
    func didSelected(index: Int) {
       // Proxy.shared.pushToNextVC(identifier: "SettingPopUpVC", isAnimate: true, currentViewController: self)
    }
}

