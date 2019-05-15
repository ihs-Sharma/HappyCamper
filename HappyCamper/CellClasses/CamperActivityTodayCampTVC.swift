//
//  CamperActivityTodayCampTVC.swift
//  HappyCamper
//
//  Created by wegile on 18/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CamperActivityTodayCampCVC: UICollectionViewCell {
    
}

class CamperActivityTodayTVC: UITableViewCell {
    //MARK:--> IBOUTLES
    @IBOutlet weak var regularColVw: UICollectionView!
}


class CamperActivityTodayCampTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var todayCampColVw: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE FUNCTIONS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == todayCampColVw {
            return 10
        } else{
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == todayCampColVw {
            let colCell = todayCampColVw.dequeueReusableCell(withReuseIdentifier: "CamperActivityTodayCampCVC", for: indexPath) as! CamperActivityTodayCampCVC
            cell = colCell
        } else {
//let colCell = regularColVw.dequeueReusableCell(withReuseIdentifier: "CamperActivityTodayCampCVC", for: indexPath) as! CamperActivityTodayCampCVC
//cell = colCell
        }
        return cell
    }
}
