//
//  UserModel.swift
//  HappyCamper
//
//  Created by wegile on 04/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON
class UserModel {
    var userId = String()
    var userEmail = String()
    var userName = String()
    var userImage = String()
    var user_Coins = Int()
    func getUserDetail(dict: NSDictionary) {
        userId      = dict["_id"] as? String ?? ""
        userName    = dict["user_name"] as? String ?? ""
        userEmail   = dict["user_email"] as? String ?? ""
        userImage   = dict["photo"] as? String ?? ""
        user_Coins = dict["coins"] as? Int ?? 0
        
        Proxy.shared.setUserId(id:userId)
        UserDefaults.standard.set(user_Coins, forKey: "User_Coins")
        if userImage != "" {
            var colorAPI:String = ""
            
            if let color = dict["theme_color"] as? String {
                if color == "green" {
                    colorAPI = Apis.KAviatorGreen
                    
                } else if color == "blue" {
                    colorAPI = Apis.KAviatorBlue
                }
            }
            
            let imgString = "\(colorAPI)\(userImage)"
            print(imgString)
            UserDefaults.standard.set(imgString, forKey: "selected_aviator")
        }
        if userName != "" {
            UserDefaults.standard.set(userName, forKey: "userName")
        }
        if userEmail != "" {
            UserDefaults.standard.set(userEmail, forKey: "userEmail")
        }
        UserDefaults.standard.synchronize()
    }
}

class SubscriptionModel {
    var amount = String()
    var barintree_customerId = String()
    var email = String()
    var name = String()
    var plan = String()
    var subscription_id = String()
    
    func getSubscriptionDetail(dict: NSDictionary) {
        amount      = dict["amount"] as? String ?? ""
        barintree_customerId    = dict["barintree_customerId"] as? String ?? ""
        email   = dict["email"] as? String ?? ""
        
        name      = dict["name"] as? String ?? ""
        plan    = dict["plan"] as? String ?? ""
        subscription_id   = dict["subscription_id"] as? String ?? ""
    }
}

class CampStaffModel {
    var pageDescription = String()
    var pageTitle = String()
    var pageMetaTitle = String()
    
    func dictData(dict: NSDictionary) {
        pageDescription = dict["page_description"] as? String ?? ""
        pageMetaTitle   = dict["meta_title"] as? String ?? ""
        pageTitle       = dict["page_title"] as? String ?? ""
    }
}


class AdvertisementModel {
    
    var advType   = Int()
    var advBanner = String()
    var advTitle  = String()
    var bannerImage  = String()
    var bannerURL  = String()
    
    func dictData(dict: NSDictionary) {
        advType = dict["type"] as? Int ?? 0
        let json = JSON(dict)
        bannerImage = json["banner"][0].stringValue
        advTitle = dict["title"] as? String ?? ""
        bannerURL = dict["url"] as? String ?? ""
    }
}



class CanteenModel {
    var description = String()
    var imageArr = [String]()
    var title = String()
    var coins = Int()
    var Id = String()
    var type = String()
    var banner = String()
    var url = String()
    var ads = [adModel]()
    var coinArr = [coinModel]()
    
    func dictData(dict: NSDictionary) {
        description = dict["description"] as? String ?? ""
        coins = dict["coins"] as? Int ?? 0
        title = dict["title"] as? String ?? ""
        Id = dict["_id"] as? String ?? ""
        type = "Coin"
        
        if let imagAry = dict["image"] as? NSArray {
            if imagAry.count != 0 {
                // imageArr.adding(imagAry)
            }
        }
    }
    
    func dictCoinData(dictarr: [NSDictionary]) {
        type = "Coin"
        
        for dict in dictarr
        {
            let adObj = coinModel()
            
            adObj.description = dict.value(forKey: "description") as! String
            adObj.coins = dict.value(forKey: "coins") as! Int
            adObj.title = dict.value(forKey: "title") as! String
            adObj.Id = dict.value(forKey: "_id") as! String
            
            
            
            
            if let imagAry = dict["image"] as? NSArray {
                if imagAry.count != 0 {
                    
                    for img in imagAry
                    {
                        adObj.imgArr.append(img as! String)
                    }
                }
            }
            
            coinArr.append(adObj)
        }
    }
    
    
    func dictAdData(dictarr: [NSDictionary]) {
        type = "ads"
        
        for dict in dictarr
        {
            let adObj = adModel()
            adObj.banner = dict["banner"] as! String
            adObj.url = dict["url"] as! String
            ads.append(adObj)
        }
    }
}

class coinModel
{
    var description = String()
    var imgArr = [String]()
    var title = String()
    var coins = Int()
    var Id = String()
    var type = String()
}

class adModel
{
    var banner = String()
    var url = String()
    
}
