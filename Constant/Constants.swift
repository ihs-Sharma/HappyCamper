//
//  WebServiceProxy.swift

//  Created by Desh Raj Thakur on 3/10/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import Foundation
import UIKit

enum AppInfo {
    static let Mode = "Development"
    static let AppName = "Happy Camper"
    static let Version =  "1.0"
    static let UserAgent = "\(Mode)/\(AppName)/\(Version)"
    static let AppColor = UIColor(red: 77/255, green: 46/255, blue: 124/255, alpha: 1).cgColor
    
    static let PlaceHolderBlkColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    static let PlaceHolderColor = UIColor(red: 76/255, green: 46/255, blue: 124/255, alpha: 1)
    static let lightGrayColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    static let darkGrayColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
    static let darkGrayTextColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
    static let PlaceHolderPurplColor = UIColor(red: 61/255, green: 36/255, blue: 99/255, alpha: 1)
    static let greenBackgroundColor = UIColor(red: 74/255, green: 48/255, blue: 129/255, alpha: 1)
}
//sandbox
let KReceiptUrl             =   "https://sandbox.itunes.apple.com/verifyReceipt"

var kisSubscribed = true

//Live
//    static let KReceiptUrl             =   ""https://buy.itunes.apple.com/verifyReceipt""

//enum Subscription {
//    static let secretIDKey            = "318513252bb941cb937e970329522e1c"
//
//    static let monthSubID             = "com.compax.happycamper.monthly"
//    static let quaterlySubID          = "com.compax.happycamper.quarterly"
//    static let yearlySubID            = "com.compax.happycamper.yearly"
//}

let monthSubID             = "com.compax.happycamper.monthly"
let quaterlySubID          = "com.compax.happycamper.quarterly"
let yearlySubID            = "com.compax.happycamper.yearly"


let IAP_Products = [monthSubID,quaterlySubID,yearlySubID]

func bucketURL(server:String!) -> String! {
    var bucketURL:String! = ""
    if server == "http://34.195.246.195:3001/" {
        bucketURL = "https://happycamperstaging.s3.amazonaws.com"
    } else {
        bucketURL = "http://d32say8as79aym.cloudfront.net"
    }
    return bucketURL
}

//BUCKKET URL
//    static let bucketurl              =   "https://happycamperlive.s3.amazonaws.com"
//    static let bucketurl              =   "https://happycamperstaging.s3.amazonaws.com"  // Staging Bucket
//let bucketurl              =   "http://d32say8as79aym.cloudfront.net"   // Live Bucket Link with http://18.215:

//var isProduction:Bool = true
//if isProduction {
//
//}

enum Apis {
    
    // Staging API
    //        static let KServerUrl             =   "http://34.195.246.195:3001/"
    
    
    //STAGGING Site API
    //        static let KSiteUrl             =     "http://100.25.25.249/"
    
    
    //    LIVE API
    //    static let KServerUrl             =   "http://18.215.132.27:3001/"
    static let KServerUrl             =   "https://apis.happycamperlive.com/"
    
    
    //    Live Site API
    //    static let KSiteUrl             =   "http://18.215.132.27/"
    static let KSiteUrl             =   "https://www.happycamperlive.com/"
    
    
    //    static let K360Camp               =   "http://54.147.2.187/"
    static let K360Camp               =   "https://virtual.happycamperlive.com/ipad/"
    
    //    static let KBlog                  =   "http://34.202.241.63/?without=HF"
    static let KBlog                  =   "https://blog.happycamperlive.com/?without=HF"
    
    
    static let KLogout                =   "logout"
    static let KLogin                 =   "login"
    static let KCheck                 =   "checkapi"
    static let KChangePswrd           =   "change_password"
    static let KSignUp                =   "signup"
    
    static let KAboutUsLink           =   "about-us/ipad"
    static let KContactUsLink         =   "contact-us/ipad"
    static let KFaqLink               =   "faqs/ipad" // Hitesh
    static let KCampStaffUrl          =   "members/staff/ipad"
    static let KCommunity             =   "community/ipad"
    
    static let KCamperBenifitLink       =   "camper-benefit/ipad" //"http://18.215.132.27/camper-benefit"
    
    static let KPrivacyPolicy         =   "privacy-policy/ipad"
    static let KTermsAndPrivacy       =   "terms_and_condition/ipad"
    
    //static let KHomeScreenApi       =   "get_homepage_data_old"
    static let KHomeScreenApi         =   "get_homepage_data_ipad"  // get_homepage_datav3
    static let KAdvertisementApi      =   "getAdvertisements"
    static let KCanteenCoin           =   "getall_coinsproducts"
    static let KBuyWithCoins          =   "redeemProduct_withcoins"
    static let manageSubscription     = "get_subscription_details_ipad"
    
    static let KUpdateProfile         =   "update_profile"
    static let KGetVideoDetail        =   "get_video_details_ipad"
    static let KAviator               =   "avtarIcon"
    static let KSubmitContactForm     =   "submit_contact_from"
    static let KSubmitTeam     =   "submit_joinstaff_from"
    
    static let KCamplist              =   "getall_camps"
    static let KFavouritesVideo       =   "getall_fav_videos"
    static let KMyFavouritesVideo       =   "get_myfav_ipad"
    static let KFavouritesCamps       =   "getall_favcamps"
    
    static let KCampDetail            =   "get_camp_details"
    static let KAddFavCamp            =   "add_camp_tomylist"
    static let KSendRequest           =   "sendrequest"
    
    static let KRecoverPassword       =   "request"
    static let KGetWebSeries          =   "get_activity_items"
    //static let KGetWebSeriess       =   "get_activity_items_IPAD"
    static let KGetCategoriesItems      =   "get_activity_itemsV2"
    static let KGetWebSeriess         =   "get_activity_itemsV2"
    static let KWebSeriesDetail        =   "get_webseries_items_ipad"
    static let KupdateprofileTheme    =   "updateimage_profile"
    static let KConsentGet            =   "get_contestDetails"
    static let KSubscriptionDetail           =   "addupdate_subscription_ipad"
    
    static let KGetCast               =   "get_users"
    static let KPostLike              =   "add_video_like"
    static let KDeleteVideolike       =   "delete_video_like"
    static let KAddToMyCamp           =   "add_video_tomylist"
    static let KTransaction           =   "transaction_IPAD"
    static let KAddInformation        =   "submit_enquiry_from"
    
    static let KCampfireVideoLike           =   "add_campfirvideo_like"
    static let KCampfireVideoDisLike        =   "delete_campfirvideo_like"
    static let KRecentVideos           =    "getall_watched_videos"
    
    static let KCampStaff             =   "getpage_details"
    static let KCampFire              =   "get_campfire_data_IPAD"
    static let KCampUserDetails       =   "get_users"
    static let KCampfireUploadVideo       =  "uploadcampfire_video"
    static let KCampfireUploadContest     =   "uploadcampfire_context"
    
    //  static let KGoogleKey             =   ""
    static let KMapProvideAPIKey      =   ""
    static let KGetGoogleAddress      =   "https://maps.googleapis.com/maps/api/geocode/json"
    
    
    static let KVideosThumbURL        =   "\(String(describing: bucketURL(server: KServerUrl)!))/videos/images/"   // URL of thumbs of category items
    static let KVideoURl              =   "\(String(describing: bucketURL(server: KServerUrl)!))/videos/videos/"   // URL of Videos of category video
    static let KAvertisementBannerUrl =   "\(String(describing: bucketURL(server: KServerUrl)!))/new_atise/"   //advertisement   // URL of advertisements
    static let KAviatorBlue           =   "\(String(describing: bucketURL(server: KServerUrl)!))/avator/blue/"
    static let KAviatorGreen          =   "\(String(describing: bucketURL(server: KServerUrl)!))/avator/green/"
    static let KBannerVideo          =   "\(String(describing: bucketURL(server: KServerUrl)!))/banner/video/"
    static let KContestImage         =   "\(String(describing: bucketURL(server: KServerUrl)!))/contest/images/"
    static let KContestVideo       =   "\(String(describing: bucketURL(server: KServerUrl)!))/contest/videos/"
    
    static let KCoinProduct           =   "\(String(describing: bucketURL(server: KServerUrl)!))/coinsproduct/"
    static let KFavCompressImage           =   "\(String(describing: bucketURL(server: KServerUrl)!))/camps/compressImg/"
    
    
    static let KCampfireVideoUrl      =   "\(String(describing: bucketURL(server: KServerUrl)!))/user_video_uploads/" // Main folder to upload user videos
    static let KCampfireVideoThum     =   "\(String(describing: bucketURL(server: KServerUrl)!))/user_video_uploads/thumbs/"
    static let KCampfireDaycamper     =   "\(String(describing: bucketURL(server: KServerUrl)!))/daycamper/"
    static let KCamperContestImage    =   "\(String(describing: bucketURL(server: KServerUrl)!))/contest_uploads/images/"
    static let KCamperContestVideoUrl =   "\(String(describing: bucketURL(server: KServerUrl)!))/contest_uploads/videos/"
    
    static let KCategoryImage         =   "\(String(describing: bucketURL(server: KServerUrl)!))/category/images/"
    static let KCategoryVideo         =   "\(String(describing: bucketURL(server: KServerUrl)!))/category/videos/"
    
    static let KTrainerImage          =   "\(String(describing: bucketURL(server: KServerUrl)!))/trainer/images/"
    static let KTrainerVideo          =   "\(String(describing: bucketURL(server: KServerUrl)!))/trainer/videos/"
    
    static let KBannerUrl             =   "\(String(describing: bucketURL(server: KServerUrl)!))/camps/banners/"
    static let KBannerLogo            =   "\(String(describing: bucketURL(server: KServerUrl)!))/camps/logos/"
    static let KCampVideoUrl          =   "\(String(describing: bucketURL(server: KServerUrl)!))/camps/videos/"
    static let KCampBannerUrl         =   "\(String(describing: bucketURL(server: KServerUrl)!))/camps/videos"
    //static let KCampTestUrl         =   "https://s3.amazonaws.com/happycamperlive/testBucketfolder/"
    static let KCampTestUrl           =   "https://s3.amazonaws.com/happycamperlive/camps/compressImg/"
}

enum ServerResponse {
    static let SUCCESS = 200
    static let FAILED = 1000
}

enum StoryboardChnage{
    public static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    public static let iPhoneStoryboard = UIStoryboard(name: "iPhone", bundle: nil)
    
}

// Enum Alert customer
enum AlertValue {
    static var name                   = "Please enter Name"
    static var firstname              = "Please enter first name"
    static var validName              = "Please enter Valid Name"
    static var validLastName              = "Please enter valid last name"
    static var lastName               = "Please enter last name"
    static var password               = "Please enter password"
    static var childName              = "Please enter child name"
    static var childAge               = "Please enter child age"
    static var phoneNumber            = "Please enter phone number"
    static var validPhoneNumber       = "Please enter valid phone number"
    static var country                = "Please enter country"
    static var EnterQuery             = "Please enter Query"
    
    static var validEmail             = "Please enter valid Email"
    static var email                  = "Please enter email"
    static var subject                = "Please enter subject"
    static var validPassword          = "Please enter valid password"
    static var passwordNotMatch       = "Password does not matches"
    static var Msg                    = "Please enter message"
    static var zipCode                = "Please enter zip code"
    static var Address                = "Please enter address"
    static var state                  = "Please enter state"
    static var city                   = "Please enter city"
    static var oldPassword            = "Please enter old password"
    static var alertMsg               = "Logout successfully"
    static var search                 = "Please enter search"
    
    static var login                  = "Please Signin before"
    
    // status handler and network values
    static var pleaseReviewyournetworksettings = "Please Review your network settings"
    static var ErrorUnabletoencodeJSONResponse = "Error: Unable to encode JSON Response"
    static var urlError = "Please check the URL : 400"
    static var sessionError = "Session Logged out"
    static var urlNotExist = "URL does not exists : 404"
    static var UnauthorizedactionError = "Unauthorized to perform this action : 401"
    static var serverError = "Server error, Please try again.."
}
