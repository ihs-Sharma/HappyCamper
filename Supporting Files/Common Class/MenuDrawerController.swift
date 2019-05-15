//
//  MenuDrawerController.swift
//  HappyCamper
//
//  Created by wegile on 26/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit

protocol SelectMenuOption {
    func didSelected(index: Int);
}

class MenuDrawerController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK:--> VARIABLES
    var delegate : SelectMenuOption?
    @IBOutlet weak var btn_FbWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn_InstaWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn_TwiWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn_PinWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn_YoutWidthConstraint: NSLayoutConstraint!

    var menuAry = ["", "My Profile","Camp Staff", "Community","Invite a Friend","Blog", "FAQ’s","Contact Us" ,"Join our Team","Register your Camp","Terms of Service","Privacy Policy","Disclaimer","Sign Out"]
    var menuIcon = ["back (1)","back (1)", "back (1)", "back (1)", "back (1)","back (1)", "back (1)", "back (1)", "back (1)", "back (1)", "back (1)", "back (1)","back (1)", "sign-out"]
    
    // var menuAry = ["", "MY PROFILE", "COMMUNITY","CANTEEN","FAQS", "CONTACT US", "TERMS & CONDITIONS","PRIVACY POLICY","INVITE A FRIEND","JOIN OUR TEAM","BLOG","SIGNOUT"]
  //  var menuIcon = ["back (1)", "back (1)", "back (1)", "back (1)", "back (1)", "back (1)", "back (1)", "back (1)", "back (1)","back (1)","back (1)", "sign-out"]
    
    //MARK:--> IBOUTLETS
    @IBOutlet  var tblVw: UITableView!
    @IBOutlet  var lbl_Coins: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.tableFooterView = UIView()
        
        if UserDefaults.standard.object(forKey: "User_Coins") != nil {
            let coins = UserDefaults.standard.integer(forKey: "User_Coins")
            lbl_Coins.text = String.init(coins)
        }
        
        if Proxy.shared.authNil() == "" {
            lbl_Coins.text = String.init(0)
        }
        if UserDefaults.standard.object(forKey: "Social_Links") != nil {
        let links = UserDefaults.standard.value(forKey: "Social_Links") as! NSDictionary
            if links["facebook_url"] as? String == "" {
                self.btn_FbWidthConstraint.constant=0
            } else  if links["instagram_url"] as? String == "" {
                self.btn_InstaWidthConstraint.constant=0
            } else  if links["twitter_url"] as? String == "" {
                self.btn_TwiWidthConstraint.constant=0
            } else  if links["pininterest_url"] as? String == "" {
                self.btn_PinWidthConstraint.constant=0
            } else  if links["youtube_url"] as? String == "" {
                self.btn_YoutWidthConstraint.constant=0
            }
        }
    }
    
    @IBAction func buttonSocials(sender:UIButton!) {
        let links = UserDefaults.standard.value(forKey: "Social_Links") as! NSDictionary
        switch sender.tag {
        case 0:
            openSocialUrls(url: links["facebook_url"] as? String)
            break
        case 1:
            openSocialUrls(url: links["instagram_url"] as? String)
            break
        case 2:
            openSocialUrls(url: links["twitter_url"] as? String)
            break
        case 3:
            openSocialUrls(url: links["pininterest_url"] as? String)
            break
        case 4:
            openSocialUrls(url: links["youtube_url"] as? String)
            break
        default:
            break
        }
    }
    
    func openSocialUrls(url:String!) {
        guard let url = URL(string:url) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func goToCanteen(sender:UIButton!) {
        delegate?.didSelected(index: 101)
    }
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return menuAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "MenuPopUpTVC", for: indexPath) as! MenuPopUpTVC
        cell.lblTitle.text = menuAry[indexPath.row]
        cell.btNxt.setImage(UIImage(named: "\(menuIcon[indexPath.row])"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let auth = Proxy.shared.authNil()
        if auth == "" {
//            tableView.tableHeaderView = nil
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 13 || indexPath.row == 9{
                return 0
            } else {
                return 70
            }
        } else {
            if indexPath.row == 0 || indexPath.row == 9 {
                return 0
            } else {
                return 70
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblVw.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
              delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 1 {
              delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 2 {
              delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 3 {
              delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row ==  4 {
              delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 5 {
            delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 6 {
            delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 7 {
            delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 8 {
            delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 9 {
//            delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 10 {
            delegate?.didSelected(index: indexPath.row)
        }  else if indexPath.row  == 11 {
            delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 12 {
            delegate?.didSelected(index: indexPath.row)
        } else if indexPath.row  == 13 {
            Proxy.shared.logout {
                KAppDelegate.isGradiantShownForHome=false
                self.delegate?.didSelected(index: indexPath.row)
            }
        }
    }
}
