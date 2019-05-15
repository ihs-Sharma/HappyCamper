//
//  CookingActivitiesTVC.swift
//  HappyCamper
//
//  Created by wegile on 03/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CookingActivitiesTVC: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {

    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    //MARK:--> VARIABLES
    var headerString = String()
    var currentCont = UIViewController()
    var campLeader = ["leader_1","leader_3","leader_1","leader_3"]
    let cooking = ["cooking_1","cooking_2","cooking_3","cooking_1"]
    let leader = ["Leader 1","Leader 2","Leader 3","Leader 4"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colVw.delegate = self
        colVw.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campLeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  colVw.dequeueReusableCell(withReuseIdentifier: "CookingActivitieCVC", for: indexPath) as! CookingActivitieCVC
        if headerString == "LIVE COOKING" {
             cell.imgVwRecipie.image = UIImage(named: cooking[indexPath.item])
             cell.lblPrice.isHidden = true
             cell.lblDescription.isHidden = true
        } else if headerString == "COOKING" {
            cell.imgVwRecipie.image = UIImage(named: cooking[indexPath.item])
            cell.lblPrice.isHidden = false
            cell.lblDescription.isHidden = false
        } else{
            cell.imgVwRecipie.image = UIImage(named: campLeader[indexPath.item])
            cell.lblTitle.text = leader[indexPath.row]
            cell.lblPrice.isHidden = true
            cell.lblDescription.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if colVw.tag == 0 {
            Proxy.shared.pushToNextVC(identifier: "TabVC", isAnimate: true, currentViewController: currentCont)
        } else if colVw.tag == 1 {
            Proxy.shared.pushToNextVC(identifier: "TabVC", isAnimate: true, currentViewController: currentCont)
        } else if colVw.tag == 2 {
            Proxy.shared.pushToNextVC(identifier: "CampFireVC", isAnimate: true, currentViewController: currentCont) 
        }
    }
    //MARK:--> COLLECTION VIEW RELOAD
    func colVwReload() {
        colVw.reloadData()
    }
}
