//
//  CampDetailVM.swift
//  HappyCamper
//
//  Created by wegile on 14/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CampDetailVM {
    
    var campId = String()
    var CampModelAry = [CampModel]()
    var campLike = Bool()
    var dataArray = NSArray()
    var sortedArray = NSMutableArray()
    
    //MARK:--> GET HOME SCREEN API
    func postCampDetailApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "camp_id"   :   "\(campId)",
            //"camp_id"   :   "5c6a7af0018ded89c6458b1b",
            "udid"      :   "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCampDetail)", params: param, showIndicator: true, completion: { (JSON) in
            
            self.campLike = JSON["camp_isliked"] as? Bool ?? false
            
            self.dataArray = ["directors", "year_founded", "age", "gender", "religious_affiliation","accreditations","camp_capacity","camp_types","winter_address","nearest_city","postal_code","street_address","camp_activity"]
            
            if let resultDict = JSON["results"] as? NSDictionary {
                let CampModelObj = CampModel()
                CampModelObj.dictData(dict: resultDict)
                self.CampModelAry.append(CampModelObj)
                
                for i in 0..<self.dataArray.count {
                    
                    // != nil
                    
                    if resultDict.value(forKey: self.dataArray.object(at: i) as! String) != nil {
                        
                        let str =  resultDict.value(forKey: self.dataArray.object(at: i) as! String) as! String
                        
                        if !str.isEmpty {
                            var titleStr = ""
                            if i == 0 {
                                titleStr = "Directors:"
                            }
                            if i == 1 {
                                titleStr = "Year Founded:"
                            }
                            if i == 2 {
                                titleStr = "Ages:"
                            }
                            if i == 3 {
                                titleStr = "Gender:"
                            }
                            if i == 4 {
                                titleStr = "Religious Affilliation:"
                            }
                            if i == 5 {
                                titleStr = "Accreditations:"
                            }
                            if i == 6 {
                                titleStr = "Camp Capacity:"
                            }
                            if i == 7 {
                                titleStr = "Camp Types:"
                            }
                            if i == 8 {
                                titleStr = "Winter Address:"
                            }
                            if i == 9 {
                                titleStr = "Nearest City:"
                            }
                            if i == 10 {
                                titleStr = "Postal Code:"
                            }
                            if i == 11 {
                                titleStr = "Street Address:"
                            }
                            if i == 12 {
                                titleStr = "Camp Activity:"
                            }
                            
                            let dict : NSDictionary = ["title": titleStr, "detail": str as Any]
                            
                            self.sortedArray.add(dict)
                            
                        }
                    }
                }

                print(self.sortedArray)
                
            }
            completion()
            Proxy.shared.hideActivityIndicator()
        })
        
    }
    
    func likeButtonAction(_ completion:@escaping() -> Void) {
        let param = [
            "camp_id"   :   "\(campId)",
            "udid"      :   "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KAddFavCamp)", params: param, showIndicator: true, completion: { (JSON) in
            
            var appResponse = Int()
            
            self.campLike = JSON["camp_isliked"] as? Bool ?? false
            
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                if let resultAry = JSON["results"] as? NSArray {
                    
                    if resultAry.count > 0 {
                        for i in 0..<resultAry.count {
                            if let resultDict = resultAry[i] as? NSDictionary {
                                
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

extension CampDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {
    
    func updateConstraints() {
        
        if CampDetailVMObj.sortedArray.count < 5 {
            self.info_BottomConstraint.priority = UILayoutPriority(250)
            self.coll_BottomConstraint.constant=10
        } else {
            self.coll_BottomConstraint.priority = UILayoutPriority(250)
        }
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CampDetailVMObj.CampModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "CampDetailCVC", for: indexPath) as! CampDetailCVC
        
        if CampDetailVMObj.CampModelAry.count != 0 {
            let CampModelAryObj = CampDetailVMObj.CampModelAry[indexPath.row]
            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KCampTestUrl)\(CampModelAryObj.arr_campBannerLink[indexPath.row].stringValue)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // return CGSize(width: 300, height: 168)
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        Proxy.shared.pushToNextVC(identifier: "CamperStaffVC", isAnimate: true, currentViewController: self)
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CampDetailVMObj.sortedArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblviewMain.dequeueReusableCell(withIdentifier: "CampDetailTableVC") as! CampDetailTableVC
        
        cell.LblTitle?.text = (CampDetailVMObj.sortedArray[indexPath.row]as! Dictionary)["title"]
        cell.LblDetail?.text = (CampDetailVMObj.sortedArray[indexPath.row]as! Dictionary)["detail"]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}
