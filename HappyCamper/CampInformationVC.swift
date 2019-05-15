//
//  CampInformationVC.swift
//  HappyCamper
//
//  Created by wegile on 29/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CampInformationVC: UIViewController {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var txtFldFullName: UITextField!
    @IBOutlet weak var txtFldEmailAddress: UITextField!
    @IBOutlet weak var txtFldHomePhone: UITextField!
    @IBOutlet weak var txtFldWorkPhone: UITextField!
    @IBOutlet weak var txtFldFax: UITextField!
    @IBOutlet weak var txtFldAddressOne: UITextField!
    @IBOutlet weak var txtFldAddressTwo: UITextField!
    @IBOutlet weak var txtFldCity: UITextField!
    @IBOutlet weak var txtFldStateProvince: UITextField!
    @IBOutlet weak var txtFldZipCode: UITextField!
    @IBOutlet weak var txtFldCountry: UITextField!
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var txtFldSchooGrade: UITextField!
    @IBOutlet weak var txtFldGender: UITextField!
    @IBOutlet weak var txtFldChildNameTwo: UITextField!
    @IBOutlet weak var txtFldChildGradeTwo: UITextField!
    @IBOutlet weak var txtFldGenderCHildTwo: UITextField!
    @IBOutlet weak var txtFldNameThree: UITextField!
    @IBOutlet weak var txtFldSchoolGradeChildThree: UITextField!
    @IBOutlet weak var txtFldGenderChildThree: UITextField!
    @IBOutlet weak var txtFldDesiredClass: UITextField!
  
    @IBOutlet weak var VwMenu: UIView!
    @IBOutlet weak var vwLogInSignUp: UIView!
    @IBOutlet weak var imgVwProfile: SetCornerImageView!
    @IBOutlet weak var bntUserName: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Proxy.shared.authNil() != "" {
            VwMenu.isHidden = false
            bntUserName.setTitle("\(KAppDelegate.UserModelObj.userName)", for: .normal)
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                imgVwProfile.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            }
        } else{
            VwMenu.isHidden = true
        }
        
        txtFldFullName.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldEmailAddress.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldHomePhone.attributedPlaceholder = NSAttributedString(string: "Home Phone", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldWorkPhone.attributedPlaceholder = NSAttributedString(string: "Work Phone", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldFax.attributedPlaceholder = NSAttributedString(string: "Fax", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldAddressOne.attributedPlaceholder = NSAttributedString(string: "Address 1", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldAddressTwo.attributedPlaceholder = NSAttributedString(string: "Address 2", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldCity.attributedPlaceholder = NSAttributedString(string: "City", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldStateProvince.attributedPlaceholder = NSAttributedString(string: "State/Province", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldZipCode.attributedPlaceholder = NSAttributedString(string: "Postal/Zip Code", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldCountry.attributedPlaceholder = NSAttributedString(string: "Country", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldName.attributedPlaceholder = NSAttributedString(string: "Chile #1 Name", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldSchooGrade.attributedPlaceholder = NSAttributedString(string: "Chile #1 School Grade", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldGender.attributedPlaceholder = NSAttributedString(string: "Chile #1 Gender", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldChildNameTwo.attributedPlaceholder = NSAttributedString(string: "Chile #2 Name", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldChildGradeTwo.attributedPlaceholder = NSAttributedString(string: "Chile #2 School Grade", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldGenderCHildTwo.attributedPlaceholder = NSAttributedString(string: "Chile #2 Gender", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldNameThree.attributedPlaceholder = NSAttributedString(string: "Chile #3 Name", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldSchoolGradeChildThree.attributedPlaceholder = NSAttributedString(string: "Chile #3 School Grade", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldGenderChildThree.attributedPlaceholder = NSAttributedString(string: "Chile #3 Gender", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
        txtFldDesiredClass.attributedPlaceholder = NSAttributedString(string: "Desired Dates", attributes: [NSAttributedString.Key.foregroundColor: AppInfo.darkGrayTextColor])
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
         Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnMenuAction(_ sender: Any) {
        
    }
    
    @IBAction func btnSendEmailAction(_ sender: Any) {
    }
}
