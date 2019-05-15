//
//  CastCVC.swift
//  HappyCamper
//
//  Created by wegile on 24/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class CastCVC: UICollectionViewCell {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var view_Content: UIView!
    
    override func awakeFromNib() {
        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.dropShadow(color: UIColor.gray, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
            } else {
                self.view_Content.dropShadow(color: UIColor.black, opacity: 0.1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
            }
        }
    }
}
