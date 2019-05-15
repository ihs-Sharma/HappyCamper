//
//  LeftMenuViewController.swift
//  HappyCamper
//
//  Created by wegile on 22/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

protocol GuestLandingPageVCSideMenuDelegate :class {
    func didSelectSideMenu(itemNum : Int)
}

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var btn_HeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var getAccessButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var delegate: GuestLandingPageVCSideMenuDelegate?
        
    //varinder6
    let menuArray = ["HOME","LIVE", "WEB SERISE", "360˚", "STORE", "CAMPFIRE", "CAMP STAFF", "COMMUNITY", "FAQ", "CONTACT US", "TERMS AND CONDITIONS", "PRIVACY POLICY", "INVITE FRIENDS", "JOIN CAMP"]

    var itemSelectTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Devansh
        let auth = Proxy.shared.authNil()
        if auth != "" {
            getAccessButton.isHidden = true
            btn_HeightConstaint.constant = 0
            
            let userName = Proxy.shared.selectedUserName()
            let user_Email = Proxy.shared.selectedUserEmail()
            
            if KAppDelegate.UserModelObj.userName == "" {
                userNameLabel.text! = userName
            } else {
                userNameLabel.text! = KAppDelegate.UserModelObj.userName
            }
            
            if KAppDelegate.UserModelObj.userEmail == "" {
                emailLabel.text! = user_Email
            } else {
                emailLabel.text! = KAppDelegate.UserModelObj.userEmail
            }
            
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            if slectedAviator != "" {
                userImageView.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            }
        } else {
            btn_HeightConstaint.constant = 30
            getAccessButton.isHidden = false
            self.userNameLabel.text = ""
            self.emailLabel.text = ""
            
            userImageView.sd_setImage(with: URL.init(string: ""),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        
        self.getAccessButton.layer.cornerRadius = self.getAccessButton.frame.height/2
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        userImageView.clipsToBounds = true
    }
    
    @IBAction func getAccessButtonAction(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        //open profile
        if Proxy.shared.authNil() != "" {
            Proxy.shared.pushToNextVC(identifier: "ProfileVC", isAnimate: true, currentViewController: self)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- Tableview Delegates and data sources
extension LeftMenuViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTVC") as! LeftMenuTVC
        
        cell.menuTitleLabel.text = self.menuArray[indexPath.row]
        
        let auth = Proxy.shared.authNil()
        
        if auth != "" && indexPath.row == self.menuArray.count-1{
            
//            cell.menuTitleLabel.text = "LOGOUT"
        }
        
        
        if(self.itemSelectTag == indexPath.row){
            cell.selectionGradientImage.image = UIImage(named : "gradientMenuButton")
        }else{
            cell.selectionGradientImage.image = UIImage(named : "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.itemSelectTag = indexPath.row
        //        DispatchQueue.main.async {
        //            tableView.reloadData()
        //        }
        //Devansh
        if indexPath.row != 1 || indexPath.row != 4 {
            delegate?.didSelectSideMenu(itemNum: indexPath.row)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

class LeftMenuTVC : UITableViewCell{
    @IBOutlet weak var selectionGradientImage: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
}
