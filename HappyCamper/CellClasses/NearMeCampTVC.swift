//
//  NearMeCampTVC.swift
//  HappyCamper
//
//  Created by wegile on 11/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class NearMeCampTVC: UITableViewCell {
    //CAMP NEAR ME
    //MARK:--> IBOUTLETS
    @IBOutlet weak var btnRequestInfo: UIButton!
    @IBOutlet weak var btnLearnMore: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgVwBanner: UIImageView!
    @IBOutlet weak var lblCampName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgVwAddress: UIImageView!
    @IBOutlet weak var featuredImg: UIImageView!
    
    //FAVOURITES CAMPS
    @IBOutlet weak var imgVwLogo: SetCornerImageView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblCampDescriptions: UILabel!
    @IBOutlet weak var lblCampAddress: UILabel!
    @IBOutlet weak var imgVwaAdd: UIImageView!
    @IBOutlet weak var lblTitleCamp: UILabel!
    @IBOutlet weak var imgVwbanner: UIImageView!
    
    @IBOutlet weak var featured_img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
