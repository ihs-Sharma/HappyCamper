//
//  SubCategoryViewAllDetailCVC.swift
//  HappyCamper
//
//  Created by wegile on 15/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class SubCategoryViewAllDetailCVC: UICollectionViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var view_Content: UIView!

    override func awakeFromNib() {
        if UIDevice.current.userInterfaceIdiom == .pad {
//            self.dropShadow(color: UIColor.gray, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
            view_Content.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        } else {
            view_Content.dropShadow(color: UIColor.black, opacity: 0.1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
        }
    }
}
