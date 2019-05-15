//
//  SubCategoryVideosTVC.swift
//  HappyCamper
//
//  Created by wegile on 29/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

protocol SelectedViewAllVideo {
    func didSelectedVideo(selectedVideoId: String,activityType:String,catSubValue:String);
}

var SelectedViewAllVideoObj : SelectedViewAllVideo?

class SubCategoryVideosCVC: UICollectionViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var view_Content: UIView!
    
    override func awakeFromNib() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.dropShadow(color: UIColor.gray, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
//            view_Content.dropShadow(color: UIColor.black, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        } else {
            view_Content.dropShadow(color: UIColor.black, opacity: 0.1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
        }
    }
}

class SubCategoryVideosTVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var btnLeftAction: UIButton!
    @IBOutlet weak var btnRightAction: UIButton!
    
    
    //MARK:-->VARIABLES
    var VideoModelAry = [VideoModel]()
    var CategoryId  = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colVw.delegate = self
        colVw.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:--> DELEGATE VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VideoModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let VideoModelAryObj = VideoModelAry[indexPath.item]
        let cell =  colVw.dequeueReusableCell(withReuseIdentifier: "SubCategoryVideosCVC", for: indexPath) as! SubCategoryVideosCVC
        
        DispatchQueue.main.async {
            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(VideoModelAryObj.videoImgThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        
        cell.view_Content.layer.cornerRadius = 1.0
        cell.view_Content.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        cell.view_Content.layer.borderWidth = 1.0
        cell.view_Content.layer.masksToBounds = true
        
        if VideoModelAryObj.shortTitle != "" {
            cell.lblTitle.text = VideoModelAryObj.shortTitle
        } else {
            cell.lblTitle.text = VideoModelAryObj.videoTitle
        }
        
        if VideoModelAryObj.shortDiscription != "" {
            let string = VideoModelAryObj.shortDiscription
            cell.lblDetail.text = string.htmlToString
        } else {
            let string = VideoModelAryObj.videoDesc
            cell.lblDetail.text = string.htmlToString
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let VideoModelAryObj = VideoModelAry[indexPath.item]
        SelectedViewAllVideoObj?.didSelectedVideo(selectedVideoId: VideoModelAryObj.videoId, activityType: VideoModelAryObj.CatagoryURL, catSubValue: "1")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 226.0, height: 191.0)
        } else {
            return CGSize(width: 175.0, height: 140.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
