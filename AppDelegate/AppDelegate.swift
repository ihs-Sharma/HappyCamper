//
//  AppDelegate.swift
//  HappyCamper
//
//  Created by wegile on 18/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import StoreKit
import IQKeyboardManagerSwift
import Alamofire
import AVKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var storyBoradVal =  UIStoryboard()
    let receiptURL = Bundle.main.appStoreReceiptURL
    var isHomeScreenCalled:Bool = false
    var isGradiantShown:Bool = false
    var isGradiantShownForHome:Bool = false
    var isGradiantShownForSubCategory:Bool = false
    var isGradiantShownForCampfire:Bool = false
    var isCoinCanteenTabSelected:Bool = false
    var isVideoNeedsToPlay:Bool = false

    var sessionManager: SessionManager!
    var activityIndicator = UIActivityIndicatorView()
    var UserModelObj = UserModel()
    let loginAuth = Proxy.shared.authNil()

    let myGroup = DispatchGroup()
//    let storyBoradVal =  UIStoryboard(name: "Main", bundle: nil)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        //SKPaymentQueue.default().add(self)
        //SubscriptionService.shared.loadSubscriptionOptions()
        
        //IQKeyboardManager.shared.enableAutoToolbar = true
        //IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
    
        addActivityIndicator()
        checkStoryBoard()
        
        let backImage = UIImage(named: "left_arrow_iphone")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .default)
        
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [    NSAttributedString.Key.foregroundColor: UIColor.white]

        
        return true
    }
    
    func addActivityIndicator() {
        activityIndicator.style = .gray
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        window?.rootViewController?.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: (window?.rootViewController?.view.centerXAnchor)!),
            activityIndicator.centerYAnchor.constraint(equalTo: (window?.rootViewController?.view.centerYAnchor)!),
            ])
    }
    
    func checkStoryBoard() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("iPad")
            storyBoradVal =  UIStoryboard(name: "Main", bundle: nil)
        }else{
            print("not iPad")
            storyBoradVal =  UIStoryboard(name: "iPhone", bundle: nil)
            let leftMenuController = storyBoradVal.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
            SideMenuManager.default.menuLeftNavigationController = leftMenuController
            
            // this line is important
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            // controller identifier sets up in storyboard utilities
            // panel (on the right), it called Storyboard ID
            let viewController = storyBoradVal.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    // Manage device orientation for both iPad and iPhone
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Notify When deep linking getting returned from web end
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let str = url.absoluteString
        if str.contains("happycamper") {
            
            var obj = ["type":"ipad-signup"]
            
            if str.contains("web-series") {
                obj = ["type":"web-series"]
            }
            
            if str.contains("campfire") {
                obj = ["type":"campfire"]
            }
            
            if str.contains("nearbycamp") {
                obj = ["type":"nearbycamp"]
            }
            
            if str.contains("home") {
                obj = ["type":"home"]
            }
            
            NotificationCenter.default.post(name: Notification.Name("campfire_url"), object: nil, userInfo: obj)
        }
        return true
    }
    
    func checkAuthcode() {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            // RootControllerProxy.shared.rootWithoutDrawer("WelcomeVC")
        } else {
//            checkApiMethodWithoutNotification {
//                Proxy.shared.rootWithoutDrawer("TabbarViewController")
//            }
        }
    }
    
    //MARK:--> SIGN UP API FUNCTION
    func checkApiMethodWithoutNotification(_ completion:@escaping() -> Void) {
        let param = [
            "accessToken" : "\(Proxy.shared.authNil())"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KCheck)", params: param, showIndicator: true, completion: { (JSON) in
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                if let userDetail = JSON["userdetails"] as? NSDictionary {
                    let UserModelObj = UserModel()
                    UserModelObj.getUserDetail(dict: userDetail)
                    KAppDelegate.UserModelObj = UserModelObj
                }
                
                // Check if Subscription detail not empty
                if let scription = JSON["sub_scriptiondetails"] as? NSDictionary  {
                    
                    if scription["status"] as? String != "active" {
                        if (scription["barintree_customerId"] as? String) != nil {
                            // Got Payment from
                            let payemtFrom = scription["payment_from"] as? String
                            if payemtFrom == "IPAD" {
                                let plan = scription["payment_from"] as? String
                                
                                var APi_Data = [String: String]()
                                APi_Data["API"] = "in-app"
                                APi_Data["plan"] = plan
                                
                                // Open subscription page
                                NotificationCenter.default.post(name: Notification.Name("checkSubscription"), object: APi_Data)
                            }
                        } else {  }
                    }
                } else {
                     // Open subscription page
                    let APi_Data:[String: String] = ["API": "API"]
                    NotificationCenter.default.post(name: Notification.Name("checkSubscription"), object: APi_Data)
                    kisSubscribed=false
                }
            }
            Proxy.shared.hideActivityIndicator()
            completion()
        })
    }}
