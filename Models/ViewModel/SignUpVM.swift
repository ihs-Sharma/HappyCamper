//
//  SignUpVM.swift
//  HappyCamper
//
//  Created by wegile on 25/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import StoreKit


class SignUpVM {
    
    var userName = String()
    var last_Name = String()
    var userEmail = String()
    var userPassword = String()
    var userConfirmPassword = String()
    var userZipCode = String()
    var recaptchaReactive = String()
    
    var currentCont =   UIViewController()
    //MARK:--> SIGN UP API FUNCTION
    func postSignUpApi( completion:@escaping( _ alert_message:String) -> Void) {
        
        let param = [
            "user_email" : "\(userEmail)",
            "user_name" : "\(userName)",
            "last_name" : "\(last_Name)",
            "user_password" : "\(userPassword)",
            "conformPassword" : "\(userConfirmPassword)",
            "recaptchaReactive": "\(recaptchaReactive)",
            "zipcode" : "\(userZipCode)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSignUp)", params: param, showIndicator: true, completion: { (JSON) in
            let alertMsg = "\(JSON["message"] as? String ?? "")"
            
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                // Proxy.shared.pushToNextVC(identifier: "SubscriptionDetailVIew", isAnimate: true, currentViewController: self.currentCont)
      
                completion(alertMsg)

                // completion()
            } else {
                Proxy.shared.presentAlert(withTitle: "", message: alertMsg , currentViewController: self.currentCont)
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
}


extension SignUpVC: UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource , UITableViewDelegate, UITableViewDataSource {
    
    
    
    //MARK:--> TBALE VIEW DELEGATE FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVw {
            return demoText.count
        } else {
            return demoTextTwo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVwTwo.dequeueReusableCell(withIdentifier: "ConstanTVC", for: indexPath) as! ConstanTVC
        if tableView == tblVw {
            cell.lblTitle.text = demoText[indexPath.row]
            return cell
        } else {
            cell.lblTitle.text = demoTextTwo[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVw {
            return 150
        } else {
            return 150
        }
    }
    
    
    //MARK:-> TEXTFIELD VALIDATION
    func validationTextfield() {
        if txtFldName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.name, currentViewController: self)
        } else if !Proxy.shared.isValidInput(txtFldName.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validName, currentViewController: self)
        } else  if txt_LastName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.lastName, currentViewController: self)
        } else if !Proxy.shared.isValidInput(txt_LastName.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validLastName, currentViewController: self)
        } else if txtFldEmail.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.email, currentViewController: self)
        } else if !Proxy.shared.isValidEmail(txtFldEmail.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validEmail, currentViewController: self)
        } else if txtFldCreatePassword.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.password, currentViewController: self)
        } else if !Proxy.shared.isValidPassword(txtFldCreatePassword.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validPassword, currentViewController: self)
        } else if txtFldCreatePassword.text! != txtFldConfirmPassword.text! {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.passwordNotMatch, currentViewController: self)
        } else if txtFldZipCode.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.zipCode, currentViewController: self)
        } else {
            SignUpVMObj.userName     = txtFldName.text!
            SignUpVMObj.last_Name = txt_LastName.text!
            SignUpVMObj.userEmail    = txtFldEmail.text!
            SignUpVMObj.userPassword = txtFldCreatePassword.text!
            SignUpVMObj.userConfirmPassword = txtFldConfirmPassword.text!
            SignUpVMObj.userZipCode  = txtFldZipCode.text!
            SignUpVMObj.currentCont  = self
            
            SignUpVMObj.postSignUpApi { (alert) in
                
                let alert = UIAlertController(title: "", message: alert, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    
                    let signVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                    self.navigationController?.pushViewController(signVC, animated: true)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    //MARK:- delegate of text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldName {
            txtFldName.resignFirstResponder()
            txtFldEmail.becomeFirstResponder()
        } else if textField == txtFldEmail {
            txtFldEmail.resignFirstResponder()
            txtFldCreatePassword.becomeFirstResponder()
        } else if textField == txtFldCreatePassword {
            txtFldCreatePassword.resignFirstResponder()
            txtFldConfirmPassword.becomeFirstResponder()
        } else if textField == txtFldConfirmPassword {
            txtFldConfirmPassword.resignFirstResponder()
            txtFldZipCode.becomeFirstResponder()
        } else if textField == txtFldZipCode {
            txtFldZipCode.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldZipCode {
        let maxLength = 6
        let currentString: NSString = txtFldZipCode!.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        } else {
            return true
        }
    }
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packDuration.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "SelectSubscriptionCVC", for: indexPath) as! SelectSubscriptionCVC
        cell.lblDays.text        = packDuration[indexPath.row]
        cell.lblPrice.text       = packCost[indexPath.row]
        //cell.lblBillingType.text = packMonthlyBilling[indexPath.row]
        cell.btnSelect.tag       = indexPath.item
        cell.btnSelect.addTarget(self, action: #selector(selectedPlanAction), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (self.colVw.frame.width-20)/2, height: 200)
    }
    
    
    @objc func selectedPlanAction(sender: UIButton) {
        if sender.tag == 0 {
            if options != nil {
                guard let option = options?[0] else { return }
                SubscriptionService.shared.purchase(subscription: option)
            }
        } else if sender.tag == 1 {
            if options != nil {
                guard let option = options?[0] else { return }
                SubscriptionService.shared.purchase(subscription: option)
            }
        } else {
            if options != nil {
                guard let option = options?[0] else { return }
                SubscriptionService.shared.purchase(subscription: option)
            }
        }
    }
}


