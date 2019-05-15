//
//  CounselorsCell.swift
//  HappyCamper
//
//  Created by Wegile on 23/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SelectCounselorsDelegate {
    func selectCounselor(index:Int,isFrom:Bool,user_Name:String)
}

class CampfireCounselorCell: UICollectionViewCell {
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    
    override func layoutSubviews() {
        img_User.layer.cornerRadius = img_User.frame.width/2
        img_User.clipsToBounds=true
        img_User.layer.borderWidth = 2
        img_User.layer.borderColor = UIColor.purple.cgColor
    }
}

class CounselorsCell: UITableViewCell {
    
    @IBOutlet weak var coll_Counselor: UICollectionView!
    var arr_Counselors:[JSON] = []
    var delegate_SelectCounselor : SelectCounselorsDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        coll_Counselor.delegate=self
        coll_Counselor.dataSource=self
    }
    
    func reloadCollectionData(json:[JSON]) {
        if json.count > 0 {
            arr_Counselors = json
            DispatchQueue.main.async {
                self.coll_Counselor.reloadData()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK:- UIColleciton View Delegates and Data Sources
extension CounselorsCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_Counselors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CampfireCounselorCell
        cell.lbl_Name.text = arr_Counselors[indexPath.row]["name"].stringValue
        cell.img_User.sd_setImage(with: URL.init(string: "\(Apis.KCampfireDaycamper)\(arr_Counselors[indexPath.row]["image"].stringValue)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if arr_Counselors[indexPath.row]["type"] == "counselor" {
            self.delegate_SelectCounselor?.selectCounselor(index: indexPath.row, isFrom: true, user_Name: arr_Counselors[indexPath.row]["name"].stringValue)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: coll_Counselor.frame.width/2, height: coll_Counselor.frame.height)
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
