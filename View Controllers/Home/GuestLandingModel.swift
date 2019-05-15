//
//  GuestLandingModel.swift
//  HappyCamper
//
//  Created by wegile on 01/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit


class CategoryModel {
    
    var headerCategoryUrl = String()
    var headerCategoryName = String()
    var headerCategoryId = String()
    var headerVideos : [GuestLandingModel] = []
    var header_type = String()
    var advertisment = [NSDictionary]()
    
    func dictData(data: NSDictionary) {
        headerCategoryId   = data["category_id"] as? String ?? ""
        headerCategoryName = data["category_title"] as? String ?? ""
        headerCategoryUrl  = data["categoryurl"] as? String ?? ""
        
        if let video_itemsArr = data["video_items"] as? NSArray {
            if video_itemsArr.count > 0 {
                for i in 0..<video_itemsArr.count {
                    if let videoDict = video_itemsArr[i] as? NSDictionary {
                        let GuestLandingModelObj =  GuestLandingModel()
                        
                        header_type = "Video"
                        GuestLandingModelObj.getGuestLandingDetail(dict: videoDict)
                        headerVideos.append(GuestLandingModelObj)
                    }
                }
            }
        }   
    }
    
    func dictCategoryData(data: NSDictionary) {
        headerCategoryId = data["category_id"] as? String ?? ""
        headerCategoryName = data["category_title"] as? String ?? ""
        
        let categoryDetail = data["category_details"] as! NSDictionary
        
        headerCategoryUrl = categoryDetail["category_url"] as? String ?? ""
        
        if let video_itemsArr = data["video_items"] as? NSArray {
            if video_itemsArr.count > 0 {
                for i in 0..<video_itemsArr.count {
                    if let videoDict = video_itemsArr[i] as? NSDictionary {
                        let GuestLandingModelObj = GuestLandingModel()
                        
                        
                        header_type = "Video"
                        GuestLandingModelObj.getGuestLandingDetail(dict: videoDict)
                        
                        
                        headerVideos.append(GuestLandingModelObj)
                    }
                }
            }
        }
    }
    
}

class GuestLandingModel {
    
    var videoTitle = String()
    var videoDiscription = String()
    var shortTitle = String()
    var shortDiscription = String()
    var type = String()
    var videoImageThumb = String()
    var videoUrl = String()
    var videoId = String()
    var videoCatUrl = String()
    var headerCategoryUrl = String()

    
    
    func getGuestLandingDetail(dict: NSDictionary) {
        shortTitle = dict["short_title"] as? String ?? ""
        shortDiscription = dict["short_description"] as? String ?? ""
        videoTitle = dict["video_title"] as? String ?? ""
        videoDiscription = dict["video_description"] as? String ?? ""
        videoImageThumb = dict["image_thumbnail"] as? String ?? ""
        videoUrl = dict["video_url"] as? String ?? ""
        videoCatUrl = dict["category_id"] as? String ?? ""
        videoId = dict["_id"] as? String ?? ""
        headerCategoryUrl = dict["category_url"] as? String ?? ""
        
        if let typev = dict["type"]
        {
            type = typev as! String
        }
        else
        {
            type = "video"
        }
        
    }
    
}


class BannerModel {
    
    var bannerVideoImgThumb = String()
    var bannerVideoUrl = String()
    var bannerVideoTitle = String()
    var videoPlayLink = String()
    var videoDescription = String()
    
    func getBannerDetail(dict: NSDictionary){
        bannerVideoUrl = dict["video_url"] as? String ?? ""
        bannerVideoImgThumb = dict["image_thumbnail"] as? String ?? ""
        bannerVideoTitle = dict["video_title"] as? String ?? ""
        videoPlayLink = dict["video"] as? String ?? ""
        videoDescription = dict["video_description"] as? String ?? ""
    }
}


class AviatorModel {
    var aviatorImage = String()
    var aviatorGreenImage = String()
    
    func getAviator(dict: NSDictionary) {
        aviatorImage = dict["avator_image"] as? String ?? ""
        aviatorGreenImage = dict["avator_image_green"] as? String ?? ""
    }
    
}
