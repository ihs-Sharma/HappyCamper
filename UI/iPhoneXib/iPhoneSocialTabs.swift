//
//  iPhoneSocialTabs.swift
//  HappyCamper
//
//  Created by wegile on 17/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class iPhoneSocialTabs: UIView {

    
    //MARK:--> Outlets
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var pintrestButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    
    
    //MARK:--> Variables
    var contentView : UIView?
    let nibName = "iPhoneSocialTabsXib"
    
    
    //MARK:--> Initializers
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
        
        if UserDefaults.standard.object(forKey: "Social_Links") != nil {
            let links = UserDefaults.standard.value(forKey: "Social_Links") as! NSDictionary
            if links["facebook_url"] as? String == "" {
                
            } else  if links["instagram_url"] as? String == "" {
                
            } else  if links["twitter_url"] as? String == "" {
                
            } else  if links["pininterest_url"] as? String == "" {
                
            } else  if links["youtube_url"] as? String == "" {
                
            }
        }
    }
    
    func loadViewFromNib() -> UIView! {
        
//       let view1 = Bundle.main.loadNibNamed("iPhoneSocialTabsXib", owner: self, options: [:])?.first as! UIView
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    //MARK:--> Button Actions
    
    @IBAction func socialTabButtonActions(_ sender: UIButton!) {
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
    
}
