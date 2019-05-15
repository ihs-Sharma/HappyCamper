//
// CoinCanteenCVC.swift
// HappyCamper
//
// Created by wegile on 01/03/19.
// Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CanteenImageCVC: UICollectionViewCell {
    @IBOutlet weak var imgVwCanteen: UIImageView!
    @IBOutlet weak var wrapper_vw: UIView!
}

class CoinCanteenCVC: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblCoins: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var tap_btn: UIButton!
    
    var cell_width : CGFloat!
    
    //MARK:--> VARIABLES
    var ImageAry = [String]()
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVw.dequeueReusableCell(withReuseIdentifier: "CanteenImageCVC", for: indexPath) as! CanteenImageCVC
        if ImageAry.count != 0 {
            cell.imgVwCanteen.sd_setImage(with: URL.init(string: "\(Apis.KCoinProduct)\(ImageAry[indexPath.item])"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Devansh
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: cell_width, height: 235.0)
        }else{
            return CGSize(width: collVw.frame.width, height: collVw.frame.height)
        }  
    }
    
    func collVwReload() {
        collVw.reloadData()
    }
}
