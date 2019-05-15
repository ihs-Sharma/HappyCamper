//
//  GuestLandingCVC.swift
//  HappyCamper
//
//  Created by wegile on 23/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class GuestLandingCounselorCVC: UICollectionViewCell {
    @IBOutlet weak var lblContentDescription: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblLive: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var view_Content: UIView!
    @IBOutlet weak var imgVwAdv: UIImageView!
    
    override func awakeFromNib() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.dropShadow(color: UIColor.gray, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
//            view_Content.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        } else {
            view_Content.dropShadow(color: UIColor.black, opacity: 0.1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
        }
    }
    
}

class GuestLandingCVC: UICollectionViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblContentDescription: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblLive: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var view_Content: UIView!
    //LIVE ACTIVITIES
    @IBOutlet weak var imgCookingVw: UIImageView!
    
    //ADVERTISEMENT
    @IBOutlet weak var imgVwAdv: UIImageView!
    
    override func awakeFromNib() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.dropShadow(color: UIColor.gray, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
//            view_Content.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        } else {
            view_Content.dropShadow(color: UIColor.black, opacity: 0.1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
        }
    }
    
    
//    override var isSelected: Bool {
//        didSet{
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
//                self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.2, y: 1.2) : CGAffineTransform.identity
//            }, completion: nil)
//            
//        }
//    }
}
