//
//  ActivityTVC.swift
//  HappyCamper
//
//  Created by wegile on 02/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class ActivityTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var CollVwSec: UICollectionView!
    @IBOutlet weak var lblTitleHeader: UILabel!
    //MARK:--> VARIABLES
    var webSeriesAry = ["web_1","web_2","web_3","web_4"]
    var cookingAry = ["cooking_1","cooking_2","cooking_3","cokking_4"]
    var droneAry = ["drones_1","drons_2","drons_3","drons_4"]
    var expolreAry = ["explore_1","explore_2","explore_3","explore_4"]
    var headerString = String()
    var currentCont = UIViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CollVwSec.delegate = self
        CollVwSec.dataSource = self
        CollVwSec.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE FUNCTIONS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return webSeriesAry.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollVwSec.dequeueReusableCell(withReuseIdentifier: "GuestLandingCVC", for: indexPath) as! GuestLandingCVC
        if headerString == "COOKING" {
             cell.imgCookingVw.image = UIImage(named: cookingAry[indexPath.item])
        } else if headerString == "WEB SERIES"{
             cell.imgCookingVw.image = UIImage(named: webSeriesAry[indexPath.item])
        } else if headerString == "DRONES" {
             cell.imgCookingVw.image = UIImage(named: droneAry[indexPath.item])
        } else if headerString == "360 EXPLORE" {
             cell.imgCookingVw.image = UIImage(named: expolreAry[indexPath.item])
        }
       
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if CollVwSec.tag == 0 {
            Proxy.shared.pushToNextVC(identifier: "CookingActivitiesVC", isAnimate: true, currentViewController: currentCont)
        } else if CollVwSec.tag == 1 {
            Proxy.shared.pushToNextVC(identifier: "EpisodesDetailsVC", isAnimate: true, currentViewController: currentCont)
        } 
    }
    
    //MARK:--> COLLECTION VIEW RELOAD
    func colVwReload() {
        CollVwSec.reloadData()
    }
}
