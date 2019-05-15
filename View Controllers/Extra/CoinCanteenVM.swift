//
// CoinCanteenVM.swift
// HappyCamper
//
// Created by wegile on 01/03/19.
// Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SafariServices


var advertisment = [NSDictionary]()


class CoinCanteenVM {
    
    var currentPage = Int()
    var searchString = String()
    var CanteenModelAry = [CanteenModel]()
    var advertiementAry = NSMutableArray()
    var arr_spinText = NSMutableArray()

    
    func postCoinCanteenApi(_ completion:@escaping() -> Void){
        
        let param = [
            "page_no":"\(currentPage + 1)",
            "page_size": "\(10)",
            "form_search_key":"\(searchString)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCanteenCoin)", params: param, showIndicator: true, completion: { (JSON) in
            
            var appResponse = Int()
            
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                
                self.advertiementAry = []
                advertisment = []
                
                let fullwidth_advts = JSON["advts_in_listing"] as! [NSDictionary]
                advertisment = fullwidth_advts

                let objModel = CanteenModel()
                objModel.dictAdData(dictarr: fullwidth_advts)
                
                let CanteenModelObj = CanteenModel()
                if let canteenCoinAry = JSON["results"] as? NSArray {
                    if canteenCoinAry.count > 0 {
                        CanteenModelObj.dictCoinData(dictarr: canteenCoinAry as! [NSDictionary])
                        self.CanteenModelAry.append(CanteenModelObj)

                        // coinArr.append(CanteenModelObj)
                        
                        /* for i in 0..<canteenCoinAry.count {
                         if let canteenDict = canteenCoinAry[i] as? NSDictionary {
                         let CanteenModelObj = CanteenModel()
                         CanteenModelObj.dictData(dict : canteenDict)
                         coinArr.append(CanteenModelObj)
                         // self.CanteenModelAry.append(CanteenModelObj)
                         //self.CanteenModelAry.append(CanteenModelObj)
                         }
                         }*/
                    }
                }
                
                if let spinTxt = JSON["spintxt"] as? NSArray {
                    self.arr_spinText = spinTxt.mutableCopy() as! NSMutableArray
                }
                
                
                if fullwidth_advts.count > 0 {
                    self.CanteenModelAry.append(objModel)
                }
                completion()
            }
            Proxy.shared.hideActivityIndicator()
            
        })
    }
}

//MARK:- UITableView delegates and Data sources
extension CoinCanteenVC :UITableViewDelegate,UITableViewDataSource,didselectAdvertisementDelegte,didselectCoin {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CoinCanteenVMObj.CanteenModelAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = CoinCanteenVMObj.CanteenModelAry[indexPath.row]
        
        if obj.type == "Coin" {
            let cell = tblAdcoinVC.dequeueReusableCell(withIdentifier: "canteen_add_cell", for: indexPath) as! AdCoinTVC
            
            cell.delegateCoin = self
            cell.coinArr = obj.coinArr
            cell.CanteenModelAry = CoinCanteenVMObj.CanteenModelAry
            cell.colVwCoinReload()
            return cell
        } else {
            let cell = tblAdcoinVC.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdCoinTVC
            
            cell.adArr = obj.ads
            cell.delegate = self
            cell.colVwAdsReload()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let obj = CoinCanteenVMObj.CanteenModelAry[indexPath.row]
        if UIDevice.current.userInterfaceIdiom == .pad{

        if obj.type == "Coin"
        {
            if obj.coinArr.count % 3 == 0
            {
                if obj.coinArr.count == 3
                {
                    return 425.0
                }
                let ques = obj.coinArr.count/3
                return CGFloat((ques*405) + 20)
                //return CGFloat((obj.coinArr.count * 405) + 20)
            }
            else
            {
                if obj.coinArr.count > 0
                {
                    //let count = obj.coinArr.count - 1
                    //return CGFloat((count * 405) + 20)
                    let ques = obj.coinArr.count/3
                    return CGFloat((ques+1)*405) + 20.0
                }
                else
                {
                    return 405.0
                }
            }
        }
        else
        {
            return 400
        }
        } else {
            //Devansh
            if obj.type == "Coin"{
                return UIScreen.main.bounds.height
            }else{
                return UIScreen.main.bounds.height/3
            }
        }
    }
    
    
    func didselectCoin(data: coinModel) {
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
        //Devansh
        var nav = CheckOutVC()
        if UIDevice.current.userInterfaceIdiom == .phone{
            nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
        }else{
            nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
        }
        nav.ImagAry = data.imgArr as NSArray
        nav.coinObj = data
//        nav.CanteenModelAry = [CoinCanteenVMObj.CanteenModelAry[sender.tag]]
        self.navigationController?.pushViewController(nav, animated: true)
        
    }
    /*
     //MARK:--> TABLE VIEW DELEGATE
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return CoinCanteenVMObj.CanteenModelAry.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
     
     let cell = colVw.dequeueReusableCell(withReuseIdentifier: "CoinCanteenCVC", for: indexPath) as! CoinCanteenCVC
     if CoinCanteenVMObj.CanteenModelAry.count != 0 {
     let CanteenModelAryObj = CoinCanteenVMObj.CanteenModelAry[indexPath.item]
     cell.lblCoins.text! = "\(CanteenModelAryObj.coins)"
     cell.lblTitle.text! = CanteenModelAryObj.title
     cell.lblDescriptions.text! = CanteenModelAryObj.description
     
     cell.btnBuyNow.tag = indexPath.row
     cell.btnBuyNow.addTarget(self, action: #selector(buttonPurchaseNow), for: .touchUpInside)
     
     cell.ImageAry = CanteenModelAryObj.imageAry
     }
     cell.collVwReload()
     
     return cell
     
     
     }*/
    
    //MARK:--> BUTTTON PURCHASE NOW
    @objc func buttonPurchaseNow(sender: UIButton) {
        // var CanteenModelAry = [CanteenModel]()
        let CanteenModelAryObj = CoinCanteenVMObj.CanteenModelAry[sender.tag]
        
        let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
        nav.ImagAry = CanteenModelAryObj.imageArr as NSArray
        nav.CanteenModelAry = [CoinCanteenVMObj.CanteenModelAry[sender.tag]]
        self.navigationController?.pushViewController(nav, animated: true)
        
    }
    
    func didselectAdvertisement(adUrl: String) {
        let svc = SFSafariViewController(url: NSURL(string: adUrl)! as URL)
        self.present(svc, animated: true, completion: nil)
    }
    
    func didOpenVideo(status: Bool)
    {
        
    }
    
}


//varinder10
//MARK:- Handle Side menu actions
extension CoinCanteenVC: GuestLandingPageVCSideMenuDelegate {
    
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

