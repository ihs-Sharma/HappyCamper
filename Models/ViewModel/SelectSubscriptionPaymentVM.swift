//
//  SelectSubscriptionPaymentVM.swift
//  HappyCamper
//
//  Created by wegile on 26/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class SelectSubscriptionPaymentVM {
    
}

extension SelectSubscriptionPaymentVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packDuration.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "SelectSubscriptionPaymentCVC", for: indexPath) as! SelectSubscriptionPaymentCVC
        cell.lblDays.text = packDuration[indexPath.row]
        cell.lblSubscriptionPrice.text = packCost[indexPath.row]
        cell.lblSubsriptionType.text = packMonthlyBilling[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (self.colVw.frame.width-20)/2, height: 200)
    }
 
    //MARK:--> Delegate of text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFldName{
            txtFldName.resignFirstResponder()
            txtFldCardNumber.becomeFirstResponder()
        } else if textField == txtFldCardNumber{
            txtFldCardNumber.resignFirstResponder()
            txtFldExpireDate.becomeFirstResponder()
        } else if textField == txtFldExpireDate {
            txtFldExpireDate.resignFirstResponder()
            txtFldCVC.becomeFirstResponder()
        } else if textField == txtFldCVC {
            txtFldCVC.resignFirstResponder()
        }
        return true
    }
}


