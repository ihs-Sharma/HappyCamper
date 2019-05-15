//
//  EpisodesDetailsVM.swift
//  HappyCamper
//
//  Created by wegile on 24/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

typealias Completion = (_ bannerData:JSON) -> Void

class WebSeriesVM {
    
    var currentPage = Int()
    var numberItems = 10
    var totalItems = Int()
    var SubCategoryViewAllTopModelAry = [SubCategoryViewAllTopModel]()
    var SubVideoCategoryModelAry = [SubVideoCategoryModel]()
    var CastDictModelAry = [CastDictModel]()
    
    //VIDEO SELECTED
    var videoId = String()
    
    //MARK:-->VIEW ALL API FUNCTION
    func postWebSeriesApi(completion: @escaping Completion) {
        
        let param = [
            "page_no"             :   NSNumber(integerLiteral: currentPage + 1),
            "page_size"           :   NSNumber(integerLiteral: numberItems),
            "activity_type"       :   "web_series",
            "form_search_key"     :   "" ,
            "all_videos"          :   NSNumber(booleanLiteral: true),
            "sub_category"        :   NSNumber(booleanLiteral: false)
            ] as [String : Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KWebSeriesDetail)", params: param as Dictionary<String, Any>, showIndicator: true, completion: { (jsonResult) in
            
            let appResponse = jsonResult["app_response"] as? Int ?? 0
            if appResponse == 200 {
                var jsonObj = JSON()
                self.totalItems = jsonResult["totalItems"] as? Int ?? 0
                
                if let resultDict = jsonResult["categories_with_images"] as? NSDictionary {
                    let SubCategoryViewAllTopModelObj = SubCategoryViewAllTopModel()
                    SubCategoryViewAllTopModelObj.getTopBanner(dict: resultDict)
                    self.SubCategoryViewAllTopModelAry.append(SubCategoryViewAllTopModelObj)
                }
                
                if let advertisements = jsonResult["advertisements"] as? [NSDictionary]
                {
                    let SubCategoryViewAllTopModelObj = SubCategoryViewAllTopModel()
                    
                    SubCategoryViewAllTopModelObj.getAdBanner(dict: advertisements)
                    
                    if advertisements.count > 0
                    {
                        self.SubCategoryViewAllTopModelAry.append(SubCategoryViewAllTopModelObj)
                    }
                }
                
                // Get results in SwiftyJSON
                if let results = jsonResult["results"] as? NSDictionary {
                    jsonObj = JSON(results)
                }
                
                if let resultDictAry = jsonResult["users"] as? NSArray {
                    if resultDictAry.count > 0 {
                        for i in 0..<resultDictAry.count {
                            if let bnrDict = resultDictAry[i] as? NSDictionary {
                                let CastDictModelObj = CastDictModel()
                                CastDictModelObj.getCastDict(dict: bnrDict)
                                self.CastDictModelAry.append(CastDictModelObj)
                            }
                        }
                    }
                }
                
                completion(jsonObj)
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    //MARK:--> GET CAST API
    func postCastApi(_ completion:@escaping() -> Void) {
        let param = [
            "page_no"             :   NSNumber(integerLiteral: currentPage + 1),
            "page_size"           :   NSNumber(integerLiteral: numberItems),
            "user_type"           :   "cast"
            ] as [String : Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetCast)", params: param as Dictionary<String, Any>, showIndicator: true, completion: { (JSON) in
            
            let appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                if let resultDictAry = JSON["results"] as? NSArray {
                    if resultDictAry.count > 0 {
                        for i in 0..<resultDictAry.count {
                            if let bnrDict = resultDictAry[i] as? NSDictionary {
                                let CastDictModelObj = CastDictModel()
                                CastDictModelObj.getCastDict(dict: bnrDict)
                                self.CastDictModelAry.append(CastDictModelObj)
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

extension WebSeriesVC : UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectedWebVideo,didselectAdvertisementDelegte {
    
    func didOpenVideo(status: Bool) {  }
    
    //MARK:--> VIDEO SELECTED ID
    func didSelected(selectedVideoId: String) {
        //        let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "WebSeriesVideoDetailCatVC") as! WebSeriesVideoDetailCatVC
        //        nav.WebSeriesVideoDetailCatVMObj.userVideoId = selectedVideoId
        //        self.navigationController?.pushViewController(nav, animated: true)
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
        Proxy.shared.pushToNextSubCatVC(identifier: "SubCategoryDetailVC", isAnimate: true, currentViewController: self, VideoId: selectedVideoId,headerName:"" , currentContName: "", activityType: "web_series", categorySubValue: "0", fromController: "")
        
    }
    
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionHeader.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "EpisodesDetailsTVC", for: indexPath) as! EpisodesDetailsTVC
        if WebSeriesVMObj.SubCategoryViewAllTopModelAry.count != 0 {
            
            let  SubCategoryViewAllTopModelObjAry =  WebSeriesVMObj.SubCategoryViewAllTopModelAry[indexPath.row]
            
            Proxy.shared.hideActivityIndicator()
            
            if SubCategoryViewAllTopModelObjAry.type == "ads"
            {
                cell.delegate = self
                cell.ad_Vw.isHidden = false
                cell.edpisode_Vw.isHidden = true
                cell.adsModelAry = SubCategoryViewAllTopModelObjAry.adsModelAry
                cell.colVwAdReload()
            }
            else
            {
                cell.ad_Vw.isHidden = true
                cell.edpisode_Vw.isHidden = false
                cell.lblHeaderTitle.text = sectionHeader[indexPath.row]
                cell.VideoModelAry = SubCategoryViewAllTopModelObjAry.VideoModelAry
                cell.colVwReload()
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 300
        }else{
            //Devansh
//            if indexPath.row == 0 {
//                return tableView.frame.height
//            } else {
                return 210
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WebSeriesVMObj.CastDictModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let CastDictModelObj = WebSeriesVMObj.CastDictModelAry[indexPath.row]
        let cell = collVw.dequeueReusableCell(withReuseIdentifier: "CastCVC", for: indexPath) as! CastCVC
        cell.lblTitle.text = CastDictModelObj.castName
        
        let string =  CastDictModelObj.castDescription
        cell.lblDetail.text = string.htmlToString
        DispatchQueue.main.async {
            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KTrainerImage)\( CastDictModelObj.castImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        //        Proxy.shared.hideActivityIndicator()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if Proxy.shared.authNil() == "" {
//            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
//            return
//        }
        
        
        let CastDictModelObj = WebSeriesVMObj.CastDictModelAry[indexPath.row]
        if  WebSeriesVMObj.CastDictModelAry.count  != 0 {
            
            var nav = CastScreenVC()
            if UIDevice.current.userInterfaceIdiom == .phone{
                nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "CastScreenVC") as! CastScreenVC
            }else{
                nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "CastScreenVC") as! CastScreenVC
            }
//            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "CastScreenVC") as! CastScreenVC
            nav.arr_CastUsers = WebSeriesVMObj.CastDictModelAry
            nav.selectedUserIndex = indexPath.row
            nav.isFromCampfire="WebSeries"
            nav.castDescription = CastDictModelObj.castDescription
            nav.castImage = CastDictModelObj.castImage
            nav.castName  = CastDictModelObj.castName
            nav.castActivity  = CastDictModelObj.castActivity
            self.navigationController?.pushViewController(nav, animated: true)
        }
    }
    
    //Devansh
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: 185.0, height: 150.0)

//            return CGSize(width : UIScreen.main.bounds.width/2.8, height : collectionView.frame.size.height / 1.7)
        } else {
//            return CGSize(width: 185.0, height: 150.0)
            return CGSize(width: 226.0, height: 191.0)
        }
    }
    
    func didselectAdvertisement(adUrl: String) {
        let svc = SFSafariViewController(url: NSURL(string: adUrl)! as URL)
        self.present(svc, animated: true, completion: nil)
    }
    
    func didPauseVideoForSeries(status: Bool) {
        if status {
            if self.playerController != nil {
                self.player!.pause()
            }
        }
    }
}
