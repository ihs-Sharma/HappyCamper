//
//  CampActivityTVC.swift
//  HappyCamper
//
//  Created by wegile on 02/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CampActivityTVC: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    //MARK:--> VARIABLES
    var headerString = String()
    let cookingImg = ["cooking_1","cooking_2","cokking_4","cooking_3"]
    let activityImg = ["activities_1","activities_2","activities_3","activities_4"]
    let campImg = ["video_7","video_6","video_5","video_4"]
    override func awakeFromNib() {
        super.awakeFromNib()
        colVw.delegate = self
        colVw.dataSource = self
        colVw.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cookingImg.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "CampActivityCVC", for: indexPath) as! CampActivityCVC
        if headerString == "CAMP ACTIVITIES" {
             cell.imgVw.image = UIImage(named: activityImg[indexPath.item])
        } else if headerString == "COOKING STORIES" {
             cell.imgVw.image = UIImage(named: cookingImg[indexPath.item])
        } else{
             cell.imgVw.image = UIImage(named: campImg[indexPath.item])
        }
        return cell
    }

    //MARK:--> COLLECTION VIEW RELOAD
    func colViewReload() {
        colVw.reloadData()
    }

}
