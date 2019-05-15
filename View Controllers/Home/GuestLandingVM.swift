//
//  GuestLandingVM.swift
//  HappyCamper
//
//  Created by wegile on 24/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import SafariServices
import SwiftyJSON

class GuestLandingPageCVC: UICollectionViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.2, y: 1.2) : CGAffineTransform.identity
            }, completion: nil)
        }
    }
}

class GuestLandingPageAdCell: UICollectionViewCell {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var tap_btn: UIButton!
    @IBOutlet weak var left_btn: UIButton!
    @IBOutlet weak var right_btn: UIButton!
    
}

class AdvertisementCVC: UICollectionViewCell {
    @IBOutlet weak var img_AdBanner: UIImageView!
    @IBOutlet weak var btn_OpenAd: UIButton!
    
}

class GuestLandingVM {
    
    //MARK:--> VARIABLES
    var advertiementAry = NSMutableArray()
    let htp = "home"
    
    var CategoryModelAry = [CategoryModel]()
    var BannerModelAry   = [BannerModel]()
    var AdvertisementModelAry = [AdvertisementModel]()
    var arr_Counselors   = [NSDictionary]()
    
    //MARK:--> GET HOME SCREEN API
    func postHomeScreenApi(completionHandler: @escaping CompletionHandler) {
        
        let param = [
            "page_type":"\(htp)",
            "user_id" : "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postDataForHome("\(Apis.KServerUrl)\(Apis.KHomeScreenApi)", params: param, showIndicator: true, completion: { (JSON) in
            
            var appResponse = Int()
            
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                
                if let arr_Counselors =  JSON["counsolers"] as? NSArray {
                    if arr_Counselors.count > 0 {
                        for i in 0..<arr_Counselors.count {
                            if let dict_Coun = arr_Counselors[i] as? NSDictionary {
                                self.arr_Counselors.append(["counselor":dict_Coun["counselor"] as! String,"name":dict_Coun["name"] as! String,"activity":dict_Coun["activity"] as! String,"image":dict_Coun["image"] as! String,"description":dict_Coun["description"] as! String,"url_key":dict_Coun["url_key"] as! String  ,"credential":dict_Coun["credential"] as! String  ,"title":dict_Coun["title"] as! String ,"fun_fact":dict_Coun["fun_fact"] as! NSArray])
                            }
                        }
                    }
                }
                
                if let dictResAry = JSON["results"] as? NSArray {
                    
                    let fullwidth_advts = JSON["fullwidth_advts"] as! [NSDictionary]
                    
                    let fullwidth_small_height_advts = JSON["fullwidth_small_height_advts"] as! [NSDictionary]
                    
                    if (JSON["advertisements"] as? NSArray) != nil { //advertisementAry
                        // advertisementData = JSON["advertisements"] as! [NSDictionary]
                        
                        /* if advertisementAry.count > 0 {
                         for i in 0..<advertisementAry.count {
                         if let bnrDict = advertisementAry[i] as? NSDictionary {
                         let advertisementModelObj = AdvertisementModel()
                         advertisementModelObj.dictData(dict: bnrDict)
                         self.AdvertisementModelAry.append(advertisementModelObj)
                         }
                         }
                         }*/
                    }
                    
                    self.CategoryModelAry.removeAll()
                    self.advertiementAry = []
                    if dictResAry.count > 0 {
                        for i in 0..<dictResAry.count {
                            if let bnrDict = dictResAry[i] as? NSDictionary {
                                let CategoryModelObj = CategoryModel()
                                CategoryModelObj.dictData(data: bnrDict)
                                self.CategoryModelAry.append(CategoryModelObj)
                            }
                        }
                        let CategoryModelObj = CategoryModel()
                        CategoryModelObj.header_type = "Advertisement"
                        CategoryModelObj.advertisment = fullwidth_advts
                        self.CategoryModelAry.insert(CategoryModelObj, at: 2)
                        
                        let small_ad = CategoryModel()
                        small_ad.header_type = "Advertisement"
                        small_ad.advertisment = fullwidth_small_height_advts
                        
                        self.CategoryModelAry.insert(small_ad, at: 5)
                    }
                }
                
                if let dict_Banner = JSON["banner_text"] as? NSDictionary {
                    
                    if dict_Banner.count > 0 {
                        for _ in 0..<dict_Banner.count {
                            //                            if let banner_String = dict_Banner[i] as? NSDictionary {
                            let dict_AfterLogin = ["banner_text_1":dict_Banner["banner_text_1"]!,
                                                   "banner_text_2":dict_Banner["banner_text_2"]!,
                                                   "banner_text_3":dict_Banner["banner_text_3"]!,
                                                   "banner_text_4":dict_Banner["banner_text_4"]!,
                                                   "banner_text_5":dict_Banner["banner_text_5"]!]
                            
                            let dict_BeforeLogin =
                                ["text_before_login_1":dict_Banner["text_before_login_1"]!,
                                 "text_before_login_2":dict_Banner["text_before_login_2"]!,
                                 "text_before_login_3":dict_Banner["text_before_login_3"]!,
                                 "text_before_login_4":dict_Banner["text_before_login_4"]!,
                                 "text_before_login_5":dict_Banner["text_before_login_5"]!,
                                 ]
                            UserDefaults.standard.set(dict_AfterLogin, forKey: "BannerTextAfterLogin")
                            UserDefaults.standard.set(dict_BeforeLogin, forKey: "BannerTextBeforeLogin")
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
                
                if let dictBanAry =  JSON["featured_items"] as? NSArray {
                    if dictBanAry.count > 0 {
                        for i in 0..<dictBanAry.count {
                            if let bnrDict = dictBanAry[i] as? NSDictionary {
                                let bannerModelObj = BannerModel()
                                bannerModelObj.getBannerDetail(dict: bnrDict)
                                self.BannerModelAry.append(bannerModelObj)
                            }
                        }
                    }
                }
                
                if (JSON["socialLinks"] as? NSDictionary) != nil {
                    UserDefaults.standard.setValue(JSON["socialLinks"], forKey: "Social_Links")
                }
                
                if let userDetails = JSON["userdetails"] as? NSDictionary {
                    UserDefaults.standard.set(userDetails["coins"] as! Int, forKey: "User_Coins")
                }
                
                KAppDelegate.checkAuthcode()
                if Proxy.shared.authNil() != "" {
                    KAppDelegate.checkApiMethodWithoutNotification {  }
                }
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }
}


extension GuestLandingPageVC: UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,didselectAdvertisementDelegte,didSelectUserCastScreen {
    func selectUserCast(object: CastDictModel, users_array: [CastDictModel],selected_index:Int) {
        let nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "CastScreenVC") as! CastScreenVC
        
        //        let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "CastScreenVC") as! CastScreenVC
        nav.arr_CastUsers = users_array
        nav.selectedUserIndex = selected_index
        nav.castDescription = object.castDescription
        nav.castImage = object.castImage
        nav.castName  = object.castName
        nav.castActivity  = object.castActivity
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    
    //MARK:--> COLLECTION VIEW DELEGATE FUNCTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guestLandingVMObj.BannerModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = colVwBanner.dequeueReusableCell(withReuseIdentifier: "GuestLandingPageCVC", for: indexPath) as! GuestLandingPageCVC
        if guestLandingVMObj.BannerModelAry.count != 0 {
            let BannerModelAryObj = guestLandingVMObj.BannerModelAry[indexPath.row]
            
            cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(BannerModelAryObj.bannerVideoImgThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            cell.lblTitle.text = BannerModelAryObj.bannerVideoTitle
            
            //Devansh
            if UIDevice.current.userInterfaceIdiom != .pad {
                cell.imgVw.layer.borderWidth = 1.5
                cell.imgVw.layer.borderColor = UIColor.white.cgColor
            }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bannerModelAryObj = guestLandingVMObj.BannerModelAry[indexPath.row]
        
        //        let string =  bannerModelAryObj.videoDescription
        //        lblDescription.text! = string.htmlToString
        
        //        lblTitle.text! = bannerModelAryObj.bannerVideoTitle
        playCount = indexPath.row
        videoPlayerPlay(Url: bannerModelAryObj.videoPlayLink, thumbURL:URL.init(string: "\(Apis.KVideosThumbURL)\(bannerModelAryObj.bannerVideoImgThumb)"))
        
    }
    
    //MARK:--> TABLE VIEW CONTROLLER
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return guestLandingVMObj.CategoryModelAry.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellMain = UITableViewCell()
        if indexPath.section == 0 {
            if tableView == tblVwMain {
                
                let CategoryModelAryObj = guestLandingVMObj.CategoryModelAry[indexPath.row]
                let cell = tblVwMain.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GuestLandingTVC
                
                if CategoryModelAryObj.header_type == "Video"
                {
                    cell.VwBanners.isHidden = false
                    cell.VwAds.isHidden = true
                    cell.collectionType = "Videos"
                    cell.delegate = self
                    cell.currentCont = self
                    cell.lblHeaderTitle.text = CategoryModelAryObj.headerCategoryName
                    
                    cell.GuestLandingModelAry = guestLandingVMObj.CategoryModelAry[indexPath.row].headerVideos
                    
                    
                    if guestLandingVMObj.CategoryModelAry[indexPath.row].headerVideos.count == 0
                    {
                        cell.btnRightAction.isHidden = true
                        cell.btnLeftAction.isHidden = true
                    }
                    else
                    {
                        cell.btnRightAction.isHidden = true
                        cell.btnLeftAction.isHidden = true
                    }
                    
                    cell.btnLeftAction.tag = indexPath.row
                    cell.colVw.tag = indexPath.row
                    cell.colVwReload()
                    
                } else {
                    
                    if indexPath.row == 2 {
                        cell.rowSize = 400.0
                    }
                    
                    if indexPath.row == 5 {
                        cell.rowSize = 250.0
                    }
                    cell.delegate = self
                    cell.VwAds.isHidden = false
                    cell.VwBanners.isHidden = true
                    cell.collectionType = "ads"
                    cell.AdvertisementAry = CategoryModelAryObj.advertisment
                    cell.colVwAdsReload()
                    
                    if CategoryModelAryObj.advertisment.count == 0 {
                        cell.btnRightAction.isHidden = true
                        cell.btnLeftAction.isHidden = true
                    } else {
                        cell.btnRightAction.isHidden = true
                        cell.btnLeftAction.isHidden = true
                    }
                }
                
                cell.btnLeftAction.addTarget(self, action: #selector(leftSlideAction(_:)), for: .touchUpInside)
                cell.btnRightAction.tag = indexPath.row
                cell.btnRightAction.addTarget(self, action: #selector(rightSlideAction(_:)), for: .touchUpInside)
                
                cell.btnViewAll.tag = indexPath.row
                cell.btnViewAll.addTarget(self, action: #selector(btnViewAllAction), for: .touchUpInside)
                cellMain = cell
            }
            return cellMain
            
        } else {
            let cell = tblVwMain.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GuestLandingCounselorTVC
            cell.delegate_Counselor=self
            cell.arr_Counselors = self.guestLandingVMObj.arr_Counselors
            cell.colVwReload()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            if indexPath.row == 2 || indexPath.row == 5 {
                if indexPath.row == 5 {
                    return 250.0
                }
                return 340
            } else {
                return 300
            }
            
        } else {
            
            if indexPath.row == 2 || indexPath.row == 5 {
                if indexPath.row == 5 {
                    return 170.0
                }
                return 210
            }  else {
                if indexPath.section == 0 {
                    return 215
                } else {
                    return 235
                }
            }
        }
    }
    
    private func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {    return 0.00001   }
    
    @objc func leftSlideAction(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell: GuestLandingTVC = tblVwMain.cellForRow(at: indexPath) as! GuestLandingTVC
        //SubCategoryDetailCVC
        let collectionBounds = cell.colVw.bounds
        let contentOffset = CGFloat(floor(cell.colVw.contentOffset.x - collectionBounds.size.width))
        
        let frame: CGRect = CGRect(x : contentOffset ,y : cell.colVw.contentOffset.y ,width : cell.colVw.frame.width,height : cell.colVw.frame.height)
        cell.colVw.scrollRectToVisible(frame, animated: true)
        
    }
    
    @objc func rightSlideAction(_ sender: UIButton)  {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell: GuestLandingTVC = tblVwMain.cellForRow(at: indexPath) as! GuestLandingTVC
        
        let collectionBounds = cell.colVw.bounds
        let contentOffset = CGFloat(floor(cell.colVw.contentOffset.x + collectionBounds.size.width))
        
        let frame: CGRect = CGRect(x : contentOffset ,y : cell.colVw.contentOffset.y ,width : cell.colVw.frame.width,height : cell.colVw.frame.height)
        cell.colVw.scrollRectToVisible(frame, animated: true)
        
    }
    
    //MARK:--> VIEW ALL BUTTON ACTION
    @objc func btnViewAllAction(sender: UIButton) {
        
        if guestLandingVMObj.CategoryModelAry.count > 0 {
            let catModelObj = guestLandingVMObj.CategoryModelAry[sender.tag]
            if catModelObj.headerCategoryName == "WEB SERIES" {
                Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
            } else {
                let nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "SubCategoriesVideoVC") as! SubCategoriesVideoVC
                nav.SubCategoriesVideoVMObj.headerTitleUrl = catModelObj.headerCategoryUrl
                self.navigationController?.pushViewController(nav, animated: true)
            }
        }
    }
    
    func didselectAdvertisement(adUrl: String) {
        
        let svc = SFSafariViewController(url: NSURL(string: adUrl)! as URL)
        self.present(svc, animated: true, completion: nil)
        
    }
    
    func didOpenVideo(status: Bool) {
        if status {
            if self.playerController != nil {
                self.player!.pause()
            }
        }
    }
    
}

//MARK:- Handle Side menu actions
extension GuestLandingPageVC: GuestLandingPageVCSideMenuDelegate {
    
    func didSelectSideMenu(itemNum : Int) {
        
        switch (itemNum){
        //varinder8
        case (0):
            //live
            self.tabBarController?.selectedIndex = 0
//            Proxy.shared.pushToNextVC(identifier: "GuestLandingPageVC", isAnimate: true, currentViewController: self)
            break
        case (1):
            //live
            break
        case (2):
            //Web Serise
            Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
            break
        case (3):
            //360
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "360"
            nav.comeFromSideMenu = true
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (4):
            //store
            break
        case (5):
            //camp fire
            Proxy.shared.pushToNextVC(identifier: "CampfireVC", isAnimate: true, currentViewController: self)
            break
        case (6):
            //camp staff
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.comeFromSideMenu = true
            nav.fromCont = "CampStaff"
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (7):
            //community
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Community"
            nav.comeFromSideMenu = true
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (8):
            //faq
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "FAQs"
            nav.comeFromSideMenu = true
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (9):
            //contact us
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.comeFromSideMenu = true
            nav.fromCont = "ContactUs"
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (10):
            //terms and conditions
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.comeFromSideMenu = true
            nav.fromCont = "Terms & Conditions"
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (11):
            //privacy policy
            let nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.comeFromSideMenu = true
            nav.fromCont = "Privacy Policies"
            self.navigationController?.pushViewController(nav, animated: true)
            break
        case (12):
            //Invite Freinds
            Proxy.shared.pushToNextVC(identifier: "InviteAFriendVC", isAnimate: true, currentViewController: self)
            break
        case (13):
            //Join Camp
            Proxy.shared.pushToNextVC(identifier: "JoinOurTeamVC", isAnimate: true, currentViewController: self)
            break
        default:
            break
        }
    }
}
