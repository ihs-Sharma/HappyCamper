//
//  SubCategoriesVideoVM.swift
//  HappyCamper
//
//  Created by wegile on 29/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit


class SubCategoriesVideoVM {
    
    var currentPage = 1
    var numberItems = 10
    var keyword = String()
    var headerTitleUrl = String()
    
    var catBannerImage = String()
    var catBannerCatDescription = String()
    var categoryName = String()
    var categoryUrl = String()
    var categoryType = String()
    var CategoryLogoImage = String()
    var bannerThumbnail = String()
    var searchString = String()
    
    var SubCategoryViewAllTopModelAry = [SubCategoryViewAllTopModel]()
    
    var CategoryName = String()
    var CatBannerObj = String()
    
    //MARK:-->VIEW ALL API FUNCTION
    func postSubCategoryViewAllApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "page_no"             :   NSNumber(integerLiteral: currentPage),
            "page_size"           :   NSNumber(integerLiteral: numberItems),
            "activity_type"       :   "\(headerTitleUrl)" ,
            "form_search_key"     :   "\(searchString)" ,
            "all_videos"          :   NSNumber(booleanLiteral: true),
            "sub_category"        :   NSNumber(booleanLiteral: false)
            ] as [String : Any]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetWebSeriess)", params: param as Dictionary<String, Any>, showIndicator: true, completion: { (JSON) in
            
            Proxy.shared.displayStatusCodeAlert(JSON["message"] as? String ?? "")
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                if  JSON["cat_thumbnail"] as? String != "" {
                     self.bannerThumbnail = JSON["cat_thumbnail"] as? String ?? ""
                }
                if let resultDict = JSON["results"] as? NSDictionary {
                    self.catBannerImage = resultDict["banner_content"] as? String ?? ""
                    self.catBannerCatDescription = resultDict["category_description"] as? String ?? ""
                    self.categoryName = resultDict["category_name"] as? String ?? ""
                    self.categoryUrl = resultDict["category_url"] as? String ?? ""
                    self.categoryType = resultDict["type"] as? String ?? ""
                    self.CategoryLogoImage = resultDict["category_logo"] as? String ?? ""
                }
                
                if let CatImageVwAry = JSON["categories_with_images_ipad"] as? NSArray {
                    if CatImageVwAry.count > 0 {
                        for i in 0..<CatImageVwAry.count {
                            if let videoDict = CatImageVwAry[i] as? NSDictionary {
                                let SubCategoryViewAllTopModelObj = SubCategoryViewAllTopModel()
                                SubCategoryViewAllTopModelObj.getTopBanner(dict: videoDict)
                                self.SubCategoryViewAllTopModelAry.append(SubCategoryViewAllTopModelObj)
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

//MARK:- Uitableview delegates and data sources
extension SubCategoriesVideoVC: UITableViewDelegate, UITableViewDataSource, SelectedViewAllVideo {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
        return 300
        } else {
            return  215
        }
    }
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry.count != 0 {
            return SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblVw.dequeueReusableCell(withIdentifier: "SubCategoryVideosTVC", for: indexPath) as! SubCategoryVideosTVC
        
        if SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry.count != 0 {
            let SubVideoCategoryModelAryObj = SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry[indexPath.row]
            cell.lblTitle.text = SubVideoCategoryModelAryObj.categoryTitle
           
            cell.btnViewAll.tag = indexPath.row
            cell.btnViewAll.addTarget(self, action: #selector(btnViewAllAction), for: .touchUpInside)
        }
        
//        cell.btnLeftAction.tag = indexPath.row
        cell.colVw.tag = indexPath.row
//        cell.btnLeftAction.addTarget(self, action: #selector(leftSlideAction(_:)), for: .touchUpInside)
        
//        cell.btnRightAction.tag = indexPath.row
//        cell.btnRightAction.addTarget(self, action: #selector(rightSlideAction(_:)), for: .touchUpInside)
        
        if SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry[indexPath.row].VideoModelAry.count != 0 {
            let SubCategoryViewAllTopModelAryObj =  SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry[indexPath.row]
            cell.VideoModelAry = SubCategoryViewAllTopModelAryObj.VideoModelAry
        }
        cell.colVw.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 100
        } else{
            return UITableView.automaticDimension
        }
    }
    
    @objc func leftSlideAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell: SubCategoryVideosTVC = tblVw.cellForRow(at: indexPath) as! SubCategoryVideosTVC
        
        let collectionBounds = cell.colVw.bounds
        let contentOffset = CGFloat(floor(cell.colVw.contentOffset.x - collectionBounds.size.width))
        
        let frame: CGRect = CGRect(x : contentOffset ,y : cell.colVw.contentOffset.y ,width : cell.colVw.frame.width,height : cell.colVw.frame.height)
        cell.colVw.scrollRectToVisible(frame, animated: true)
        
    }
    
    @objc func rightSlideAction(_ sender: UIButton)  {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell: SubCategoryVideosTVC = tblVw.cellForRow(at: indexPath) as! SubCategoryVideosTVC
        
        let collectionBounds = cell.colVw.bounds
        let contentOffset = CGFloat(floor(cell.colVw.contentOffset.x + collectionBounds.size.width))
        
        let frame: CGRect = CGRect(x : contentOffset ,y : cell.colVw.contentOffset.y ,width : cell.colVw.frame.width,height : cell.colVw.frame.height)
        cell.colVw.scrollRectToVisible(frame, animated: true)
        
    }
    
    @objc func btnViewAllAction(sender : UIButton) {
        let SubVideoCategoryModelAryObj = SubCategoriesVideoVMObj.SubCategoryViewAllTopModelAry[sender.tag]
        var nav = SubCategoryViewAllDetailVC()
        if UIDevice.current.userInterfaceIdiom == .phone{
            nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "SubCategoryViewAllDetailVC") as! SubCategoryViewAllDetailVC
        }else{
            nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "SubCategoryViewAllDetailVC") as! SubCategoryViewAllDetailVC
        }
//        let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "SubCategoryViewAllDetailVC") as! SubCategoryViewAllDetailVC
        nav.userCatUrl = SubVideoCategoryModelAryObj.catURl
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    //MARK:--> PROTOCOAL FUNCTION
    func didSelectedVideo(selectedVideoId: String,activityType:String,catSubValue:String) {
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
        //        let  nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "SubCategoryDetailVC") as! SubCategoryDetailVC
        //        nav.str_ActivityType = activityType
        //        nav.str_CategoryValue = catSubValue
        //        nav.SubCategoryDetailVMObj.userVideoId = selectedVideoId
        //        self.navigationController?.pushViewController(nav, animated: true)
        
        if self.playerController != nil {
            self.player!.pause()
        }
        
        KAppDelegate.isGradiantShown=false
        if UIDevice.current.userInterfaceIdiom != .pad {
            var  nav = HCOpenVideoIphoneVC()
            nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "HCOpenVideoIphoneVC") as! HCOpenVideoIphoneVC
            nav.str_ActivityType = activityType
            nav.str_CategoryValue = catSubValue
            nav.str_VideoId = selectedVideoId
            nav.str_FromController = ""
            //            playDelegate = self as? ManagePlyersDelegte
            self.navigationController?.pushViewController(nav, animated: true)
        } else {
            let  nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "HCOpenVideoVC") as! HCOpenVideoVC
            nav.str_ActivityType = activityType
            nav.str_CategoryValue = catSubValue
            nav.str_VideoId = selectedVideoId
            
            playDelegate = self
            
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromBottom
            view.window!.layer.add(transition, forKey: kCATransition)
            nav.view.frame = UIScreen.main.bounds
            
            self.addChild(nav)
            //make sure that the child view controller's view is the right size
            self.view.addSubview(nav.view)
            
            //you must call this at the end per Apple's documentation
            nav.didMove(toParent: self)
        }
    }
}
