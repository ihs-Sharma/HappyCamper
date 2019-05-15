//
//  ProfileVM.swift
//  HappyCamper
//
//  Created by wegile on 02/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class ProfileVM {
    var userName     = String()
    var userId       = String()
    var userMsgAlrt  = String()
    //MARK:--> SIGN UP API FUNCTION
    func UpdateProfileApi(_ completion:@escaping() -> Void) {
        
        let param = [
                "user_name"     :  "\(userName)",
                "id"            :   Proxy.shared.userId()
            
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KUpdateProfile)", params: param, showIndicator: true, completion: { (JSON) in
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if  appResponse == 200 {
            if let userDetail = JSON["userdetails"] as? NSDictionary {
                let UserModelObj = UserModel()
                UserModelObj.getUserDetail(dict: userDetail)
                KAppDelegate.UserModelObj = UserModelObj
                }
                self.userMsgAlrt  = JSON["message"] as? String ?? ""
                completion()
            } else {
                self.userMsgAlrt  = JSON["message"] as? String ?? ""
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
}

extension ProfileVC: UITextFieldDelegate {

    //MARK:---> CHECK VALIDATION
    func checkValidation(){
        if txtFldName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.name, currentViewController: self)
        } else if !Proxy.shared.isValidInput(txtFldName.text!) {
             Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validName, currentViewController: self)
        }else if txt_LastName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.lastName, currentViewController: self)
        } else if !Proxy.shared.isValidInput(txt_LastName.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validLastName, currentViewController: self)
        } else {
            ProfileVMObj.userName = txtFldName.text! + txt_LastName.text!
            ProfileVMObj.UpdateProfileApi {
                Proxy.shared.rootWithoutDrawer("TabbarViewController")
//                Proxy.shared.pushToNextVC(identifier: "TabbarViewController", isAnimate: true, currentViewController: self)
            }
        }
    }
}
    
    

