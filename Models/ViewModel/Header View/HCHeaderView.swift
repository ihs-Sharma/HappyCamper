//
//  HCHeaderView.swift
//  HappyCamper
//
//  Created by wegile on 18/03/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

protocol TopHeaderViewDelegate {
    func selectOptionByName(name:String!);
    func setBackToHome();
}
var headerDelegate : TopHeaderViewDelegate?
class HCHeaderView: UIView {
    
    var contentView : UIView?
    @IBOutlet weak var btn_AvatarImage: SetCornerButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgVwAviator: UIImageView!
    @IBOutlet weak var imgVwDropDown: UIImageView!
    @IBOutlet weak var btnVW: UIView!
    @IBOutlet weak var btnGetAllAccess: UIButton!
    @IBOutlet weak var btn_OptionBeforeLogin: UIButton!
    
    @IBOutlet weak var btn_360: UIButton!
    @IBOutlet weak var btn_Campfire: UIButton!
    @IBOutlet weak var btn_Series: UIButton!
    @IBOutlet weak var btn_Home: UIButton!

    @IBOutlet weak var btnMenu: UIButton!
    let nibName = "HCHeaderView"
    
    @IBOutlet weak var view_ConstraintLeftAfterLogin: NSLayoutConstraint!
    @IBOutlet weak var view_ConstraitLeftBeforeLogin: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        let auth = Proxy.shared.authNil()
        if auth != "" {
            self.view_ConstraitLeftBeforeLogin.priority = UILayoutPriority(250)
            let slectedAviator = Proxy.shared.selectedAviatorImage()
            let userName = Proxy.shared.selectedUserName()
            if slectedAviator != "" {
                imgVwAviator.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
            }
            
            if KAppDelegate.UserModelObj.userName == "" {
                lblUserName.text! = userName
            } else {
                lblUserName.text! = KAppDelegate.UserModelObj.userName
            }
            
            
            btnGetAllAccess.isHidden = true
            btn_OptionBeforeLogin.isHidden = true
            btn_AvatarImage.isHidden = false
            imgVwDropDown.isHidden = false
            imgVwAviator.isHidden = false
            lblUserName.isHidden = false
            btnVW.isHidden = true
            btnMenu.isHidden = false
        } else {
            self.view_ConstraitLeftBeforeLogin.priority = UILayoutPriority(1000)

            
            if KAppDelegate.window?.rootViewController is SignInVC {
                //do something if it's an instance of that class
                btn_OptionBeforeLogin.isHidden = true
            } else {
                btn_OptionBeforeLogin.isHidden = false
            }
            btnGetAllAccess.isHidden = false
            btn_AvatarImage.isHidden = true
            imgVwDropDown.isHidden = false
            imgVwAviator.isHidden = true
            lblUserName.isHidden = true
            btnVW.isHidden = false
            btnMenu.isHidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBAction func buttonHomeAction(_ sender: Any) {
        headerDelegate?.setBackToHome()
    }
    
    
    // Select Header options
    @IBAction func selectOptions(button:UIButton!) {
        
        switch button.tag {
        case 0:
            headerDelegate?.selectOptionByName(name: "live")
            break
        case 1:
            headerDelegate?.selectOptionByName(name: "series")
            break
        case 2:
            headerDelegate?.selectOptionByName(name: "360")
            break
        case 3:
            headerDelegate?.selectOptionByName(name: "campFire")
            break
        case 4:
            headerDelegate?.selectOptionByName(name: "store")
            break
        case 5:
            headerDelegate?.selectOptionByName(name: "profilePic")
            break
        case 6:
            headerDelegate?.selectOptionByName(name: "Options")
            break
        case 7:
            headerDelegate?.selectOptionByName(name: "SignIn")
            break
        case 8:
            headerDelegate?.selectOptionByName(name: "getAccess")
            break
        default:
            break
        }
        
    }
    
}
