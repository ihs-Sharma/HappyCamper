//
//  SubCategoryDetailTVC.swift
//  HappyCamper
//
//  Created by wegile on 30/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

protocol SelectedVideo {
    func didSelected(selectedVideoId: String,videoUrl:String);
}

var SelectedVideoObj : SelectedVideo?

class SubCategoryDetailTVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var btnLeftAction: UIButton!
    @IBOutlet weak var btnRightAction: UIButton!
    
    //MARK:--> VARIABLE
    var VideoModelAry = [VideoModel]()
    var GuestLandingModelAry = [GuestLandingModel]()
   // var SubCategoryDetailVMObj = SubCategoryDetailVC()
  
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
        return VideoModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let GuestLandingModelAryObj = GuestLandingModelAry[indexPath.row]
        let VideoModelAryObj = VideoModelAry[indexPath.item]

        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "SubCategoryDetailCVC", for: indexPath) as! SubCategoryDetailCVC
       
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
            cell.lblDescription.text = string.htmlToString
        } else {
            let string = VideoModelAryObj.videoDesc
            cell.lblDescription.text = string.htmlToString
        }
        
        DispatchQueue.main.async {
            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(VideoModelAryObj.videoImgThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         let GuestLandingModelAryObj = GuestLandingModelAry[indexPath.row]
        let VideoModelAryObj = VideoModelAry[indexPath.item]

        SelectedVideoObj?.didSelected(selectedVideoId: VideoModelAryObj.videoId, videoUrl: VideoModelAryObj.videoUrl)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 226.0, height: 191.0)
        }else{
            return CGSize(width: 185.0, height: 170.0)
//            return CGSize(width: UIScreen.main.bounds.width/1.8, height: UIScreen.main.bounds.height/2)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return 10
        }else{
            return 0
        }
    }
}

