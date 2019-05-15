//
//  WebSeriesVideoDetailCatVC.swift
//  HappyCamper
//
//  Created by wegile on 08/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class WebSeriesVideoDetailCatVC: UIViewController,TopHeaderViewDelegate {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var view_HeaderView: HCHeaderView!

    @IBOutlet weak var colWebVideo: UICollectionView!
    @IBOutlet weak var videoVw: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnLikedRef: UIButton!
    //MARK:--> VARIABLES
    var sectionHeader = ["OTHER WEB EPISODES"]
    var WebSeriesVideoDetailCatVMObj = WebSeriesVideoDetailCatVM()
    var player : AVPlayer?
    var playerController  : AVPlayerViewController?
    var likeState = Int()
    
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
//            if targetVw.isHidden == true {
//                targetVw.isHidden = false
//            }else{
//                targetVw.isHidden = true
//            }
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if playerController != nil {
            player!.pause()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        headerDelegate = self
        
        let slectedAviator = Proxy.shared.selectedAviatorImage()
        if slectedAviator != "" {
            view_HeaderView.imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
        }
        
        WebSeriesVideoDetailCatVMObj.VideoDetailModelAry = []
        //WEBSERIES
        WebSeriesVideoDetailCatVMObj.SubCategoryViewAllTopModelAry = []
        WebSeriesVideoDetailCatVMObj.SubVideoCategoryModelAry = []
        
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != "" {
            WebSeriesVideoDetailCatVMObj.getSubCategoriesApi {
                
                self.likeState = self.WebSeriesVideoDetailCatVMObj.VideoLiked
                self.btnLikedRef.setTitle("  \(self.WebSeriesVideoDetailCatVMObj.totalLike)", for: .normal)
                
                if self.likeState == 0 {
                    self.btnLikedRef.setImage(UIImage(named: "like"), for: .normal)
                } else{
                     self.btnLikedRef.setImage(UIImage(named: "like"), for: .normal)
                   // self.btnLikedRef.setImage(UIImage(named: "safe"), for: .normal)
                }
                
                self.videoPlayerPlay(Url: self.WebSeriesVideoDetailCatVMObj.VideoDetailModelAry[0].videoUrl)
                self.btnView.setTitle("  \(self.WebSeriesVideoDetailCatVMObj.VideoDetailModelAry[0].dictCount)", for: .normal)
                
                let string =  self.WebSeriesVideoDetailCatVMObj.VideoDetailModelAry[0].videoDescription
                self.lblDescription.text! = string.htmlToString
                self.lblTitle.text! = self.WebSeriesVideoDetailCatVMObj.VideoDetailModelAry[0].videoTitle
                
                //WEBSERIES EPISODS API
                self.WebSeriesVideoDetailCatVMObj.postWebSeriesApi {
                    self.colWebVideo.reloadData()
                }
                
            }
        } else {
            Proxy.shared.presentAlert(withTitle: "", message: "Please login", currentViewController: self)
        }
    }
    
    //MARK:--> BUTTON ACTION
    @IBAction func btnAddMyFavVideo(_ sender: Any) {
        if Proxy.shared.userId() != "" {
            WebSeriesVideoDetailCatVMObj.addToMyCampApi {
                
            }
        }
    }
   
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func btnLikeAction(_ sender: Any) {
        if Proxy.shared.userId() != "" || Proxy.shared.authNil() != ""{
            if self.likeState == 0 {
                WebSeriesVideoDetailCatVMObj.videoLikeApi {
                    self.viewWillAppear(true)
                }
            } else {
                WebSeriesVideoDetailCatVMObj.videoDislikeApi {
                    self.viewWillAppear(true)
                }
            }
        } else {
            Proxy.shared.presentAlert(withTitle: "", message: "Please Login", currentViewController: self)
        }
    }
    
    //MARK:--> PLAY VIDEO  FUNCTION
    func videoPlayerPlay(Url: String) {
        
        let videoURL = URL(string: "\(Apis.KVideoURl)\(Url)")
        
        if playerController  != nil {
//            player = nil
//            playerController?.player = nil
//
//            player = AVPlayer(url: videoURL!)
//            playerController?.player = player
//            player?.play()
            
            let currentItem = AVPlayerItem.init(url: videoURL!)
            player?.replaceCurrentItem(with: currentItem)
            player?.play()

        } else {
            playerController  = AVPlayerViewController()
            player = AVPlayer(url: videoURL!)
            
            playerController?.player = player
            playerController?.view = videoVw
            playerController?.view.frame = videoVw.bounds
            playerController?.view.backgroundColor = .white
            self.addChild(playerController!)
            videoVw.addSubview(playerController!.view )
            playerController!.view.frame = videoVw.bounds
            player!.play()
            
        }
    }
}
