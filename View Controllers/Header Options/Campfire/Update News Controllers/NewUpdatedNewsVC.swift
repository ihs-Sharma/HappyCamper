//
//  NewUpdatedNewsVC.swift
//  HappyCamper
//
//  Created by Wegile on 09/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewUpdatedNewsVC: UIViewController {
    @IBOutlet weak var tbl_NewItems: UITableView!
    var arr_NewNews:[FeaturedItems] = [ ]
    var isVideoLiked=false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//                    NotificationCenter.default.addObserver(self, selector: #selector(self.getNewUpdatesData), name: NSNotification.Name(rawValue: "SetNewUpdatesNews"), object: nil)

        guard let data = UserDefaults.standard.data(forKey: "ArrayOfNewUpdates") else {
            self.arr_NewNews = []
            return
        }
        do {
            self.arr_NewNews = try JSONDecoder().decode([FeaturedItems].self, from: data)
            self.tbl_NewItems.reloadData()
        } catch {
            print(error)
            self.arr_NewNews = []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {}
    
    @objc func getNewUpdatesData(_ notification: Notification) {
//        if let object = notification.object as? [FeaturedItems] {
//            self.arr_NewNews = object
//            self.tbl_NewItems.reloadData()
//        }
    }

}

//MARK:-  TableView Delegates and Datasources
extension NewUpdatedNewsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_NewNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell1", for: indexPath) as! CampfireNewUpdatedCell
        
        cell.lbl_Title.text = self.arr_NewNews[indexPath.row].title
        cell.lbl_Desc.text = self.arr_NewNews[indexPath.row].desc
        cell.btn_Like.setTitle("\(self.arr_NewNews[indexPath.row].totalLikes)", for: .normal)
        cell.btn_View.setTitle("\(self.arr_NewNews[indexPath.row].totalViews)", for: .normal)
        
        if self.arr_NewNews[indexPath.row].isLiked == false {
            cell.img_Like.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
            cell.img_Like.tintColor = .gray
            
            cell.btn_ClickLike.tag = indexPath.row
            cell.btn_ClickLike.addTarget(self, action: #selector(self.likeVideo(sender:)), for: .touchUpInside)
        } else {
            cell.img_Like.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
            cell.img_Like.tintColor = .blue
            
            cell.btn_ClickLike.tag = indexPath.row
            cell.btn_ClickLike.addTarget(self, action: #selector(self.dislikeVideo(sender:)), for: .touchUpInside)
        }
        if !isVideoLiked {
            DispatchQueue.main.async {
                cell.initializeVideos(videoString: self.arr_NewNews[indexPath.row].video_Url)
            }
        }
        cell.shadow_View.layer.cornerRadius = 2
        cell.shadow_View.layer.masksToBounds = true
        
        cell.shadow_View.layer.masksToBounds = false
        cell.shadow_View.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        cell.shadow_View.layer.shadowColor = UIColor.black.cgColor
        cell.shadow_View.layer.shadowOpacity = 0.23
        cell.shadow_View.layer.shadowRadius = 4
        if Proxy.shared.authNil() == "" {
            DispatchQueue.main.async {
                let btn_CheckAccess = UIButton.init(type: .custom)
                btn_CheckAccess.backgroundColor = .clear
                btn_CheckAccess.frame = CGRect.init(x: 0, y: 5, width: cell._VideoView.frame.size.width, height: cell._VideoView.frame.size.height)
                btn_CheckAccess.addTarget(self, action: #selector(self.checkAuth), for: .touchUpInside)
                cell._VideoView.addSubview(btn_CheckAccess)
            }
        }
        return cell
        
    }
    
    @objc func checkAuth(sender:UIButton) {
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
    }
    
    //Like video
    @objc func likeVideo(sender:UIButton) {
        
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
        let videoId = self.arr_NewNews[sender.tag].id
        //        let likes:Int = self.arr_HotNews[sender.tag].totalLikes
        //        self.updateResults(tag: sender.tag, color: .blue, data:["total_likes":likes+1])
        
        self.likeAndDislike(url: Apis.KCampfireVideoLike,videoId:videoId) {(success,data) -> Void in
            if success {
                self.arr_NewNews[sender.tag].isLiked = true
                self.arr_NewNews[sender.tag].totalLikes = data["total_likes"] as! Int
                self.tbl_NewItems.reloadData()
            }
        }
    }
    
    //DisLike video
    @objc  func dislikeVideo(sender:UIButton) {
        if Proxy.shared.authNil() == "" {
            Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
            return
        }
        let videoId = self.arr_NewNews[sender.tag].id
        //        let likes:Int = self.arr_HotNews[sender.tag].totalLikes
        //        self.updateResults(tag: sender.tag, color: .gray, data:["total_likes":likes-1])
        self.likeAndDislike(url: Apis.KCampfireVideoDisLike,videoId:videoId) {(success,data) -> Void in
            if success {
                self.arr_NewNews[sender.tag].isLiked = false
                self.arr_NewNews[sender.tag].totalLikes = data["total_likes"] as! Int
                self.tbl_NewItems.reloadData()
            }
        }
    }
    
    //JSON
    func likeAndDislike(url:String,videoId:String,completion: @escaping (_ success:Bool,_ results:NSDictionary) -> Void) {
        
        let param = [
            "video_id" : "\(videoId)",
            "udid" : "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(url)", params: param, showIndicator: true, completion: { (jsonData) in
            var appResponse = Int()
            
            appResponse = jsonData["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                completion(true,jsonData)
            }
            self.isVideoLiked=true
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    func updateResults(tag:Int,color:UIColor,data:NSDictionary) {
        let cell = self.tbl_NewItems.cellForRow(at: IndexPath.init(row: tag, section: 0)) as! CampfireNewUpdatedCell
        cell.img_Like.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        cell.img_Like.tintColor = color
        cell.btn_Like.setTitle("\(data["total_likes"] as! Int)", for: .normal)
    }
    
}
