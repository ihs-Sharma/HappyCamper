//
//  SignInVM.swift
//  HappyCamper
//
//  Created by wegile on 25/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class SignInVM {
    var userEmail = String()
    var userPassword =  String()
    var dataToken = String()
    var currentCont = UIViewController()
    
    //MARK:--> SIGN UP API FUNCTION
    func postSignInApi(_ completion:@escaping(_  isSubscribed:Bool) -> Void) {
        
        let param = [
            "email"     :  "\(userEmail)",
            "password"  :  "\(userPassword)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KLogin)", params: param, showIndicator: true, completion: { (JSON) in
            
            let alertMsg = "\(JSON["message"] as? String ?? "")"
            
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                if let auth = JSON["data"] as? String {
                    UserDefaults.standard.set(auth, forKey: "access-token")
                    UserDefaults.standard.synchronize()
                }
                
                var isSubscribed = Bool()
                if let plan_Detail = JSON["subscriptionDetails"] as? NSDictionary  { //Hitesh
                    if plan_Detail["status"] as? String != "active" {
                        // Check if plan status is "Cancel" and Subscription end date is coming
                        let subscriptionExpiry = JSON["subscription_end_date"] as! String
                        
                        //If not empty
                        if subscriptionExpiry != "" {
                            
                            let expiryDate = self.convertString(dateInString:subscriptionExpiry)
                            let currentDate = Date()
                            
                            //Check If plan expiry is still pending from current date
                            if expiryDate.compare(currentDate) == .orderedSame || expiryDate.compare(currentDate) == .orderedDescending  {
                                isSubscribed = true
                            } else {
                                isSubscribed = false
                            }
                        } else {
                            isSubscribed = false
                        }
                    } else {
                        isSubscribed = true
                    }
                } else {
                    isSubscribed = false
                }
                
                if let userDetail = JSON["userdetails"] as? NSDictionary {
                    let UserModelObj = UserModel()
                    UserModelObj.getUserDetail(dict: userDetail)
                    KAppDelegate.UserModelObj = UserModelObj
                }
                Proxy.shared.rootWithoutDrawer("TabbarViewController")
                Proxy.shared.presentAlert(withTitle: "", message: alertMsg , currentViewController: self.currentCont)
                completion(isSubscribed)
            } else {
                Proxy.shared.presentAlert(withTitle: "", message: alertMsg , currentViewController: self.currentCont)
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    func convertString(dateInString: String) -> NSDate
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let date = dateFormatter.date(from:dateInString)!
        
        return date as NSDate
    }
}



extension SignInVC: UITextFieldDelegate {
    
    //MARK:--> VALIDATION
    func validationTextfield() {
        if txtFldEmailAdd.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.email, currentViewController: self)
        } else if !Proxy.shared.isValidEmail(txtFldEmailAdd.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validEmail, currentViewController: self)
        } else if txtfldPassWord.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.password, currentViewController: self)
        } else {
            SignInVMObj.userEmail    = txtFldEmailAdd.text!
            SignInVMObj.userPassword = txtfldPassWord.text!
            SignInVMObj.currentCont = self
            SignInVMObj.postSignInApi { (isSubscribed) in
                if !isSubscribed
                {
                    kisSubscribed = isSubscribed
                }
            }
            
        }
    }
    
    //MARK:--> Delegate of text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldEmailAdd{
            txtFldEmailAdd.resignFirstResponder()
            txtfldPassWord.becomeFirstResponder()
        }else if textField == txtfldPassWord{
            txtfldPassWord.resignFirstResponder()
        }
        return true
    }
}
