//
//  CampModel.swift
//  HappyCamper
//
//  Created by wegile on 12/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON
class TransactionModel {
    
    var transactionEmail = String()
    var transactionAmount = String()
    var transactionStatus = String()
    var transactionName = String()
    var subscriptionPlan = String()
    var subscriptionId = String()
    var transactionId = String()
    var createdAt = String()
    
    func dictDetail(userDict: NSDictionary)  {
        transactionEmail = userDict["email"] as? String ?? ""
        transactionAmount = userDict["amount"] as? String ?? ""
        transactionStatus = userDict["status"] as? String ?? ""
        transactionName = userDict["name"] as? String ?? ""
        subscriptionId = userDict["subscription_id"] as? String ?? ""
        subscriptionPlan = userDict["plan"] as? String ?? ""
        createdAt = userDict["created_at"] as? String ?? ""
        
    }
}
class CampListModel {
    var campId = String()
    var campTitle = String()
    var campAddress = String()
    var arr_campBannerImg : [JSON] = []
    var campShortDesc = String()
    
    func userItemDict(dict: NSDictionary) {
        let json = JSON(dict)

        campId = dict["_id"] as? String ?? ""
        campTitle = dict["camp_title"] as? String ?? ""
        campShortDesc = dict["short_description"] as? String ?? ""
        arr_campBannerImg = json["camp_banner_link"].arrayValue
        campAddress = dict["address"] as? String ?? ""
    }
}

class ResultModel {
    
    var videoUrl = String()
    var videoId = String()
    var videoDescription = String()
    var videoTitle = String()
    var videoImgThumb = String()
    var videoShortTitle = String()
    var videoShortDescription = String()
    var headerCategoryUrl = String()
    
    func dictData(dict : NSDictionary) {
        
        videoUrl         = dict["video"] as? String ?? ""
        videoId          = dict["_id"] as? String ?? ""
        videoTitle       = dict["video_title"] as?  String ?? ""
        videoShortTitle       = dict["short_title"] as?  String ?? ""
        videoImgThumb    = dict["image_thumbnail"] as? String ?? ""
        videoDescription = dict["video_description"] as? String ?? ""
        videoShortDescription = dict["short_description"] as? String ?? ""
        headerCategoryUrl = dict["video_url"] as? String ?? ""

    }
}

class CampModel {
    var campId = String()
    var campAddress = String()
    var campTitle = String()
    var campPhone = String()
    var campLocation = String()
    var campCreated = String()
    var arr_campBannerLink : [JSON] = []
    var campDescription = String()
    var campLongDescription = String()
    var campCategory = String()
    var campType = String()
    var campCapacity = String()
    var gender = String()
    var imageBanner = String()
    var age = String()
    var campSpace = String()
    var foundedYear = String()
    var director = String()
    var campActivity = String()
    var accreditations = String()
    var is_featured = Bool()
    
    func dictData(dict: NSDictionary) {
        let json = JSON(dict)

        campAddress = dict["address"] as? String ?? ""
        campTitle = dict["camp_title"] as? String ?? ""
        campLocation = dict["location"] as? String ?? ""
        campLongDescription = dict["long_description"] as? String ?? ""
        arr_campBannerLink = json["camp_banner_link"].arrayValue
        campDescription = dict["short_description"] as? String ?? ""
        campCreated = dict["created_at"] as? String ?? ""
        campId = dict["_id"] as? String ?? ""
        campPhone = dict["phone_number"] as? String ?? ""
        campCategory = dict[""] as? String ?? ""
        campCapacity = dict["camp_capacity"] as? String ?? ""
        gender = dict["gender"] as? String ?? ""
        age = dict["age"] as? String ?? ""
        campSpace = dict["camp_space"] as? String ?? ""
        foundedYear = dict["year_founded"] as? String ?? ""
        director = dict["directors"] as? String ?? ""
        campActivity = dict["camp_activity"] as? String ?? ""
        accreditations = dict["accreditations"] as? String ?? ""
        is_featured = dict["is_featured"] as? Bool ?? false
        
        if let CampDict = dict["camp_type"] as? NSDictionary {
            campType = CampDict["camp_type"] as? String ?? ""
        }
    }
}
