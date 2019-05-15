//
//  LiveActivityVC.swift
//  HappyCamper
//
//  Created by wegile on 02/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class LiveActivityVC: UIViewController, SelectMenuOption {
    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var tblVw: UITableView!
    
    //MARK:--> VARIABLES
    var sectionAry = ["COOKING","WEB SERIES","DRONES","360 EXPLORE"]
    var currentEpisodes = ["video_1","video_2","video_3","video_4"]
    var liveActivityVMObj = LiveActivityVM()
   
    //var viewController : MenuDrawerController?
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnBackAction(_ sender: Any) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func btnLogInAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnExploreAction(_ sender: Any) {
    }
    @IBAction func btnLiveAction(_ sender: Any) {
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
        Proxy.shared.pushToNextVC(identifier: "SignUpVC", isAnimate: true, currentViewController: self)
    }
    @IBAction func btnStoreAction(_ sender: Any) {
    }
    //MARK:--> PROTOCOLS FUNCTIONS
    func didSelected(index: Int) {
       // Proxy.shared.pushToNextVC(identifier: "SettingPopUpVC", isAnimate: true, currentViewController: self)
    }
    
}
