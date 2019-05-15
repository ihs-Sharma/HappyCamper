//
//  Proxy.swift
//  HappyCamper
//
//  Created by wegile on 25/12/18.
//  Copyright © 2018 wegile. All rights reserved.
//

import UIKit
import SwiftSpinner
//import SKToast

let KAppDelegate = UIApplication.shared.delegate as! AppDelegate
var activityIndicator = UIActivityIndicatorView()


class Proxy {
    
    static var shared: Proxy {
        return Proxy()
    }
    fileprivate init() {}
    
    
    //MARK:- User Defauls
    func authNil() -> String {
        if let authCode = UserDefaults.standard.object(forKey: "access-token") as? String {
            return authCode
        } else {
            return ""
        }
    }
    
    func selectedAviatorImage() -> String {
        if let selectedAviatorImg = UserDefaults.standard.object(forKey: "selected_aviator") as? String {
            return selectedAviatorImg
        } else {
            return ""
        }
    }
    
    func selectedUserName() -> String {
        if let selectedName = UserDefaults.standard.object(forKey: "userName") as? String {
            return selectedName
        } else {
            return ""
        }
    }
    
    func selectedUserEmail() -> String {
        if let selectedEmail = UserDefaults.standard.object(forKey: "userEmail") as? String {
            return selectedEmail
        } else {
            return ""
        }
    }
    
    func userId() -> String {
        if let userId = UserDefaults.standard.object(forKey: "user_id") as? String {
            return userId
        } else {
            return ""
        }
    }
    
    func setUserId(id:String!)  {
       UserDefaults.standard.set(id, forKey: "user_id")
        UserDefaults.standard.synchronize()
    }
    
    
    //MARK:- Set Root Drawer
    func rootWithoutDrawer(_ identifier: String) {
        KAppDelegate.isGradiantShownForHome=false
        let blankController = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: identifier)
        var homeNavController:UINavigationController = UINavigationController()
        homeNavController = UINavigationController.init(rootViewController: blankController)
        homeNavController.isNavigationBarHidden = true
        KAppDelegate.window!.rootViewController = homeNavController
        KAppDelegate.window!.makeKeyAndVisible()
        KAppDelegate.addActivityIndicator()

    }
    
    func pushToNextSubCatVC(identifier:String, isAnimate:Bool , currentViewController: UIViewController , VideoId : String, headerName : String, currentContName: String,activityType : String, categorySubValue: String, fromController: String) {
        
//        let pushControllerObj = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: identifier) as! SubCategoryDetailVC
//        pushControllerObj.str_ActivityType = activityType
//        pushControllerObj.str_CategoryValue = categorySubValue
//        pushControllerObj.SubCategoryDetailVMObj.userVideoId = VideoId
//        pushControllerObj.SubCategoryDetailVMObj.fromCont = currentContName
//        pushControllerObj.SubCategoryDetailVMObj.headerTitleUrl = headerName
//        currentViewController.navigationController?.pushViewController(pushControllerObj, animated: isAnimate)
        KAppDelegate.isGradiantShown=false

        if UIDevice.current.userInterfaceIdiom != .pad {
            var  nav = HCOpenVideoIphoneVC()
           nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "HCOpenVideoIphoneVC") as! HCOpenVideoIphoneVC
            nav.str_ActivityType = activityType
            nav.str_CategoryValue = categorySubValue
            nav.str_VideoId = VideoId
            nav.str_FromController = fromController
            playDelegate = currentViewController as? ManagePlyersDelegte
            currentViewController.navigationController?.pushViewController(nav, animated: true)
//            let transition = CATransition()
//            transition.duration = 0.2
//            transition.type = CATransitionType.fade
//            transition.subtype = CATransitionSubtype.fromBottom
//            currentViewController.view.window!.layer.add(transition, forKey: kCATransition)
//            nav.view.frame = UIScreen.main.bounds
//
//            currentViewController.addChild(nav)
//            //make sure that the child view controller's view is the right size
//            currentViewController.view.addSubview(nav.view)
//
//            //you must call this at the end per Apple's documentation
//            nav.didMove(toParent: currentViewController)
        } else {
           var  nav = HCOpenVideoVC()
            nav = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: "HCOpenVideoVC") as! HCOpenVideoVC
            nav.str_ActivityType = activityType
            nav.str_CategoryValue = categorySubValue
            nav.str_VideoId = VideoId
            nav.str_FromController = fromController
            playDelegate = currentViewController as? ManagePlyersDelegte

//            let transition = CATransition()
//            transition.duration = 0.2
//            transition.type = CATransitionType.fade
//            transition.subtype = CATransitionSubtype.fromBottom
//            currentViewController.view!.layer.add(transition, forKey: kCATransition)
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromTop
            currentViewController.navigationController!.view.layer.add(transition, forKey: kCATransition)
            currentViewController.navigationController?.pushViewController(nav, animated: true)
//            nav.view.frame = UIScreen.main.bounds
            
//            currentViewController.addChild(nav)
            //make sure that the child view controller's view is the right size
//            currentViewController.view.addSubview(nav.view)
            
            //you must call this at the end per Apple's documentation
//            nav.didMove(toParent: currentViewController)
        }
        
        
    }
    
    //MARK:- Push Method
    func pushToNextVC(identifier:String, isAnimate:Bool , currentViewController: UIViewController) {
        let pushControllerObj = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: identifier)
        currentViewController.navigationController?.pushViewController(pushControllerObj, animated: isAnimate)
    }
    
    //MARK:- Push Method
    func presentToVC(identifier:String, isAnimate:Bool , currentViewController: UIViewController) {
        let pushControllerObj = KAppDelegate.storyBoradVal.instantiateViewController(withIdentifier: identifier)
        currentViewController.present(pushControllerObj, animated: false, completion: nil)
    }
    
    //MARK:- Pop Method
    func popToBackVC(isAnimate:Bool , currentViewController: UIViewController) {
        currentViewController.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Display Toast
    func displayStatusCodeAlert(_ userMessage: String) {
        //SKToast.show(withMessage: userMessage)
    }
    
    //MARK:- Check Valid Email Methozd
    func isValidEmail(_ testStr:String) -> Bool  {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return (testStr.range(of: emailRegEx, options:.regularExpression) != nil)
    }
    
    //MARK:- Check Valid Password Method
    func isValidPassword(_ testStr:String) -> Bool
    {
        let capitalLetterRegEx  = ".*[A-Za-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: testStr)
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: testStr)
        
        let specialCharacterRegEx  = ".*[!&^%$#@()*/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: testStr)
        
        let eightRegEx  = ".{8,}"
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", eightRegEx)
        let eightresult = texttest3.evaluate(with: testStr)
        return  specialresult && capitalresult && numberresult && eightresult
    }
    
    //MARK:- Check Valid Name Method
    func isValidInput(_ Input:String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        // string contains non-whitespace characters
        
        if Input.rangeOfCharacter(from: characterset.inverted) != nil {
            Proxy.shared.displayStatusCodeAlert("Please enter valid Name")
            return false
        }
        else {
            return true
        }
    }
    
    //MARK:- LOGOUT METHOD
    func logout(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KLogout)", showIndicator: true, completion: { (JSON) in
            
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                UserDefaults.standard.set("", forKey: "access-token")
                UserDefaults.standard.synchronize()
                completion()
            }
        })
    }
    
    //MARK:- Latitude Method
    func getLatitude() -> String {
        if UserDefaults.standard.object(forKey: "lat") != nil {
            let currentLat =  UserDefaults.standard.object(forKey: "lat") as! String
            return currentLat
        }
        return ""
    }
    
    //MARK:- Longitude Method
    func getLongitude() -> String {
        if UserDefaults.standard.object(forKey: "long") != nil {
            let currentLong =  UserDefaults.standard.object(forKey: "long") as! String
            return currentLong
        }
        return ""
    }
    
    //MARK: - HANDLE ACTIVITY
    func showActivityIndicator() {
        DispatchQueue.main.async{
//            SwiftSpinner.show("Please wait..", animated: true)
            self.showActivityIndicator(on: UIView())
        }
    }
    
    func showActivityIndicator(on parentView: UIView) {
        KAppDelegate.addActivityIndicator()
    }
    
    func hideActivityIndicator()  {
        DispatchQueue.main.async {
            KAppDelegate.activityIndicator.stopAnimating()
//            SwiftSpinner.hide()
        }
    }
    
    //MARK:- LOCATION SETTING
    func openLocationSettingApp() {
        let settingAlert = UIAlertController(title: "Location Problem", message: "Please enable your location", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title:"Setting", style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert(AlertValue.pleaseReviewyournetworksettings)
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        UIApplication.shared.keyWindow?.rootViewController?.present(settingAlert, animated: true, completion: nil)
    }
    
    //MARK:--> MARK OPEN APP SETTINGS
    func openSettingApp() {
        let settingAlert = UIAlertController(title: "Connection Problem", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title:"Setting", style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert(AlertValue.pleaseReviewyournetworksettings)
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        UIApplication.shared.keyWindow?.rootViewController?.present(settingAlert, animated: true, completion: nil)
    }
    
    func presentAlert(withTitle title: String, message : String, currentViewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        currentViewController.present(alertController, animated: false, completion: nil)
    }
    
    func showNavigationOnTopMenu(controller:UIViewController) {
        
        controller.navigationController?.setNavigationBarHidden(false, animated: true)
        controller.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3019607843, green: 0.1803921569, blue: 0.4862745098, alpha: 1)
        
        let image3 = UIImage(named: "menu (1)")
        let frameimg = CGRect(x: 15, y: 5, width: 22, height: 22)
        
        let someButton = UIButton(frame: frameimg)
        someButton.setBackgroundImage(image3, for: .normal)
        someButton.addTarget(controller, action: #selector(btnMenuAction), for: .touchUpInside)
        someButton.showsTouchWhenHighlighted = false
        
        let mailbutton = UIBarButtonItem(customView: someButton)
        controller.navigationItem.leftBarButtonItem = mailbutton
        //self.title = ""
    }
    
    @objc func btnMenuAction(){
        print("----------------------jatt ------------------------")
        
    }
}
