//
//  CamperCommunityTVC.swift
//  HappyCamper
//
//  Created by wegile on 25/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CamperCommunityCVC: UICollectionViewCell {
    
}

class CamperCommunityTVC: UITableViewCell,UICollectionViewDataSource, UICollectionViewDelegate {
   
    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var advBnrImgVw: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var constColVwHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colVw.delegate = self
        colVw.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE FUNCTIONS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "CamperCommunityCVC", for: indexPath) as! CamperCommunityCVC
        return cell
    }

}
