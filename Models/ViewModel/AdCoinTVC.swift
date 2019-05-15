//
// AdCoinTVC.swift
// HappyCamper
//
// Created by wegile on 02/04/19.
// Copyright © 2019 wegile. All rights reserved.
//

import UIKit
protocol didselectCoin {
    func didselectCoin(data : coinModel)
}


class AdCoinTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // var CoinCanteenVMObj = CoinCanteenVM()
    
    @IBOutlet weak var collVwCoin: UICollectionView!
    @IBOutlet weak var collViewAd: UICollectionView!
    
    var adArr = [adModel]()
    var coinArr = [coinModel]()
    var CanteenModelAry = [CanteenModel]()
    var delegate : didselectAdvertisementDelegte?
    var delegateCoin : didselectCoin?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // collViewAd.delegate = self
        // collViewAd.dataSource = self
        //
        // collVwCoin.delegate = self
        // collVwCoin.dataSource = self
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collViewAd
        {
            return adArr.count
        }
        else
        {
            return coinArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collViewAd {
            
            let cell = collViewAd.dequeueReusableCell(withReuseIdentifier: "GuestLandingPageAdCell", for: indexPath) as! GuestLandingPageAdCell
            
            if adArr.count != 0{
                
                let advertisement = adArr[indexPath.item]
                let banner = advertisement.banner
                
                let imgUrl = banner
                let imgFullString = "\(Apis.KAvertisementBannerUrl)\(imgUrl)"
                let urlStr: URL = URL(string: imgFullString)!
                
                cell.imgVw.sd_setImage(with: urlStr, placeholderImage: nil, options: .refreshCached)
                
                cell.left_btn.layer.cornerRadius = 18.0
                cell.left_btn.layer.masksToBounds = true
                
                cell.right_btn.layer.cornerRadius = 18.0
                cell.right_btn.layer.masksToBounds = true
                
                cell.tap_btn.tag = indexPath.item
                cell.tap_btn.addTarget(self, action: #selector(AdCoinTVC.tapOnAd(_:)), for: .touchUpInside)
                
            }
            return cell
            
        } else {
            let cell = collVwCoin.dequeueReusableCell(withReuseIdentifier: "CoinCanteenCVC", for: indexPath) as! CoinCanteenCVC
            if coinArr.count != 0 {
                let CanteenModelAryObj = coinArr[indexPath.item]
                cell.lblCoins.text! = "\(CanteenModelAryObj.coins)"
                cell.lblTitle.text! = CanteenModelAryObj.title.htmlToString
                cell.lblDescriptions.text! = CanteenModelAryObj.description.htmlToString
                
                
                cell.collVw.layer.cornerRadius = 4.0
                cell.collVw.layer.borderColor = UIColor.lightGray.cgColor
                //Devansh
                if UIDevice.current.userInterfaceIdiom == .phone{
                    cell.collVw.layer.borderWidth = 0.0
                }else{
                    cell.collVw.layer.borderWidth = 1.0
                }
                cell.collVw.layer.masksToBounds = true
                
                cell.btnBuyNow.tag = indexPath.row
                cell.btnBuyNow.addTarget(self, action: #selector(AdCoinTVC.didTapOnCoin), for: .touchUpInside)
                cell.tap_btn.tag = indexPath.item
                cell.tap_btn.addTarget(self, action: #selector(AdCoinTVC.didTapOnCoin), for: .touchUpInside)
                
                
                let width = collVwCoin.frame.size.width / 3
                cell.cell_width = width - 20
                cell.ImageAry = CanteenModelAryObj.imgArr
            }
            cell.collVwReload()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Devansh
        if UIDevice.current.userInterfaceIdiom == .pad{
            if collectionView == collViewAd {
                return CGSize(width: self.collViewAd.frame.size.width-10.0, height: 400)
            } else {
                let width = collVwCoin.frame.size.width / 3
                return CGSize(width: width - 10, height: 405)
            }
        }else{
            if collectionView == collViewAd {
                return CGSize(width: self.collViewAd.frame.size.width, height: self.collViewAd.frame.size.height/2)
            } else {
                let width = collVwCoin.frame.size.width / 2
                return CGSize(width: width, height: UIScreen.main.bounds.height/2)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwCoin {
            let CanteenModelAryObj = coinArr[indexPath.item]
            delegateCoin?.didselectCoin(data: CanteenModelAryObj)
        }
    }
    
    @objc func didTapOnCoin(_ sender : UIButton) {
        
        let CanteenModelAryObj = coinArr[sender.tag]
        delegateCoin?.didselectCoin(data: CanteenModelAryObj)
    }
    
    func colVwAdsReload() {
        collViewAd.reloadData()
    }
    
    func colVwCoinReload() {
        collVwCoin.reloadData()
    }
    
    @objc func tapOnAd(_ sender: UIButton) {
        let tag = sender.tag
        let url = adArr[tag].url
        self.delegate?.didselectAdvertisement(adUrl: url)
    }
    
    //MARK:--> BUTTTON PURCHASE NOW
    @objc func buttonPurchaseNow(sender: UIButton) {
        // var CanteenModelAry = [CanteenModel]()
        let CanteenModelAryObj = CanteenModelAry[sender.tag]
        
        let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
        nav.ImagAry = CanteenModelAryObj.imageArr as! NSArray
        nav.CanteenModelAry = [CanteenModelAry[sender.tag]]
        //        self.navigationController?.pushViewController(nav, animated: true)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
