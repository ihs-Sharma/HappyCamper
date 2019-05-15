//
//  SubCategoryModel.swift
//  HappyCamper
//
//  Created by wegile on 05/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON
class VideoDetailModel {
    var videoImageThumb  = String()
    var videoUrl         = String()
    var videoDescription = String()
    var videoViewsId     = String()
    var dictCount        = Int()
    var videoTitle       = String()
    var videoId          = String()
    var headerCategoryUrl = String()

    func getVideoDetailDict(dict: NSDictionary) {
        videoImageThumb  = dict["image_thumbnail"] as? String ?? ""
        videoDescription = dict["video_description"] as? String ?? ""
        videoUrl         = dict["video"] as? String ?? ""
        videoTitle       = dict["video_title"] as? String ?? ""
        videoId          = dict["_id"] as? String ?? ""
        headerCategoryUrl = dict["video_url"] as? String ?? ""

        if let dictResAry = dict["views"] as? NSArray {
            
            if dictResAry.count > 0 {
                dictCount = dictResAry.count
                for i in 0..<dictResAry.count {
                    if let bnrDict = dictResAry[i] as? NSDictionary {
                        videoViewsId = bnrDict["video_id"] as? String ?? ""
                    }
                }
            }
        }
    }
}



//VIEW ALL
class SubCategoryViewAllTopModel {
   
    var categoryId       = String()
    var categoryTitle    = String()
    var userCatUrl       = String()
    var catURl           = String ()
    var type             = String()
    var VideoModelAry    = [VideoModel]()
    var SubCatModelAry   = [SubCatModel]()
    
    var adsModelAry      = [advertisementModel]()
    
    func getTopBanner(dict: NSDictionary) {
  
        categoryId = dict["category_id"] as? String ?? ""
        categoryTitle = dict["category_title"] as? String ?? ""
        userCatUrl = dict["categoryurl"] as? String ?? ""
        
        if let categoriesDeatilDict = dict["category_details"] as? NSDictionary {
            catURl = categoriesDeatilDict["category_url"] as? String ?? ""
        }
        
        if let itemAry = dict["video_items"] as? NSArray {
            if itemAry.count != 0 {
                for i in 0..<itemAry.count {
                    if let itemDict = itemAry[i] as? NSDictionary {
                        let VideoModelObj = VideoModel()
                        VideoModelObj.userItemDict(dict: itemDict, strCatagoryURL: catURl)
                        VideoModelAry.append(VideoModelObj)
                    }
                }
            }
        }
        
        
    }
    
    func getAdBanner(dict: [NSDictionary]) {
        
        type = "ads"
        
        for ads in dict
        {
            let adModelObj = advertisementModel()
            adModelObj.dictDetail(dict: ads)
            adsModelAry.append(adModelObj)
        }
    }
    
    
    
    

}


//VIEW ALL
class VideoModel {
    var videoDesc       = String()
    var videoTitle      = String()
    var videoUrl        = String()
    var videoImgThumb   = String()
    var videoId         = String()
    var shortTitle = String()
    var shortDiscription = String()
    var CatagoryURL     = String()
    
    func userItemDict(dict: NSDictionary , strCatagoryURL: String) {
        videoDesc       = dict["video_description"] as? String ?? ""
        videoTitle      = dict["video_title"]  as? String ?? ""
        shortDiscription       = dict["short_description"] as? String ?? ""
        shortTitle      = dict["short_title"]  as? String ?? ""
        videoUrl        = dict["video"] as? String ?? ""
        videoImgThumb   = dict["image_thumbnail"] as? String ?? ""
        videoId         = dict["_id"] as? String ?? ""
        CatagoryURL     = strCatagoryURL
    }
}

//VIEW ALL
class SubCatModel {
    var catTitle         = String()
    var categoryId       = String()
    var categoryUrl      = String()
    var categoryImage    = String()
    var categoryDescription = String()
    
    func dictDetail(dict: NSDictionary) {
       categoryId          = dict["_id"] as? String ?? ""
       catTitle            = dict["meta_title"] as? String ?? ""
       categoryUrl         = dict["category_url"] as? String ?? ""
       categoryImage       = dict["category_image"] as? String ?? ""
       categoryDescription = dict["category_description"] as? String ??  ""
    }
}

class SubVideoCategoryModel {
    var subVideoImageThumb   = String()
    var subCatVideoId        = String()
    var subVideoDiscription  = String()
    var subVideoTitle        = String()
    var subCategoryId        = String()
    
    func getVideosDict(dict: NSDictionary) {
        subVideoTitle       =   dict["video_title"] as? String ?? ""
        subVideoDiscription =   dict["video_description"] as? String ?? ""
        subCatVideoId       =   dict["_id"] as? String ?? ""
        subVideoImageThumb  =   dict["image_thumbnail"] as? String ?? ""
        subCategoryId       =   dict["sub_category_id"] as? String ?? ""
    }
}

class advertisementModel {
    var imgUrl         = String()
    var img_link_url       = String()
    
    
    func dictDetail(dict: NSDictionary) {
        imgUrl          = dict["banner"] as? String ?? ""
        img_link_url    = dict["url"] as? String ?? ""
        
    }
}

class CastDictModel {
    var castDescription  = String()
    var castName         = String()
    var castUrl          = String()
    var castImage        = String()
    var castActivity     = String()
    
    var cast_Counselor        = String()
    var cast_Credential        = String()
    var castTitle        = String()
    var arr_Facts   : [JSON] = []
    
    func getCastDict(dict: NSDictionary){
        let json = JSON(dict)
        castDescription  = dict["description"] as? String ?? ""
        castName         = dict["name"] as? String ?? ""
        castUrl          = dict["url_key"] as? String ?? ""
        castImage        = dict["image"] as? String ?? ""
        castActivity     = dict["activity"] as? String ?? ""
        cast_Counselor = dict["counselor"] as? String ?? ""
        
        cast_Credential        = dict["credential"] as? String ?? ""
        castTitle     = dict["title"] as? String ?? ""
        
        arr_Facts = json["fun_fact"].arrayValue
    }
}
