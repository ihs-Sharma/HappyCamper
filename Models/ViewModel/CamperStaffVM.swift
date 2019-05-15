//
//  CamperStaffVM.swift
//  HappyCamper
//
//  Created by wegile on 17/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CamperStaffVM: NSObject {
    var CampStaffModelAry = [CampStaffModel]()
    var CastDictModelAry  = [CastDictModel]()
    
    //MARK:--> GET CAMPER STAFF API
    func postCamperStaffApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "page_type" : "best_camp_staff"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCampStaff)", params: param, showIndicator: true, completion: { (JSON) in
            
            var appResponse = String()
            
            appResponse = JSON["message"] as? String ?? ""
            
            if appResponse == "success" {
                if let dictResDict = JSON["results"] as? NSDictionary {
                    let CampStaffModelObj = CampStaffModel()
                    CampStaffModelObj.dictData(dict: dictResDict)
                    self.CampStaffModelAry.append(CampStaffModelObj)
                }
            }
            
            completion()
        })
    }
    
    //MARK:--> Camp USER API
    func postCampUserApi(_ completion:@escaping() -> Void) {
        let param = [
            "page_no" : 1,
            "page_size" : 1000,
            "user_type" : "counsler"
            ] as [String:AnyObject]
        
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCampUserDetails)", params: param, showIndicator: true, completion: { (JSON) in
            
            var appResponse = Int()
            
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                if let resultAry = JSON["results"] as? NSArray {
                    if resultAry.count > 0 {
                        for i in 0..<resultAry.count {
                            if let resultDict = resultAry[i] as? NSDictionary {
                                let CastDictModelObjAry = CastDictModel()
                                CastDictModelObjAry.getCastDict(dict: resultDict)
                                self.CastDictModelAry.append(CastDictModelObjAry)
                            }
                        }
                    }
                }
                completion()
            }
        })
    }
}

//extension CamperStaffVC:  UITableViewDelegate, UITableViewDataSource {
//MARK:--> TABLE VIEW DELEGATE
//func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return camperStaffVMObj.CampStaffModelAry.count
//}

//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tblVw.dequeueReusableCell(withIdentifier: "CampStaffTVC", for: indexPath) as! CampStaffTVC
//        if  camperStaffVMObj.CampStaffModelAry.count != 0 {
//            let CampStaffModelObjAry = camperStaffVMObj.CampStaffModelAry[indexPath.row]
//            cell.currentVc = self
//            //cell.
//            cell.lblTitle.text = CampStaffModelObjAry.pageMetaTitle
//            cell.colViewReload()
//        }
//        return cell
//    }
//}
