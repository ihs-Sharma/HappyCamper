//
//  CamperUploadDetailTVC.swift
//  HappyCamper
//
//  Created by wegile on 08/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CamperContestTVC: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
}

class CamperLiveFeatureTVC: UITableViewCell {
    @IBOutlet weak var imgVw: UIImageView!
}

class CamperUploadDetailTVC: UITableViewCell {
    //MARK:--> IBOUTLETS  TOP 10 VIDEOS
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var btnTotalVw: UIButton!
    
    //
    @IBOutlet weak var lblShareStuffTitle: UILabel!
    @IBOutlet weak var lblShareDescriptions: UILabel!
    @IBOutlet weak var btnShareYourStuff: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
