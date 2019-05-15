//
//  PopEnterInformationVC.swift
//  HappyCamper
//
//  Created by wegile on 11/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class PopEnterInformationVC: UIViewController,UITextFieldDelegate {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var txtVwQuery: UITextView!
    @IBOutlet weak var txtFldParentFirstName: UITextField!
    @IBOutlet weak var txFldParentLastName: UITextField!
    @IBOutlet weak var txtFldChildName: UITextField!
    @IBOutlet weak var txtFldChildAge: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    @IBOutlet weak var sbmit_btn: UIButton!
    //MARK:--> VARIABLES
    var userCampId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sbmit_btn.buttonShadow()
        userDesigned()
    }
    
    func userDesigned() {
        txtFldParentFirstName.attributedPlaceholder = NSAttributedString(string: "Parent First Name",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        txFldParentLastName.attributedPlaceholder = NSAttributedString(string: "Parent Last Name",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        txtFldChildName.attributedPlaceholder = NSAttributedString(string: "Child Name",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        txtFldChildAge.attributedPlaceholder = NSAttributedString(string: "Child Age",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        txtFldEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnSubmitAction(_ sender: Any) {
        validationInformation()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:--> VALIDATION TEXTFIELD
    @objc func validationInformation() {
        if txtFldParentFirstName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.firstname, currentViewController: self)
        } else if !Proxy.shared.isValidInput(txtFldParentFirstName.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validName, currentViewController: self)
        } else if  txFldParentLastName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.lastName, currentViewController: self)
        } else if !Proxy.shared.isValidInput(txFldParentLastName.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validName, currentViewController: self)
        } else if txtFldChildName.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.name, currentViewController: self)
        } else if !Proxy.shared.isValidInput(txtFldChildName.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.childName, currentViewController: self)
        } else if txtFldChildAge.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.childAge, currentViewController: self)
        }  else if txtFldEmail.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.email, currentViewController: self)
        } else if !Proxy.shared.isValidEmail(txtFldEmail.text!)   {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validEmail, currentViewController: self)
        }   else if txtVwQuery.text!.isEmpty {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.EnterQuery, currentViewController: self)
        } else {
            postInformationApi(parentFirstName: txtFldParentFirstName.text!, parentLastName: txFldParentLastName.text!, chidName: txtFldChildName.text!, childAge: txtFldChildAge.text! , email: txtFldEmail.text!, queryString : txtVwQuery.text!)
        }
        //        else if txtFldPhoneNumber.text!.count <= 9 && txtFldPhoneNumber.text!.count >= 14 {
        //            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validPhoneNumber, currentViewController: self)
        //        }
        //        else if txtFldPhoneNumber.isBlank {
        //            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.phoneNumber, currentViewController: self)
        //        }
    }
    
    
    //MARK:-->API FUNCTION
    func postInformationApi(parentFirstName: String, parentLastName: String, chidName: String, childAge: String, email: String, queryString: String) {
        
        let param = [
            "camp_id"       :    "\(userCampId)",
            "child_age"     :    "\(childAge)",
            "child_name"    :    "\(chidName)",
            "email"         :    "\(email)",
            "enquiry"       :    "\(queryString)",
            "parent_fname"  :    "\(parentFirstName)",
            "parent_lname"  :    "\(parentLastName)"
            //            "phone_number"  :    "\(phoneNumber)"
            ] as [String:AnyObject]
        
        
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KAddInformation)", params: param, showIndicator: true, completion: { (JSON) in
            
            let alertMsg = JSON["message"] as? String ?? ""
            
            // Proxy.shared.presentAlert(withTitle: "", message: "\(alertMsg)", currentViewController: self)
            
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                
                let alertController = UIAlertController(title: "", message: "\(alertMsg)", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .destructive) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: false, completion: nil)
                
                Proxy.shared.pushToNextVC(identifier: "TabbarViewController", isAnimate: true, currentViewController: self)
            }else{
                Proxy.shared.presentAlert(withTitle: "", message: "\(alertMsg)", currentViewController: self)
            }
            Proxy.shared.hideActivityIndicator()
        })
        
        
    }
    
    //MARK:- delegate of text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldParentFirstName {
            txtFldParentFirstName.resignFirstResponder()
            txFldParentLastName.becomeFirstResponder()
        } else if textField == txFldParentLastName {
            txFldParentLastName.resignFirstResponder()
            txtFldChildName.becomeFirstResponder()
        } else if textField == txtFldChildName {
            txtFldChildName.resignFirstResponder()
            txtFldChildAge.becomeFirstResponder()
        }else if textField == txtFldChildAge {
            txtFldChildAge.resignFirstResponder()
            txtFldEmail.becomeFirstResponder()
        } else if textField == txtFldEmail {
            txtFldEmail.resignFirstResponder()
            //            txtFldPhoneNumber.becomeFirstResponder()
        } else {
            //            txtFldPhoneNumber.resignFirstResponder()
        }
        return true
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.dismiss(animated: true, completion: nil)
    //    }
}

extension UIButton
{
    func buttonShadow()
    {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
}
