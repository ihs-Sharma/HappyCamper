//
//  CampfireBannerModel.swift
//  HappyCamper
//
//  Created by wegile on 28/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CampfireBannerModel {
    var bannertitle = String()
    var content = String()
    var type = String()
   
    
    func dictData(dict:  NSDictionary) {
        bannertitle = dict["banner_title"] as? String ?? ""
        content     = dict["content"] as? String ?? ""
        type        = dict["type"] as? String ?? ""
    }
}

class CamperfireResultModel {
    var image = String()
    var name  = String()
    var type  = String()
    
    func dictData(dict: NSDictionary) {
        image = dict["image"] as? String ?? ""
        name  = dict["name"] as? String ?? ""
        type  = dict["type"] as? String ?? ""
    }
}

class CampfirePageModel {
    var title = String()
    var description = String()
    var pageUrl = String()

    func dictData(dict: NSDictionary) {
        title        =  dict["page_title"] as? String ?? ""
        description  =  dict["page_description"] as? String ?? ""
        pageUrl      =  dict["page_url"] as? String ?? ""
    }
}

class CampfireResultVideoModel {
    var firstName = String()
    var lastName  = String()
    var userEmail = String()
    var bio       = String()
    var UserViewAry = NSMutableArray()
   
    var videoTitle = String()
    var videoUrl   = String()
    var videoDesc  = String()
    var VideoThumb = String()
    
    func dictData(dict: NSDictionary) {
        firstName = dict["first_name"] as? String ?? ""
        lastName  = dict["last_name"] as? String ?? ""
        userEmail = dict["user_email"] as? String ?? ""
        bio       = dict["bio"] as? String ?? ""
        
        videoDesc    = dict["video_description"] as? String ?? ""
        videoTitle  = dict["video_title"] as? String ?? ""
        videoUrl   = dict["video_url"] as? String ?? ""
        VideoThumb  = dict["thumb_name"] as? String ?? ""
        
       if let videoAry = dict["videoViews"] as? NSArray {
        
        if videoAry.count != 0 {
            let countNum = videoAry.count
                UserViewAry.adding(countNum)
            } else {
                UserViewAry.adding(0)
            }
        }
    }
}

class ContestModel {
    var bios =  String()
    var comment = String()
    var descriptions = String()
    var thumb = String()
    var userId = String()
    
    func dictData(dict: NSDictionary) {
        bios = dict["bio"] as? String ?? ""
        comment = dict["comment"] as? String ?? ""
        descriptions = dict["description"] as? String ?? ""
        thumb = dict["thumbnail"] as? String ?? ""
        userId = dict["_id"] as? String ?? ""
    }
}
