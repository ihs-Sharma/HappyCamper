//
//  EpisodesDetailsTVC.swift
//  HappyCamper
//
//  Created by wegile on 24/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
protocol SelectedWebVideo {
    func didSelected(selectedVideoId: String);
    func didPauseVideoForSeries(status:Bool)
}

var SelectedWebVideoObj : SelectedWebVideo?

class EpisodesDetailsTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var colVwEpisods: UICollectionView!
    
    @IBOutlet weak var colVwAds: UICollectionView!
    
    @IBOutlet weak var edpisode_Vw: UIView!
    @IBOutlet weak var ad_Vw: UIView!
    
    //MARK:--> VARIBALES
    var currentVc = UIViewController()
    var WebSeriesVMObj = WebSeriesVM()
    var VideoModelAry  = [VideoModel]()
    var adsModelAry  = [advertisementModel]()
    
    var type = String()
    var delegate : didselectAdvertisementDelegte?
    override func awakeFromNib() {
        super.awakeFromNib()
        colVwEpisods.delegate = self
        colVwEpisods.dataSource = self
        
        colVwAds.delegate = self
        colVwAds.dataSource = self
        //        colVwEpisods.reloadData()
        
        //Devansh
        if UIDevice.current.userInterfaceIdiom == .phone {
//            collectionSetViewLayout()
            
        }

    }
    
    func collectionSetViewLayout() {
        
        
        let layoutcolVw: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutcolVw.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //        layoutcolVw.itemSize = CGSize(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/2.5)
        layoutcolVw.minimumInteritemSpacing = 6
        layoutcolVw.minimumLineSpacing = 3
        layoutcolVw.scrollDirection = .horizontal
        self.colVwEpisods.collectionViewLayout  = layoutcolVw
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == colVwAds
        {
            return adsModelAry.count
        }
        else
        {
            return VideoModelAry.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colVwAds
        {
            
            let cell = colVwAds.dequeueReusableCell(withReuseIdentifier: "adcell", for: indexPath) as! GuestLandingPageAdCell
            
            if indexPath.item >= adsModelAry.count
            {
                return cell
            }
            
            let advertisement = adsModelAry[indexPath.item]
            
            let banner = advertisement.imgUrl
            
            let imgUrl = banner
            DispatchQueue.main.async {

            let imgFullString = "\(Apis.KAvertisementBannerUrl)\(imgUrl)"
            let urlStr: URL = URL(string: imgFullString)!
            
            cell.imgVw.sd_setImage(with: urlStr, placeholderImage: nil, options: .refreshCached)
            }
            cell.tap_btn.tag = indexPath.item
            
            cell.tap_btn.addTarget(self, action: #selector(EpisodesDetailsTVC.didTapOnAd(_:)), for: .touchUpInside)
            
            return cell
        }
        else
        {
            let cell = colVwEpisods.dequeueReusableCell(withReuseIdentifier: "CellMenu", for: indexPath) as! EpisodesDetailsCVC
            if VideoModelAry.count != 0 {
                let VideoModelAryObj = VideoModelAry[indexPath.row]
                //            cell.lblTitle.text = VideoModelAryObj.videoTitle
                DispatchQueue.main.async {
                  cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(VideoModelAryObj.videoImgThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                }
                
                if VideoModelAryObj.shortTitle != "" {
                    cell.lblTitle.text = VideoModelAryObj.shortTitle
                } else {
                    cell.lblTitle.text = VideoModelAryObj.videoTitle
                }
                
                if VideoModelAryObj.shortDiscription != "" {
                    let string = VideoModelAryObj.shortDiscription
                    cell.lblContentDescription.text = string.htmlToString
                } else {
                    let string = VideoModelAryObj.videoDesc
                    cell.lblContentDescription.text = string.htmlToString
                }
            }
            return cell
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == colVwEpisods {
            //Devansh
            if UIDevice.current.userInterfaceIdiom == .phone {
                return CGSize(width: 185.0, height: 150.0)
            }else{
                return CGSize(width: 226.0, height: 191.0)
            }
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: self.colVwAds.frame.size.width-10.0, height: 400.0)
            } else {
                return CGSize(width: self.colVwAds.frame.size.width-0.0, height: 250.0)
            }
        }
    }
    
    @objc func didTapOnAd(_ sender: UIButton) {
        let tag = sender.tag
        let advertisement = adsModelAry[tag]
        delegate?.didselectAdvertisement(adUrl: advertisement.img_link_url)
    }
    
    //MARK:--> COLLECTION VIEW RELOAD
    func colVwReload() {
        colVwEpisods.reloadData()
    }
    
    func colVwAdReload() {
        colVwAds.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VideoModelAryObj = VideoModelAry[indexPath.row]
        SelectedWebVideoObj?.didSelected(selectedVideoId: VideoModelAryObj.videoId)
        SelectedWebVideoObj?.didPauseVideoForSeries(status: true)
    }
}


