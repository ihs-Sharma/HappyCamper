//
//  RegisterCampPaymentVM.swift
//  HappyCamper
//
//  Created by wegile on 07/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class RegisterCampPaymentVM {
    
}

extension RegisterCampPaymentVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = colVw.dequeueReusableCell(withReuseIdentifier: "SelectSubscriptionCVC", for: indexPath) as! SelectSubscriptionCVC
        cell.lblPlanPrice.text = price[indexPath.row]
        cell.lblPlanBillType.text = planBill[indexPath.row]
        cell.lblPlans.text = plans[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (self.colVw.frame.width-20)/2, height: 250)
    }
}
