//
//  EpisodesDetailsVM.swift
//  HappyCamper
//
//  Created by wegile on 24/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

class WebSeriesVM {
    
}

extension EpisodesDetailsVC : UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellMain = UITableViewCell()
        if indexPath.row == 3 {
            let cell = tblVw.dequeueReusableCell(withIdentifier: "AdvertisementTVC", for: indexPath) as! AdvertisementTVC
            cellMain = cell
        } else {
            let cell = tblVw.dequeueReusableCell(withIdentifier: "EpisodesDetailsTVC", for: indexPath) as! EpisodesDetailsTVC
            cell.lblHeaderTitle.text = sectionHeader[indexPath.row]
            cell.colVwReload()
            cellMain = cell
        }
        return cellMain
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castImag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVw.dequeueReusableCell(withReuseIdentifier: "CastCVC", for: indexPath) as! CastCVC
        cell.imgVw.image = UIImage(named: castImag[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 250)
    }

}
