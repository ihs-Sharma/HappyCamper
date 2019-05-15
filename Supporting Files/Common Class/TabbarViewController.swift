//
//  TabbarViewController.swift
//  HappyCamper
//
//  Created by wegile on 01/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    var tabBarIteam = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

        let selectedhome = UIImage(named: "web-page-home_phone")?.withRenderingMode(.alwaysOriginal)
        let deSelectedhome = UIImage(named: "web-page-home_phone")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[0])!
        tabBarIteam.image = deSelectedhome
        tabBarIteam.selectedImage = selectedhome
        
        let selectedImageProfile =  UIImage(named: "growth-1")?.withRenderingMode(.alwaysOriginal)
        let deselectedImageProfile = UIImage(named: "growth-1")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[3])!
        tabBarIteam.image = deselectedImageProfile
        tabBarIteam.selectedImage = selectedImageProfile
        
        let selectedCommunity =  UIImage(named: "organize-1")?.withRenderingMode(.alwaysOriginal)
        let deselectedCommunity  = UIImage(named: "organize-1")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[4])!
        tabBarIteam.image = deselectedCommunity
        tabBarIteam.selectedImage = selectedCommunity
        
        let selectedMore =  UIImage(named: "service-1")?.withRenderingMode(.alwaysOriginal)
        let deselectedMore = UIImage(named: "service-1")?.withRenderingMode(.alwaysOriginal) //organize-1
        tabBarIteam = (self.tabBar.items?[2])!
        tabBarIteam.image = deselectedMore
        tabBarIteam.selectedImage = selectedMore
        
        let img_SelectAboutUs =  UIImage(named: "icon_AboutUs")?.withRenderingMode(.alwaysOriginal)
        let img_DeselectAboutUs = UIImage(named: "icon_AboutUs")?.withRenderingMode(.alwaysOriginal) //organize-1
        tabBarIteam = (self.tabBar.items?[1])!
        tabBarIteam.image = img_DeselectAboutUs
        tabBarIteam.selectedImage = img_SelectAboutUs
        
        // selected tab background color
//        let numberOfItems = CGFloat(tabBar.items!.count)
//        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems , height: tabBar.frame.height)

//        tabBar.selectionIndicatorImage = UIImage.init(named: "1@3x.png")
//        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) , size: tabBarItemSize)
        //
        //initial tab bar index
        self.selectedIndex = 0
        
        // set red as selected background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) , size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        
        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -20
        
        //varinder3
        if UIApplication.shared.statusBarFrame.height >= CGFloat(44) {
            // It is an iPhone X
            
            tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0))
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == (self.tabBar.items as! [UITabBarItem])[0]{
            //Do something if index is 0
        }
        else if item == (self.tabBar.items as! [UITabBarItem])[2] {
            //Do something if index is 1
            KAppDelegate.isCoinCanteenTabSelected=true
            
//            let canteenTab = self.viewControllers?[2] as! CoinCanteenVC
//            canteenTab.isTabItemTabbed=true
        }
        
        KAppDelegate.activityIndicator.stopAnimating()
    }

}



extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
  
}
