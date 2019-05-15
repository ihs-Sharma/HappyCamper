//
//  CampStaffTVC.swift
//  HappyCamper
//
//  Created by wegile on 17/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CampStaffCVC: UICollectionViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
}

class CampStaffTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var currentVc = UIViewController()
    var CastDictModelAry  = [CastDictModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colVw.delegate = self
        colVw.dataSource = self
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CastDictModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "CampStaffCVC", for: indexPath) as! CampStaffCVC
        
        if CastDictModelAry.count != 0 {
            let CastDictModelObjAry = CastDictModelAry[indexPath.row]
            cell.lblCountry.text = CastDictModelObjAry.castActivity
            let castDescriptions = CastDictModelObjAry.castDescription
            cell.lblDescription.text = castDescriptions.htmlToString
           
            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KCampTestUrl)\(CastDictModelObjAry.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Proxy.shared.pushToNextVC(identifier: "CastScreenVC", isAnimate: true, currentViewController: currentVc)
    }
    
   func colViewReload() {
        colVw.reloadData()
    }
}
