//
//  CampfireAdCell.swift
//  HappyCamper
//
//  Created by Wegile on 08/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON

class CampfireAdBannerCell: UICollectionViewCell {
    @IBOutlet weak var img_Banner: UIImageView!
    @IBOutlet weak var btn_OpenAd: UIButton!

}

class CampfireAdCell: UITableViewCell {

    @IBOutlet weak var coll_Ad: UICollectionView!
    var arr_Banners:[JSON] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBannerData(ads:[JSON]) {
        if ads.count > 0 {
            self.arr_Banners = ads
            self.coll_Ad.reloadData()
        }
    }
}


//MARK:- UIColleciton View Delegates and Data Sources
extension CampfireAdCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_Banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! CampfireAdBannerCell
        
        cell.img_Banner.sd_setImage(with: URL.init(string: "\(Apis.KAvertisementBannerUrl)\(self.arr_Banners[indexPath.row]["banner"].stringValue)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)

        cell.btn_OpenAd.tag = indexPath.row
        cell.btn_OpenAd.addTarget(self, action: #selector(self.openAds(sender:)), for: .touchUpInside)
        return cell
    }
    
   @objc func openAds(sender:UIButton) {
    let ad_Url = self.arr_Banners[sender.tag]["url"].stringValue
    guard let url = URL(string: ad_Url) else {
        return //be safe
    }
    
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(url)
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: coll_Ad.frame.width, height: coll_Ad.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
