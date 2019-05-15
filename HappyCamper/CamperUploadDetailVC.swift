//
//  CamperUploadDetailVC.swift
//  HappyCamper
//
//  Created by wegile on 08/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CamperOfWeekCVC: UICollectionViewCell {
    //MARK:-->CAMPER WEEK
    @IBOutlet weak var lblTitleCampr: UILabel!
    @IBOutlet weak var imgVwCamper: SetCornerImageView!
}

class CounsellorOfWeekCVC: UICollectionViewCell {
    //MARK:--> COUNSELLOR WEEK
    @IBOutlet weak var imgVwCouncellor: SetCornerImageView!
    @IBOutlet weak var lblCouncelorTitle: UILabel!
}

class CamperUploadDetailVC: UIViewController {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var tblCallVW: UITableView!
    @IBOutlet weak var tblTopTenVw: UITableView!
    @IBOutlet weak var videoVw: UIView!
    @IBOutlet weak var btnVwMenu: UIView!
   
    @IBOutlet weak var colVwAdsFeatures: UICollectionView!
    @IBOutlet weak var colVwLiveFeatures: UICollectionView!
    @IBOutlet weak var colVwCounslor: UICollectionView!
    @IBOutlet weak var colVwCamper: UICollectionView!
    //MARK:--> VARIBLES
    let section = ["", "CONTESTS", "LIVE FEATURES", "ADS FOR CAMPFIRE"]
   
    var CamperUploadDetailVMObj = CamperUploadDetailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  tblCallVW.tableFooterView = UIView()
     //   tblTopTenVw.table
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CamperUploadDetailVMObj.CampfireResultVideoModelAry.removeAll()
        
        CamperUploadDetailVMObj.CampfireDetailApi {
            self.tblTopTenVw.reloadData()
            self.tblCallVW.reloadData()
     
           // self.colVwCounslor.reloadData()
            self.colVwCamper.reloadData()
        }
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnSignInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnViewAll(_ sender: Any) {
    }

}
