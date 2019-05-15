//
//  NearMeCampVM.swift
//  HappyCamper
//
//  Created by wegile on 11/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
class NearMeCampVM  {
    
    var videoType = String()
    var currentPage = 1
    var pageSize = 10
    var SearchKeyString = String()
    var arraytotalItems = NSArray()
    
    var CampListModelAry = [CampListModel]()
    
    //MARK:--> SIGN UP API FUNCTION
    func getCampListApi(_ completion:@escaping() -> Void) {
        let param = [
            "page_no"         : "\(currentPage)",
            "page_size"       : "\(pageSize)",
            "form_search_key" : "\(SearchKeyString)"
            ] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCamplist)", params: param, showIndicator: true, completion: { (JSON) in
            var appResponse = Int()
            
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                
                if let resultAry = JSON["results"] as? NSArray {
                    self.arraytotalItems = resultAry
                    if resultAry.count > 0 {
                        for i in 0..<resultAry.count {
                            if let videoDict = resultAry[i] as? NSDictionary {
                                let CampListModelObj = CampListModel()
                                CampListModelObj.userItemDict(dict: videoDict)
                                self.CampListModelAry.append(CampListModelObj)
                            }
                        }
                    }
                }
                completion()
            }else{
                self.arraytotalItems = NSArray()
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    //MARK:- Pagination APi
    func getCampListApi12(_pagenumber:Int,completion:@escaping() -> Void) {
        let param = [
            "page_no"         : "\(_pagenumber)",
            "page_size"       : "\(pageSize)",
            "form_search_key" : "\(SearchKeyString)"
            ] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCamplist)", params: param, showIndicator: true, completion: { (JSON) in
            var appResponse = Int()
            
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                
                if let resultAry = JSON["results"] as? NSArray {
                    self.arraytotalItems = resultAry
                    if resultAry.count > 0 {
                        for i in 0..<resultAry.count {
                            if let videoDict = resultAry[i] as? NSDictionary {
                                let CampListModelObj = CampListModel()
                                CampListModelObj.userItemDict(dict: videoDict)
                                self.CampListModelAry.append(CampListModelObj)
                            }
                        }
                    }
                }
                completion()
            }else{
                self.arraytotalItems = NSArray()
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
}

extension NearMeCampsVC : UITableViewDataSource, UITableViewDelegate , UICollectionViewDelegate, UICollectionViewDataSource{
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variableConst.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "NearMeCampCVC", for: indexPath) as! NearMeCampCVC
        cell.lblTitle.text = variableConst[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let variableCons = variableConst[indexPath.item]
        txtFldSearchCamp.text = ""
        NearMeCampVMObj.SearchKeyString = variableCons
        getCampApi()
    }
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NearMeCampVMObj.CampListModelAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "NearMeCampTVC", for: indexPath) as! NearMeCampTVC
        
        if NearMeCampVMObj.CampListModelAry.count != 0 {
            
            tableView.tableFooterView?.isHidden = true
            
            let CampListModelObj = NearMeCampVMObj.CampListModelAry[indexPath.row]
            cell.lblCampName.text = CampListModelObj.campTitle
            
            if CampListModelObj.campAddress != "" {
                cell.lblAddress.text = CampListModelObj.campAddress
                cell.imgVwBanner.isHidden = false
            } else {
                cell.imgVwBanner.isHidden = true
            }
            
            DispatchQueue.main.async {
                cell.imgVwBanner.sd_setImage(with: URL.init(string: "\(Apis.KCampTestUrl)\(CampListModelObj.arr_campBannerImg[0].stringValue)"),placeholderImage: nil, completed: nil)
            }

            /*
             if CampListModelObj.campShortDesc != "Blank" {
             cell.lblDescription.isHidden = false
             let string =  CampListModelObj.campShortDesc
             cell.lblDescription.text! = string.htmlToString
             } else{
             cell.lblDescription.text = ""
             cell.lblDescription.isHidden = true
             }
             */
            
            cell.btnLearnMore.tag = indexPath.row
            cell.btnLearnMore.addTarget(self, action: #selector(btnLearnMoreAction), for: .touchUpInside)
            
            cell.btnRequestInfo.tag =  indexPath.row
            cell.btnRequestInfo.addTarget(self, action: #selector(btnRequestAction), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 420
        } else {
            return UIScreen.main.bounds.height/3
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //        let lastSectionIndex = tableView.numberOfSections - 1
        //        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        //        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
        //
        //            // print("this is the last cell")
        //            let spinner = UIActivityIndicatorView(style: .gray)
        //            spinner.style = UIActivityIndicatorView.Style.whiteLarge
        //            spinner.color = UIColor.black
        //
        //            spinner.startAnimating()
        //            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblVw.bounds.width, height: CGFloat(60))
        //
        //            self.tblVw.tableFooterView = spinner
        //            self.tblVw.tableFooterView?.isHidden = false
        //        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == self.tblVw {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                
                if Isscrollpage == false {
                    if NearMeCampVMObj.arraytotalItems.count > 0{
                        
                        self.page += 1
                        Isscrollpage = true
                        
                        let spinner = UIActivityIndicatorView(style: .gray)
                        spinner.style = UIActivityIndicatorView.Style.whiteLarge
                        spinner.color = UIColor.black
                        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
                        
                        spinner.startAnimating()
                        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblVw.bounds.width, height: CGFloat(44))
                        
                        self.tblVw.tableFooterView = spinner
                        self.tblVw.tableFooterView?.isHidden = false
                        //Pagination APi Call
                        self.getCampApipagination(count: self.page)
                    }
                }
            }
        }
    }
    
    //MARK:--> LEARN MORE ACTON
    @objc func btnLearnMoreAction(sender: UIButton) {
        
        //Devansh
        if NearMeCampVMObj.CampListModelAry.count != 0 {
            
            let CampListModelObj = NearMeCampVMObj.CampListModelAry[sender.tag]
            var nav = CampDetailVC()
            
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "CampDetailVC") as! CampDetailVC
            } else {
                nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "CampDetailVC") as! CampDetailVC
            }
            nav.CampDetailVMObj.campId = CampListModelObj.campId
            self.navigationController?.pushViewController(nav, animated: true)
        }
    }
    
    //MARK:--> REQUEST
    @objc func btnRequestAction(sender: UIButton) {
        //Devansh
        if NearMeCampVMObj.CampListModelAry.count != 0 {
            let CampListModelObj = NearMeCampVMObj.CampListModelAry[sender.tag]
            var nav = PopEnterInformationVC()
            if (UIDevice.current.userInterfaceIdiom == .pad){
                nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "PopEnterInformationVC") as! PopEnterInformationVC
            }else{
                nav = StoryboardChnage.iPhoneStoryboard.instantiateViewController(withIdentifier: "PopEnterInformationVC") as! PopEnterInformationVC
            }
            nav.userCampId  = CampListModelObj.campId
            self.present(nav, animated: true, completion: nil)
        }
    }
}

//varinder10
//MARK:- Handle Side menu actions
extension NearMeCampsVC: GuestLandingPageVCSideMenuDelegate {
    
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
