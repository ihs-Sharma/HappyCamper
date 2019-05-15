//
//  WebSeriesVM.swift
//  HappyCamper
//
//  Created by wegile on 08/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class WebSeriesVideoDetailCatVM {
    
    //OTHER CONTROLLER
    var userVideoId          = String()
    var VideoDetailModelAry  = [VideoDetailModel]()
    var VideoLiked           = Int()
    
    //WEBSERIES VARIABLES
    var totalLike = Int()
    var currentPage = 1
    var numberItems = 10
    var SubCategoryViewAllTopModelAry = [SubCategoryViewAllTopModel]()
    var SubVideoCategoryModelAry = [SubVideoCategoryModel]()
    
    //MARK:--> SIGN UP API FUNCTION
    func getSubCategoriesApi(_ completion:@escaping() -> Void) {
        let param = [
            "video_id"     :  "\(userVideoId)",
            "udid"         :  "\(Proxy.shared.userId())",
            "ip"           :  "21434ewqfqwr324rf2"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetVideoDetail)", params: param, showIndicator: true, completion: { (JSON) in
            
            self.VideoLiked = JSON["is_video_liked"] as? Int ?? 0
            self.totalLike = JSON["totallikes"] as? Int ?? 0
            
            if let dictResAry = JSON["results"] as? NSArray {
                if dictResAry.count > 0 {
                    for i in 0..<dictResAry.count {
                        if let bnrDict = dictResAry[i] as? NSDictionary {
                            let VideoDetailModelObj = VideoDetailModel()
                            VideoDetailModelObj.getVideoDetailDict(dict: bnrDict)
                            self.VideoDetailModelAry.append(VideoDetailModelObj)
                        }
                    }
                }
            }
            completion()
        })
    }
    
    
    //MARK:--> VIDEO LIKE
    func videoLikeApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "udid"      :   "\(Proxy.shared.userId())",
            "video_id"  :   "\(userVideoId)"
            ] as [String:Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KPostLike)", params: param, showIndicator: true, completion: { (JSON) in
            Proxy.shared.displayStatusCodeAlert(JSON["message"] as? String ?? "")
            completion()
        })
    }
    
    //MARK:--> VIDEO LIKE
    func videoDislikeApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "udid"      :   "\(Proxy.shared.userId())",
            "video_id"  :   "\(userVideoId)"
            ] as [String:Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KDeleteVideolike)", params: param, showIndicator: true, completion: { (JSON) in
            
            completion()
        })
    }
    
    //MARK:--> ADD TO MY CAMP API
    func addToMyCampApi(_ completion:@escaping() -> Void) {
        let param = [
            "udid"      :   "\(Proxy.shared.userId())",
            "video_id"  :   "\(userVideoId)"
            ] as [String:Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KAddToMyCamp)", params: param, showIndicator: true, completion: { (JSON) in
            Proxy.shared.displayStatusCodeAlert(JSON["message"] as? String ?? "")
            completion()
        })
    }
    
    
    
    //MARK:-->VIEW ALL API FUNCTION
    func postWebSeriesApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "page_no"             :   NSNumber(integerLiteral: currentPage),
            "page_size"           :   NSNumber(integerLiteral: numberItems),
            "activity_type"       :   "web_series",
            "form_search_key"     :   "" ,
            "all_videos"          :   NSNumber(booleanLiteral: true),
            "sub_category"        :   NSNumber(booleanLiteral: false)
            ] as [String : Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetWebSeriess)", params: param as Dictionary<String, Any>, showIndicator: true, completion: { (JSON) in
            
            Proxy.shared.displayStatusCodeAlert(JSON["message"] as? String ?? "")
            
            let appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                
                // self.totalItems = JSON["totalItems"] as? Int ?? 0
                
                if let resultDict = JSON["results"] as? NSDictionary {
                    let SubCategoryViewAllTopModelObj = SubCategoryViewAllTopModel()
                    SubCategoryViewAllTopModelObj.getTopBanner(dict: resultDict)
                    self.SubCategoryViewAllTopModelAry.append(SubCategoryViewAllTopModelObj)
                }
                
                if let dictVideoAry = JSON["videos"] as? NSArray {
                    if dictVideoAry.count > 0 {
                        for i in 0..<dictVideoAry.count {
                            if let bnrDict = dictVideoAry[i] as? NSDictionary {
                                let subVideoCategoryModelAryObj = SubVideoCategoryModel()
                                subVideoCategoryModelAryObj.getVideosDict(dict: bnrDict)
                                self.SubVideoCategoryModelAry.append(subVideoCategoryModelAryObj)
                            }
                        }
                    }
                }
                completion()
                Proxy.shared.hideActivityIndicator()
            }
        })
    }
    
}

extension WebSeriesVideoDetailCatVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WebSeriesVideoDetailCatVMObj.SubVideoCategoryModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colWebVideo.dequeueReusableCell(withReuseIdentifier: "WebVideoDetailsCVC", for: indexPath) as! WebVideoDetailsCVC
        if WebSeriesVideoDetailCatVMObj.SubVideoCategoryModelAry.count != 0 {
            let SubVideoCategoryModelAryObj = WebSeriesVideoDetailCatVMObj.SubVideoCategoryModelAry[indexPath.row]
            cell.lblTitle.text = SubVideoCategoryModelAryObj.subVideoTitle
            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(SubVideoCategoryModelAryObj.subVideoImageThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            
            let string =  SubVideoCategoryModelAryObj.subVideoDiscription
            cell.lblDescription.text! = string.htmlToString
        }
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 250)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
//        return CGSize(width: 168, height: 300)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       viewDidAppear(false)
    }
}
