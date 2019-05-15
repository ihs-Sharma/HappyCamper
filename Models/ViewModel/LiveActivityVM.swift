//
//  LiveActivityVM.swift
//  HappyCamper
//
//  Created by wegile on 02/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
class LiveActivityVM {
}

extension LiveActivityVC : UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate ,UITableViewDataSource{
 
    //MARK:-> COLLECTION VIEW DELEGATE FUNCTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tblCell = tblVw.dequeueReusableCell(withIdentifier: "ActivityTVC", for: indexPath) as! ActivityTVC
        tblCell.lblTitleHeader.text = sectionAry[indexPath.row]
        tblCell.headerString = sectionAry[indexPath.row]
        tblCell.CollVwSec.tag = indexPath.row
        tblCell.currentCont = self
        tblCell.colVwReload()
        return tblCell
    }
    
    //MARK:-> COLLECTION VIEW DELEGATE FUNCTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentEpisodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "ActivityHeaderCVC", for: indexPath) as! ActivityHeaderCVC
        cell.imgVw.image = UIImage(named: currentEpisodes[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 300, height: 200)
    }
}
