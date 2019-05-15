//
//  SubCategoryDetailVM.swift
//  HappyCamper
//
//  Created by wegile on 30/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import Foundation
import UIKit
typealias CompletionHandler = (_ success:Bool) -> Void

class SubCategoryDetailVM {
    //OTHER CONTROLLER
    var userVideoId          = String()
    var VideoDetailModelAry  = [VideoDetailModel]()
    var headerTitleUrl = String()
    var SubCategoryViewAllTopModelAry = [SubCategoryViewAllTopModel]()
    var SubCategoriesVideoVMObj =  SubCategoriesVideoVM()
    
    let advertiementAry      = NSMutableArray()
    
    var BannerModelAry       = [BannerModel]()
    var VideoLiked           = Int()
    var totalLike            = Int()
    var fromCont             = String()
    var htp                  = ""
    
    var catBannerImage = String()
    var catBannerCatDescription = String()
    var categoryName = String()
    var categoryUrl = String()
    var categoryType = String()
    var CategoryLogoImage = String()
    
    var CategoryModelAry     = [CategoryModel]()
    var GuestLandingModelAry = [GuestLandingModel]()
    
    //MARK:--> SIGN UP API FUNCTION
    func getSubCategoriesApi(_ completion:@escaping() -> Void) {
        let param = [
            "video_id"     :  "\(userVideoId)",
            "udid"         :  "\(Proxy.shared.userId())",//"\(Proxy.shared.userId())",
            "ip"           :  "12421351sdgwe4t324543"
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
    
    //MARK:--> GET HOME SCREEN API
    func postHomeScreenApiWithActivityType(type:String!,categoryValue:String!,completionHandler: @escaping CompletionHandler) {
        
        let param = [
            //            "page_type":"\(htp)",
            "activity_type": "\(String(describing: type!))",
            "all_videos": "1",
            "form_search_key": "",
            "page_no": "1",
            "page_size": "100",
            "sub_category": "\(String(describing: categoryValue!))"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetCategoriesItems)", params: param, showIndicator: true, completion: { (JSON) in
            
            var appResponse = Int()
            
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                
                
                if let dictBanAry = JSON["categories_with_images"] as? NSArray
                {
                    if dictBanAry.count > 0
                    {
                        for i in 0..<dictBanAry.count
                        {
                            if let bnrDict = dictBanAry[i] as? NSDictionary {
                                let SubCategoryViewAllTopModelObj = SubCategoryViewAllTopModel()
                                SubCategoryViewAllTopModelObj.getTopBanner(dict: bnrDict)
                                self.SubCategoryViewAllTopModelAry.append(SubCategoryViewAllTopModelObj)
                            }
                            //                            var categoryDict = categories_images[i]
                            //
                            //                            let CategoryModelObj = CategoryModel()
                            //
                            //                            CategoryModelObj.dictCategoryData(data: categoryDict)
                            //
                            //                            self.CategoryModelAry.append(CategoryModelObj)
                            
                        }
                    }
                }
                if let dictResAry = JSON["results"] as? NSDictionary { //NSArray hitesh
                    //
                    if dictResAry.count > 0 {
                        for i in 0..<dictResAry.count {
                            if let bnrDict = dictResAry[i] as? NSDictionary {
                                let CategoryModelObj = CategoryModel()
                                CategoryModelObj.dictData(data: bnrDict)
                                self.CategoryModelAry.append(CategoryModelObj)
                            }
                        }
                    }
                }
                //
                if let dictBanAry = JSON["categories_with_images_ipad"] as? NSArray {
                    if dictBanAry.count > 0 {
                        for i in 0..<dictBanAry.count {
                            if let bnrDict = dictBanAry[i] as? NSDictionary {
                                let SubCategoryViewAllTopModelObj = SubCategoryViewAllTopModel()
                                SubCategoryViewAllTopModelObj.getTopBanner(dict: bnrDict)
                                self.SubCategoryViewAllTopModelAry.append(SubCategoryViewAllTopModelObj)
                                // if let bnrItemAry = bnrDict["video_items"] as? NSArray {
                                // if bnrItemAry.count > 0 {
                                // for i in 0..<bnrItemAry.count {
                                // if let bnrDict = bnrItemAry[i] as? NSDictionary {
                                // let bannerModelObj = BannerModel()
                                // bannerModelObj.getBannerDetail(dict: bnrDict)
                                // self.BannerModelAry.append(bannerModelObj)
                                // }
                                // }
                                // }
                                // }
                            }
                        }
                    }
                }
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            Proxy.shared.hideActivityIndicator()
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
}



extension SubCategoryDetailVC: UITableViewDataSource, UITableViewDelegate, SelectedVideo {
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubCategoryDetailVMObj.SubCategoryViewAllTopModelAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "SubCategoryDetailTVC", for: indexPath) as! SubCategoryDetailTVC
        
        if SubCategoryDetailVMObj.SubCategoryViewAllTopModelAry.count != 0 {
            let SubVideoCategoryModelAryObj = SubCategoryDetailVMObj.SubCategoryViewAllTopModelAry[indexPath.row]
            cell.lblheader.text = SubVideoCategoryModelAryObj.categoryTitle
            if SubVideoCategoryModelAryObj.categoryTitle == "MORE EPISODES" {
                cell.btnViewAll.isHidden = true
            }
            
        }
        if SubCategoryDetailVMObj.SubCategoryViewAllTopModelAry[indexPath.row].VideoModelAry.count != 0 {
            let SubCategoryViewAllTopModelAryObj =  SubCategoryDetailVMObj.SubCategoryViewAllTopModelAry[indexPath.row]
            cell.VideoModelAry = SubCategoryViewAllTopModelAryObj.VideoModelAry
        }
        
        cell.btnLeftAction.tag = indexPath.row
        cell.colVw.tag = indexPath.row
        cell.btnLeftAction.addTarget(self, action: #selector(leftSlideAction(_:)), for: .touchUpInside)
        
        cell.btnRightAction.tag = indexPath.row
        cell.btnRightAction.addTarget(self, action: #selector(rightSlideAction(_:)), for: .touchUpInside)
        
        cell.btnViewAll.tag = indexPath.row
        cell.btnViewAll.addTarget(self, action: #selector(btnViewAllAction), for: .touchUpInside)
        cell.colVw.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    @objc func leftSlideAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell: SubCategoryDetailTVC = tblVw.cellForRow(at: indexPath) as! SubCategoryDetailTVC
        
        let collectionBounds = cell.colVw.bounds
        let contentOffset = CGFloat(floor(cell.colVw.contentOffset.x - collectionBounds.size.width))
        
        let frame: CGRect = CGRect(x : contentOffset ,y : cell.colVw.contentOffset.y ,width : cell.colVw.frame.width,height : cell.colVw.frame.height)
        cell.colVw.scrollRectToVisible(frame, animated: true)
        
    }
    
    @objc func rightSlideAction(_ sender: UIButton)  {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell: SubCategoryDetailTVC = tblVw.cellForRow(at: indexPath) as! SubCategoryDetailTVC
        
        let collectionBounds = cell.colVw.bounds
        let contentOffset = CGFloat(floor(cell.colVw.contentOffset.x + collectionBounds.size.width))
        
        let frame: CGRect = CGRect(x : contentOffset ,y : cell.colVw.contentOffset.y ,width : cell.colVw.frame.width,height : cell.colVw.frame.height)
        cell.colVw.scrollRectToVisible(frame, animated: true)
        
    }
    
    //MARK:--> VIEW ALL BUTTON ACTION
    @objc func btnViewAllAction(sender: UIButton)
    {
        let CategoryModelAryObj = SubCategoryDetailVMObj.SubCategoryViewAllTopModelAry[sender.tag]
        let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "SubCategoriesVideoVC") as! SubCategoriesVideoVC
        nav.SubCategoriesVideoVMObj.headerTitleUrl = CategoryModelAryObj.catURl
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func didSelected(selectedVideoId: String,videoUrl:String) {
        //        SubCategoryDetailVMObj.userVideoId = selectedVideoId
        //        viewWillAppear(false)
        //        reloadData()
    }
    
}
