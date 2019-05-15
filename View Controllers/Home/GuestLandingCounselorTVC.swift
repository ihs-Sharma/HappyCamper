//
//  GuestLandingCounselorTVC.swift
//  HappyCamper
//
//  Created by Wegile on 23/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

protocol didSelectUserCastScreen{
    func selectUserCast(object:CastDictModel,users_array:[CastDictModel],selected_index:Int)
}

class GuestLandingCounselorTVC: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK:--> IBOUTLETS
    var delegate_Counselor : didSelectUserCastScreen?

    @IBOutlet weak var coll_Counselors: UICollectionView!
    @IBOutlet weak var VwBanners: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnLeftAction: UIButton!
    @IBOutlet weak var btnRightAction: UIButton!
    var currentCont = UIViewController()
    var arr_Counselors = [NSDictionary]()
    var CastDictModelAry = [CastDictModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        coll_Counselors.delegate = self
        coll_Counselors.dataSource = self
    }
    
    func colVwReload() {
        coll_Counselors.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_Counselors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = coll_Counselors.dequeueReusableCell(withReuseIdentifier: "GuestLandingCounselorCVC", for: indexPath) as! GuestLandingCounselorCVC
        
        let img_Str = arr_Counselors[indexPath.row]["image"] as! String
        DispatchQueue.main.async {
            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\(img_Str)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        cell.lblContent.text = (arr_Counselors[indexPath.row]["name"] as! String)
        cell.lblContentDescription.text = arr_Counselors[indexPath.row]["counselor"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
        return CGSize(width: 226.0, height: 191.0)
        } else {
            return CGSize(width: 180.0, height: 145.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  arr_Counselors.count  != 0 {
            for i in 0..<arr_Counselors.count {
                
                if let dict_Coun = arr_Counselors[i] as? NSDictionary {
                    let CastDictModelObj = CastDictModel()
                    CastDictModelObj.getCastDict(dict: dict_Coun)
                    self.CastDictModelAry.append(CastDictModelObj)
                }
            }
            let CastDictModelObj = self.CastDictModelAry[indexPath.row]
            self.delegate_Counselor?.selectUserCast(object: CastDictModelObj, users_array: self.CastDictModelAry,selected_index:indexPath.row)
        }
    }
    
}
