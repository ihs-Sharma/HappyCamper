//
//  RecentVideosVC.swift
//  HappyCamper
//
//  Created by wegile on 11/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class RecentVideoCVC: UICollectionViewCell {
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
}

class RecentVideosVC: UIViewController, SelectMenuOption ,SelectAviatorImage,TopHeaderViewDelegate {
    
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var targetVw: UIView!
    
    //MARK:--> VARIABLES
    var viewController : MenuDrawerController?
    var fromCont = String()
    var delegate : didselectAdvertisementDelegte?
    
    //Api Model Variables
    var currentPage = Int()
    var pageSize = 10
    var ResultModelAry = [ResultModel]()
    
    func setBackToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- Select Options
    func selectOptionByName(name: String!) {
        switch name {
        case "live":
            //            Proxy.shared.pushToNextVC(identifier: "CampDetailVC", isAnimate: true, currentViewController: self)
            break
        case "series":
            Proxy.shared.pushToNextVC(identifier: "WebSeriesVC", isAnimate: true, currentViewController: self)
            break
        case "360":
            let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "HCStaticLinkVC") as! HCStaticLinkVC
            vc.str_URL = Apis.K360Camp
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "campFire":
            Proxy.shared.pushToNextVC(identifier: "CampfireVC", isAnimate: true, currentViewController: self)
            break
        case "store":
            break
        case "profilePic":
            Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: false, currentViewController: self)
            break
        case "Options":
            if targetVw.isHidden == true {
                targetVw.isHidden = false
            }else{
                targetVw.isHidden = true
            }
            break
        case "SignIn":
            Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
            break
        case "getAccess":
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            break
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            targetVw.isHidden = true
            SelectAviatorImageObj = self
            viewController = (StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "MenuDrawerController") as! MenuDrawerController)
            viewController?.delegate = self
            
            targetVw.addSubview(viewController!.view)
            viewController?.tblVw.delegate = viewController
            viewController?.tblVw.dataSource = viewController
        } else {
            self.navigationController?.navigationBar.topItem?.title  = "RECENTLY WATCHED VIDEOS"
        }
        self.ResultModelAry = []
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            self.postFavVideosApi {
                self.colVw.delegate = self
                self.colVw.dataSource = self
                
                self.collectionSetViewLayout()
                
                self.colVw.reloadData()
            }
        } else {
            Proxy.shared.presentAlert(withTitle: "", message: "Please Login", currentViewController: self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            headerDelegate = self
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
            
            targetVw.isHidden = true
        }
    }
    
    func collectionSetViewLayout(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.itemSize = CGSize(width: self.colVw.frame.width/3, height: self.colVw.frame.width/3.5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        self.colVw!.collectionViewLayout = layout
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.collectionSetViewLayout()
        }
        
    }
    
    @IBAction func bntMenuAction(_ sender: Any) {
        if targetVw.isHidden == true{
            targetVw.isHidden = false
        }else{
            targetVw.isHidden = true
        }
    }
    
    
    //MARK:--> PROTOCOL FUNCTIONS
    func didSelected(index: Int) {
        if index == 0 {
            targetVw.isHidden = true
        } else if index == 1 {
            let auth = Proxy.shared.authNil()
            if auth != ""{
                Proxy.shared.pushToNextVC(identifier: "ProfileVC", isAnimate: true, currentViewController: self)
            } else{
                Proxy.shared.presentAlert(withTitle: "", message: "\(AlertValue.login)", currentViewController: self)
            }
        }else if index == 2 {
            Proxy.shared.pushToNextVC(identifier: "CamperStaffVC", isAnimate: true, currentViewController: self)
        }
        else if index == 3 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Community"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 4 {
            let auth = Proxy.shared.authNil()
            if auth != ""{
                Proxy.shared.pushToNextVC(identifier: "InviteAFriendVC", isAnimate: true, currentViewController: self)
            } else {
                Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            }
        } else if index == 5 {
            let vc = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "HCStaticLinkVC") as! HCStaticLinkVC
            vc.str_URL = Apis.KBlog
            self.navigationController?.pushViewController(vc, animated: true)
        } else if index == 6 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "FAQs"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 7 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "ContactUs"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 8 {
            Proxy.shared.pushToNextVC(identifier: "JoinOurTeamVC", isAnimate: true, currentViewController: self)
        } else if index == 9 {
            // Register Camp
        }else if index == 10 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Terms & Conditions"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 11 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Privacy Policies"
            self.navigationController?.pushViewController(nav, animated: true)
        } else if index == 12 {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            nav.fromCont = "Disclaimer"
            self.navigationController?.pushViewController(nav, animated: true)
        } else  if index == 101 {
            Proxy.shared.pushToNextVC(identifier: "CoinCanteenVC", isAnimate: true, currentViewController: self)
        } else {
            Proxy.shared.rootWithoutDrawer("TabbarViewController")
        }
        
    }
    
    @IBAction func btnToggleAction(_ sender: Any) {
        Proxy.shared.presentToVC(identifier: "SelectColorVC", isAnimate: false, currentViewController: self)
    }
    //MARK:--> PROTOCOAL FUNCTION
    func selectedImage(index: Int) {
        viewWillAppear(false)
    }
}

extension RecentVideosVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK:--> COLLECTION VIEW DELEGATE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ResultModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "RecentVideoCVC", for: indexPath) as! RecentVideoCVC
        
        let ResultModelAryObj = self.ResultModelAry[indexPath.row]
        
        if self.ResultModelAry.count != 0 {
            //            cell.lblTitle.text = ResultModelAryObj.videoShortTitle
            //
            //            let string = ResultModelAryObj.videoShortDescription
            //
            //            if string == ""{
            //                //new
            //                let string = ResultModelAryObj.videoShortTitle
            //                cell.lblDescription.text = string.htmlToString
            //            }else{
            //                //old
            //                cell.lblDescription.text = string.htmlToString
            //            }
            
            if ResultModelAryObj.videoShortTitle != "" {
                cell.lblTitle.text = ResultModelAryObj.videoShortTitle
            } else {
                cell.lblTitle.text = ResultModelAryObj.videoTitle
            }
            
            if ResultModelAryObj.videoShortDescription != "" {
                let string = ResultModelAryObj.videoShortDescription
                cell.lblDescription.text = string.htmlToString
            } else {
                let string = ResultModelAryObj.videoDescription
                cell.lblDescription.text = string.htmlToString
            }
            
            
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            
            DispatchQueue.main.async {
                cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(ResultModelAryObj.videoImgThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ResultModelAryObj = ResultModelAry[indexPath.row]
        
        Proxy.shared.pushToNextSubCatVC(identifier: "SubCategoryDetailVC", isAnimate: true, currentViewController: self, VideoId: ResultModelAryObj.videoId,headerName:ResultModelAryObj.headerCategoryUrl , currentContName: "", activityType: ResultModelAryObj.headerCategoryUrl, categorySubValue: "1", fromController: "RecentVideos")
        
        delegate?.didOpenVideo(status: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 236.0, height: 190)
        } else {
            let width = (self.view.frame.size.width / 2) - 4
            return CGSize(width:width-5, height: 175)
        }
    }
}

extension RecentVideosVC {
    
    //MARK:--> FAV VIDEOS API FUNCTION
    func postFavVideosApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "page_no"     :  "\(currentPage+1)" ,
            "page_size"   :  "\(pageSize)"  ,
            "user_id"     :  "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KRecentVideos)", params: param, showIndicator: true, completion: { (JSON) in
            
            // self.alertMsg = JSON["message"] as? String ?? ""
            
            var appResponse = Int()
            // appResponse = JSON["app_response"] as? Int ?? 0
            
            //  if appResponse == 200 {
            if let resultAry = JSON["results"] as? NSArray {
                if resultAry.count > 0 {
                    for i in 0..<resultAry.count {
                        if let bnrDict = resultAry[i] as? NSDictionary {
                            let ResultModelObj = ResultModel()
                            ResultModelObj.dictData(dict: bnrDict)
                            self.ResultModelAry.append(ResultModelObj)
                        }
                    }
                }
            }
            Proxy.shared.hideActivityIndicator()
            completion()
            //    }
        })
    }
}
