//
//  SelectSubscriptionCVC.swift
//  HappyCamper
//
//  Created by wegile on 20/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class SelectSubscriptionCVC: UICollectionViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblIncludeFunds: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblBillingType: UILabel!
    @IBOutlet weak var lbl_CutPrice: UILabel!
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var img_BestValue: UIImageView!

   
    //MARK:--> REGISTER PAYMENTS
    @IBOutlet weak var lblPlans: UILabel!
    @IBOutlet weak var lblPlanPrice: UILabel!
    @IBOutlet weak var lblPlanBillType: UILabel!
    
    override func awakeFromNib() {
        view_Content.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
}
