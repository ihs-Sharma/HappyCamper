//
//  FavouritesVIdeoVM.swift
//  HappyCamper
//
//  Created by wegile on 13/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit

protocol DidPlayFavouritesVideosDelegate {
    func playFavVideos(ResultModelAryObj:ResultModel,videoDetail:FavourtieVideos,playFav:Int)
}

// Get Campfire New and Featured Items
public struct FavourtieVideos: Codable {
    var id:String
    var title:String
    var desc:String
    var video_Url:String
    var thumb_Image:String
    
    init(_id:String,_url:String,_title:String,_desc:String,_image:String) {
        id=_id
        title=_title
        desc = _desc
        video_Url=_url
        thumb_Image = _image
    }
}


//MARK:- My all selected videos table cell like:Camp,Fav,uploaded
class MyFavouritesVideosCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var coll_Videos: UICollectionView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    var arr_MyVideos = [FavourtieVideos]()
    var ResultModelAry = [ResultModel]()
    var isOnlyMyFavVideos:Bool = false
    var isMyUploadedVideos:Bool = false
    var delegate:DidPlayFavouritesVideosDelegate?
    
    override func awakeFromNib() {
        coll_Videos.delegate=self
        coll_Videos.dataSource=self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOnlyMyFavVideos {
            return  ResultModelAry.count
        }
        return arr_MyVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coll_Videos.dequeueReusableCell(withReuseIdentifier: "FavVideosCell", for: indexPath) as! GuestLandingCVC
        
        if isOnlyMyFavVideos {
            let ResultModelAryObj = self.ResultModelAry[indexPath.row]
            
            if ResultModelAryObj.videoShortTitle != "" {
                cell.lblContent.text = ResultModelAryObj.videoShortTitle
            } else {
                cell.lblContent.text = ResultModelAryObj.videoTitle
            }
            
            if ResultModelAryObj.videoShortDescription != "" {
                let string = ResultModelAryObj.videoShortDescription
                cell.lblContentDescription.text = string.htmlToString
            } else {
                let string = ResultModelAryObj.videoDescription
                cell.lblContentDescription.text = string.htmlToString
            }
            DispatchQueue.main.async {
                cell.imgVw.sd_setImage(with: URL.init(string: "\(Apis.KVideosThumbURL)\(ResultModelAryObj.videoImgThumb)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            }
            return cell
        }
        
        DispatchQueue.main.async {
            var api = Apis.KFavCompressImage
            if self.isMyUploadedVideos {
                api = Apis.KCampfireVideoThum
            }
            cell.imgVw.sd_setImage(with: URL.init(string: "\(api)\(self.arr_MyVideos[indexPath.row].thumb_Image)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        
        cell.lblContent.text = self.arr_MyVideos[indexPath.row].title
        let string = self.arr_MyVideos[indexPath.row].desc
        cell.lblContentDescription.text = string.htmlToString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isOnlyMyFavVideos {
            let ResultModelAryObj = self.ResultModelAry[indexPath.row]
            delegate?.playFavVideos(ResultModelAryObj: ResultModelAryObj, videoDetail:FavourtieVideos.init(_id: "", _url: "", _title: "", _desc: "", _image: ""),playFav:1)
        } else if isMyUploadedVideos {
            delegate?.playFavVideos(ResultModelAryObj: ResultModel(), videoDetail: arr_MyVideos[indexPath.row],playFav:2)
        } else {
            delegate?.playFavVideos(ResultModelAryObj: ResultModel(), videoDetail: arr_MyVideos[indexPath.row],playFav:3)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Varinder
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 226.0, height: 191.0)
        } else {
            return CGSize(width: 185.0, height: 150.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

class FavouritesVIdeoVM {
    
    var currentPage = Int()
    var total_Arrays:Int = 0
    var pageSize = 10
    var fromCont = String()
    var ResultModelAry = [ResultModel]()
    var arr_MyFavCamps = [FavourtieVideos]()
    var arr_MyUploadedVideos = [FavourtieVideos]()
    
    //MARK:--> FAV VIDEOS API FUNCTION
    func postFavVideosApi(_ completion:@escaping(_ totalArray:Int) -> Void) {
        
        let param = [
            "page_no"     :  "\(currentPage+1)" ,
            "page_size"   :  "\(pageSize)"  ,
            "user_id"     :  "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KMyFavouritesVideo)", params: param, showIndicator: true, completion: { (jsonData) in
            
            var appResponse = Int()
            appResponse = jsonData["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                
                if let resultAry = jsonData["fav_videos"] as? NSArray {
                    if resultAry.count > 0 {
                        self.total_Arrays += 1
                        for i in 0..<resultAry.count {
                            if let bnrDict = resultAry[i] as? NSDictionary {
                                let ResultModelObj = ResultModel()
                                ResultModelObj.dictData(dict: bnrDict)
                                self.ResultModelAry.append(ResultModelObj)
                            }
                        }
                    }
                }
                
                guard let jsonResult = JSON.init(jsonData).dictionary else {
                    return
                }
                
                if let resultAry = jsonResult["fav_camps"]?.arrayValue {
                    if resultAry.count > 0 {
                        self.total_Arrays += 1
                        for i in 0..<resultAry.count {
                            if let bnrDict = resultAry[i]["camp_id"].dictionary {
                                self.arr_MyFavCamps.append(FavourtieVideos.init(_id: bnrDict["_id"]!.stringValue, _url: "", _title: bnrDict["camp_title"]!.stringValue, _desc: bnrDict["short_description"]!.stringValue, _image: bnrDict["camp_banner_link"]!.stringValue))
                            }
                        }
                    }
                }
                
                if let resultAry = jsonResult["campfire_videos"]?.arrayValue {
                    if resultAry.count > 0 {
                        self.total_Arrays += 1
                        for i in 0..<resultAry.count {
                            if let bnrDict = resultAry[i].dictionary {
                                self.arr_MyUploadedVideos.append(FavourtieVideos.init(_id: bnrDict["_id"]!.stringValue, _url: bnrDict["video_url"]!.stringValue, _title: bnrDict["video_title"]!.stringValue, _desc: bnrDict["video_description"]!.stringValue, _image: bnrDict["thumb_name"]!.stringValue))
                            }
                        }
                    }
                }
                
                completion(self.total_Arrays)
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
}

extension FavouritesVideoVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK:--> COLLECTION VIEW DELEGATE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavouritesVideoVMObj.ResultModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "FavouritesVideoCVC", for: indexPath) as! FavouritesVideoCVC
        
        let ResultModelAryObj = FavouritesVideoVMObj.ResultModelAry[indexPath.row]
        
        if FavouritesVideoVMObj.ResultModelAry.count != 0 {
            
            //            cell.lblTitle.text = ResultModelAryObj.videoShortTitle
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
        
        let ResultModelAryObj = FavouritesVideoVMObj.ResultModelAry[indexPath.row]
        
        Proxy.shared.pushToNextSubCatVC(identifier: "SubCategoryDetailVC", isAnimate: true, currentViewController: self, VideoId: ResultModelAryObj.videoId,headerName:ResultModelAryObj.headerCategoryUrl , currentContName: "", activityType: ResultModelAryObj.headerCategoryUrl, categorySubValue: "1",fromController:"FavVideos")
        
        delegate?.didOpenVideo(status: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Varinder
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 236.0, height: 190)
        } else {
            return CGSize(width: 185.0, height: 150.0)
        }
    }
}

//MARK:- TableView delegates and data source
extension FavouritesVideoVC:UITableViewDelegate,UITableViewDataSource,DidPlayFavouritesVideosDelegate {
    func playFavVideos(ResultModelAryObj: ResultModel, videoDetail: FavourtieVideos, playFav: Int) {
        if playFav == 1 {
            Proxy.shared.pushToNextSubCatVC(identifier: "SubCategoryDetailVC", isAnimate: true, currentViewController: self, VideoId: ResultModelAryObj.videoId,headerName:ResultModelAryObj.headerCategoryUrl , currentContName: "", activityType: ResultModelAryObj.headerCategoryUrl, categorySubValue: "1",fromController:"FavVideos")
        } else if playFav == 2 {
            
            let videoURL = URL(string: "\(Apis.KCampfireVideoUrl)\(videoDetail.video_Url)")
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.allowsPictureInPicturePlayback=true
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        } else {
            let nav = StoryboardChnage.mainStoryboard.instantiateViewController(withIdentifier: "CampDetailVC") as! CampDetailVC
            nav.CampDetailVMObj.campId = videoDetail.id
            self.navigationController?.pushViewController(nav, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FavouritesVideoVMObj.total_Arrays
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_MyAllVideos.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyFavouritesVideosCell
        cell.delegate = self
        if indexPath.section == 0 {
            cell.lblHeaderTitle.text = "MY FAVOURITE VIDEOS"
            cell.ResultModelAry = FavouritesVideoVMObj.ResultModelAry
            cell.isOnlyMyFavVideos=true
        } else if indexPath.section == 1 {
            cell.lblHeaderTitle.text = "MY UPLOADED VIDEOS"
            cell.arr_MyVideos = FavouritesVideoVMObj.arr_MyUploadedVideos
            cell.isMyUploadedVideos=true
        } else {
            cell.lblHeaderTitle.text = "MY FAVOURITE CAMPS"
            cell.arr_MyVideos = FavouritesVideoVMObj.arr_MyFavCamps
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 300
        } else {
            return 215
        }
    }
}
