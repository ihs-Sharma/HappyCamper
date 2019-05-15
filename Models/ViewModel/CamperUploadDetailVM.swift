//
//  CamperUploadDetailVM.swift
//  HappyCamper
//
//  Created by wegile on 08/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CamperUploadDetailVM {
    var contest = String()
    var livefeatures = String()
    
    var AdvertisementModelAry       = [AdvertisementModel]()
    var CampfireBannerModelAry      = [CampfireBannerModel]()
    var CamperfireResultModelAry    = [CamperfireResultModel]()
    var CampfirePageModelAry        = [CampfirePageModel]()
    var CampfireResultVideoModelAry = [CampfireResultVideoModel]()
    var ContestModelAry             = [ContestModel]()
    
    //MARK:--> CAMPFIRE DETAILS
    func CampfireDetailApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "page_type" : "be_on_happy_camper_live"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCampFire)", params: param, showIndicator: true, completion: { (JSON) in
            
            var appResponse = Int()
            
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                if let advertisementAry = JSON["advertisements"] as? NSArray {
                    if advertisementAry.count > 0 {
                        for i in 0..<advertisementAry.count {
                            if let advertisementDict = advertisementAry[i] as? NSDictionary {
                                let AdvertisementModelObj = AdvertisementModel()
                                AdvertisementModelObj.dictData(dict: advertisementDict)
                                self.AdvertisementModelAry.append(AdvertisementModelObj)
                            }
                        }
                    }
                }
                
                if let bannerAry = JSON["banners"] as? NSArray {
                    if bannerAry.count > 0 {
                        for i in 0..<bannerAry.count {
                            if let bannerDict = bannerAry[i] as? NSDictionary {
                                let BannerModelObj = CampfireBannerModel()
                                BannerModelObj.dictData(dict:  bannerDict)
                                self.CampfireBannerModelAry.append(BannerModelObj)
                            }
                        }
                    }
                }
                
                if let camperesultAry = JSON["camper_ofday_results"] as? NSArray {
                    if camperesultAry.count > 0 {
                        for i in 0..<camperesultAry.count {
                            if let campfireResultDict = camperesultAry[i] as? NSDictionary {
                                let CamperfireResultModelObj =  CamperfireResultModel()
                                CamperfireResultModelObj.dictData(dict: campfireResultDict)
                                self.CamperfireResultModelAry.append(CamperfireResultModelObj)
                            }
                        }
                    }
                }
                
                if let campfirePageDict = JSON["campfire_page_details"] as? NSDictionary {
                    let CampfirePageModelObj = CampfirePageModel()
                    CampfirePageModelObj.dictData(dict: campfirePageDict)
                    self.CampfirePageModelAry.append(CampfirePageModelObj)
                }
                
                if let campfireResultAry = JSON["campfires_video_results"] as? NSArray {
                    if campfireResultAry.count > 0 {
                        for i in 0..<campfireResultAry.count {
                            if let campfireResultDict = campfireResultAry[i] as? NSDictionary {
                                let CampfireResultVideoModelObj = CampfireResultVideoModel()
                                CampfireResultVideoModelObj.dictData(dict: campfireResultDict)
                                self.CampfireResultVideoModelAry.append(CampfireResultVideoModelObj)
                            }
                        }
                    }
                }
                
                if let contestCampfireAry = JSON[""] as? NSArray {
                    if contestCampfireAry.count > 0 {
                         for i in 0..<contestCampfireAry.count {
                             if let contestCampfireDict = contestCampfireAry[i] as? NSDictionary {
                                let ContestModelObj = ContestModel()
                                ContestModelObj.dictData(dict: contestCampfireDict)
                                self.ContestModelAry.append(ContestModelObj)
                            }
                        }
                    }
                }
                completion()
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
}


extension CamperUploadDetailVC: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //MARK:--> COLLECTION VIEW DELEGATE FUNCTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colVwCamper {
            return CamperUploadDetailVMObj.CamperfireResultModelAry.count
        } else if collectionView == colVwAdsFeatures {
            return CamperUploadDetailVMObj.AdvertisementModelAry.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var MainCell = UICollectionViewCell()
        if collectionView == colVwCamper {
            if CamperUploadDetailVMObj.CamperfireResultModelAry.count != 0 {
                
                let CamperfireResultModelAryObj  = CamperUploadDetailVMObj.CamperfireResultModelAry[indexPath.row]
                
                //if collectionView == colVwCamper {
                
                // if CamperfireResultModelAryObj.type == "camper" {
                let cell = colVwCamper.dequeueReusableCell(withReuseIdentifier: "CamperOfWeekCVC", for: indexPath) as! CamperOfWeekCVC
                cell.lblTitleCampr.text = CamperfireResultModelAryObj.name
                cell.imgVwCamper.sd_setImage(with: URL.init(string: "\(Apis.KCampfireDaycamper)\(CamperfireResultModelAryObj.image)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
               
                MainCell = cell
                //} else {
                //} else {
                //if CamperfireResultModelAryObj.type == "counselor" {
                //let cell = colVwCounslor.dequeueReusableCell(withReuseIdentifier: "CounsellorOfWeekCVC", for: indexPath) as! CounsellorOfWeekCVC
                //cell.lblCouncelorTitle.text = CamperfireResultModelAryObj.name
                //cell.imgVwCouncellor.sd_setImage(with: URL.init(string: "\(Apis.KCampfireVideoThum)\(CamperfireResultModelAryObj.image)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                //MainCell = cell
                //}
                //}
            }
            
        }
        return MainCell
    }
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblCallVW {
            return CamperUploadDetailVMObj.CampfireResultVideoModelAry.count
        }
//       else if tableView == tblTopTenVw {
//            if section == 0 {
//                return CamperUploadDetailVMObj.ContestModelAry.count
//            } else if section == 1 {
//                return CamperUploadDetailVMObj.ContestModelAry.count
//            } else if section == 2 {
//                return CamperUploadDetailVMObj.AdvertisementModelAry.count
//            }
//        }
        else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var mainCell = UITableViewCell()
        
        if tableView == tblCallVW {
            if  CamperUploadDetailVMObj.CampfireResultVideoModelAry.count != 0 {
                let CampfireResultVideoModelAryObj = CamperUploadDetailVMObj.CampfireResultVideoModelAry[indexPath.row]
                
                let cell = tblCallVW.dequeueReusableCell(withIdentifier: "CamperUploadDetailTVC", for: indexPath) as! CamperUploadDetailTVC
                
                if CampfireResultVideoModelAryObj.UserViewAry.count != 0 {
                    cell.btnTotalVw.setTitle("\(CampfireResultVideoModelAryObj.UserViewAry[indexPath.row])", for: .normal)
                }
                
                cell.lblDescription.text = CampfireResultVideoModelAryObj.videoDesc.htmlToString
                cell.lblTitle.text = CampfireResultVideoModelAryObj.videoTitle
                
                cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KCampfireVideoThum)\(CampfireResultVideoModelAryObj.VideoThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                
                mainCell = cell
            }
        } //else if tableView == CamperContestTVC { }
            
        else {
            let cell = tblTopTenVw.dequeueReusableCell(withIdentifier: "CamperUploadDetailTVC", for: indexPath) as! CamperUploadDetailTVC
            //cell.btnSelect.setTitle("\(buttonTitle[indexPath.row])", for: .normal)
            mainCell = cell
        }
        return mainCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblTopTenVw {
            return 120
        } else {
            return 300
        }
    }

}













//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var mainCell = UICollectionViewCell()
//
//        if CamperUploadDetailVMObj.CamperfireResultModelAry.count != 0 {
//
//            let CamperfireResultModelAryObj = CamperUploadDetailVMObj.CamperfireResultModelAry[indexPath.item]
//
//            if collectionView == colVwCamper {
//                if CamperfireResultModelAryObj.type == "camper" {
//                    //let cell = colVwCounslor.dequeueReusableCell(withReuseIdentifier: "CamperOfWeekCVC", for: indexPath) as! CamperOfWeekCVC
//                    let cell = colVwCounslor.dequeueReusableCell(withReuseIdentifier: "CamperOfWeekCVC", for: indexPath) as! CamperOfWeekCVC
//
//                    cell.imgVwCamper.sd_setImage(with: URL.init(string: "\(Apis.KCampfireVideoThum)\(CamperfireResultModelAryObj.image)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
//                    cell.lblTitleCampr.text = CamperfireResultModelAryObj.name
//                    mainCell = cell
//                }
//            } else {
//                if CamperfireResultModelAryObj.type == "counselor" {
//                    let cell = colVwCounslor.dequeueReusableCell(withReuseIdentifier: "CounsellorOfWeekCVC", for: indexPath) as! CounsellorOfWeekCVC
//
//                    cell.imgVwCounsellor.sd_setImage(with: URL.init(string: "\(Apis.KCampfireVideoThum)\(CamperfireResultModelAryObj.image)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
//                    cell.lblTitleCounselor.text = CamperfireResultModelAryObj.name
//                    mainCell = cell
//                }
//            }
//        }
//        return mainCell
//    }
