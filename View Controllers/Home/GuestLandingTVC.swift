//
//  GuestLandingTVC.swift
//  HappyCamper
//
//  Created by wegile on 24/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

protocol didselectAdvertisementDelegte{
    func didselectAdvertisement(adUrl:String)
    func didOpenVideo(status:Bool)
    
}

class GuestLandingTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var colVwAds: UICollectionView!
    @IBOutlet weak var VwAds: UIView!
    @IBOutlet weak var VwBanners: UIView!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnLeftAction: UIButton!
    @IBOutlet weak var btnRightAction: UIButton!
    
    //MARK:--> VARIABLES
    var hbvideoArray = NSMutableArray()
    var GuestLandingModelAry = [GuestLandingModel]()
    var currentCont = UIViewController()
    var GuestLandingVMObj = GuestLandingVM()
    var AdvertisementAry = [NSDictionary]()
    var collectionType = String()
    
    var delegate : didselectAdvertisementDelegte?
    
    
    var rowSize = CGFloat()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colVw.delegate = self
        colVw.dataSource = self
        
        //Devansh
        if UIDevice.current.userInterfaceIdiom != .pad {
            collectionSetViewLayout()
        }
    }
    
    func collectionSetViewLayout() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/1.5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .horizontal
        self.colVwAds!.collectionViewLayout = layout
        
        let layoutcolVw: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutcolVw.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layoutcolVw.itemSize = CGSize(width: self.colVw.frame.width/2.5, height: self.colVw.frame.height+50)
        layoutcolVw.minimumInteritemSpacing = 5
        layoutcolVw.minimumLineSpacing = 2
        layoutcolVw.scrollDirection = .horizontal
        self.colVw.collectionViewLayout  = layoutcolVw
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionType == "Videos" {
            return GuestLandingModelAry.count
        } else {
            return AdvertisementAry.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var mainCell = UICollectionViewCell()
        
        if collectionType == "Videos" {
            
            let cell = colVw.dequeueReusableCell(withReuseIdentifier: "GuestLandingCVC", for: indexPath) as! GuestLandingCVC
            
            if indexPath.item >= GuestLandingModelAry.count {
                return cell
            }
            
            let GuestLandingModelAryObj = GuestLandingModelAry[indexPath.item]
            
            if GuestLandingModelAry.count != 0 {
                
                DispatchQueue.main.async {
                    if GuestLandingModelAryObj.type != "video" {
                        cell.imgVwAdv.isHidden = false
                        
                        cell.imgVwAdv.sd_setImage(with: URL.init(string: "\(Apis.KAvertisementBannerUrl)\(GuestLandingModelAryObj.videoImageThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                        cell.imgVwAdv.image = UIImage.init(cgImage: cell.imgVwAdv.image?.cgImage ?? "" as! CGImage, scale: cell.imgVwAdv.image?.size.width ?? 0.0 / cell.imgVwAdv.frame.size.width, orientation: UIImage.Orientation.up)
                        
                    } else {
                        cell.imgVwAdv.isHidden = true
                        DispatchQueue.main.async {
                            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(GuestLandingModelAryObj.videoImageThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                        }
                        
                        cell.lblLive.isHidden = true
                        cell.lblDate.isHidden = true
                        
                        if GuestLandingModelAryObj.shortTitle != "" {
                            cell.lblContent.text = GuestLandingModelAryObj.shortTitle
                        } else {
                            cell.lblContent.text = GuestLandingModelAryObj.videoTitle
                        }
                        
                        if GuestLandingModelAryObj.shortDiscription != "" {
                            let string = GuestLandingModelAryObj.shortDiscription
                            cell.lblContentDescription.text = string.htmlToString
                        } else {
                            let string = GuestLandingModelAryObj.videoDiscription
                            cell.lblContentDescription.text = string.htmlToString
                        }
                    }
                }
            }
            
            mainCell = cell
            
        } else {
            let cell = colVwAds.dequeueReusableCell(withReuseIdentifier: "GuestLandingPageAdCell", for: indexPath) as! GuestLandingPageAdCell
            
            if indexPath.item >= AdvertisementAry.count {
                return cell
            }
            
            let advertisement = AdvertisementAry[indexPath.item]
            let banner = advertisement.value(forKey: "banner") as! String
            let imgUrl = banner
            let imgFullString = "\(Apis.KAvertisementBannerUrl)\(imgUrl)"
            let urlStr: URL = URL(string: imgFullString)!
            DispatchQueue.main.async {
                cell.imgVw.sd_setImage(with: urlStr, placeholderImage: nil, options: .refreshCached)
                if UIDevice.current.userInterfaceIdiom != .pad {
                    cell.imgVw.contentMode = .scaleAspectFit
                }
            }
            
            //varinder17
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                let isIpadPro:Bool = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) > 1024
                if isIpadPro == false {
                    cell.imgVw.contentMode = .scaleAspectFit
                }
            }
            
            cell.left_btn.layer.cornerRadius = 18.0
            cell.left_btn.layer.masksToBounds = true
            
            cell.right_btn.layer.cornerRadius = 18.0
            cell.right_btn.layer.masksToBounds = true
            
            cell.tap_btn.tag = indexPath.item
            cell.tap_btn.addTarget(self, action: #selector(GuestLandingTVC.tapOnAd(_:)), for: .touchUpInside)
            
            return cell
        }
        
        return mainCell
    }
    
    func setProfileImage(imageToResize: UIImage, onImageView: UIImageView) -> UIImage {
        
        let width = imageToResize.size.width
        let height = imageToResize.size.height
        
        var scaleFactor: CGFloat
        
        if(width > height) {
            scaleFactor = onImageView.frame.size.height / height;
        } else {
            scaleFactor = onImageView.frame.size.width / width;
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        imageToResize.draw(in: CGRect.init(x:0, y:0, width:width * scaleFactor,height: height * scaleFactor))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionType == "Videos" {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: 226.0, height: 191.0)
            } else {
                return CGSize(width: 185.0, height: 150.0)
            }
        } else {
            
            if rowSize == 0.0 {
                rowSize = 250.0
            }
            if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: self.colVwAds.frame.size.width-10.0, height: rowSize)
            } else {
                return CGSize(width: self.colVwAds.frame.size.width-0.0, height: rowSize)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let GuestLandingModelAryObj = GuestLandingModelAry[indexPath.item]
        if GuestLandingModelAryObj.type != "video" {
            let  url = GuestLandingModelAryObj.headerCategoryUrl
            delegate?.didselectAdvertisement(adUrl: url)
            return
        }
        
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: currentCont)
            return
        }
        
        if collectionView == colVw {
            if GuestLandingModelAryObj.type != "video" {
                let  url = GuestLandingModelAryObj.headerCategoryUrl
                delegate?.didselectAdvertisement(adUrl: url)
            } else {
                
                Proxy.shared.pushToNextSubCatVC(identifier: "SubCategoryDetailVC", isAnimate: true, currentViewController: currentCont, VideoId: GuestLandingModelAryObj.videoId,headerName:GuestLandingModelAryObj.headerCategoryUrl , currentContName: "", activityType: GuestLandingModelAryObj.headerCategoryUrl, categorySubValue: "1", fromController: "")
                delegate?.didOpenVideo(status: true)
            }
            
        }
    }
    
    //MARK:--> COLLECTION VIEW RELOAD
    func colVwReload() {
        colVw.reloadData()
    }
    
    func colVwAdsReload() {
        colVwAds.reloadData()
        colVwAds.layoutIfNeeded()
    }
    
    
    @objc func tapOnAd(_ sender:UIButton)
    {
        let tag = sender.tag
        let advertisement = AdvertisementAry[tag]
        let url = advertisement.value(forKey: "url") as! String
        delegate?.didselectAdvertisement(adUrl: url)
    }
}
