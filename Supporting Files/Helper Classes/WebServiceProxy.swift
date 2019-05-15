//
//  WebServiceProxy.swift
//  KRMOVIL
//
//  Created by Sukhpreet Kaur on 3/10/18.
//  Copyright © 2018 Sukhpreet Kaur. All rights reserved.
//

import Foundation
import Alamofire

class WebServiceProxy {
    static var shared: WebServiceProxy {
        return WebServiceProxy()
    }
    fileprivate init(){}
    
    //MARK:- API Interaction
    /*  func postData(_ urlStr: String, params: Dictionary<String, Any>? = nil, showIndicator: Bool, completion: @escaping (_ response: NSDictionary) -> Void) {
     if NetworkReachabilityManager()!.isReachable {
     if showIndicator {
     Proxy.shared.showActivityIndicator()
     }
     debugPrint("URL: ",urlStr)
     debugPrint("Params: ", params!)
     request(urlStr, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers:["Authorization": "\(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"])
     .responseJSON { response in
     //                    Proxy.shared.hideActivityIndicator()
     if response.data != nil && response.result.error == nil {
     if response.response?.statusCode == 200 {
     if let JSON = response.result.value as? NSDictionary {
     debugPrint("JSON", JSON)
     completion(JSON)
     } else {
     //                            Proxy.shared.hideActivityIndicator()
     Proxy.shared.displayStatusCodeAlert("Error: Unable to encode JSON Response")
     }
     //                            Proxy.shared.hideActivityIndicator()
     } else {
     if response.data != nil{
     debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "Error")
     }
     self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
     }
     } else {
     if response.data != nil{
     debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "Error")
     }
     self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
     }
     }
     } else {
     Proxy.shared.hideActivityIndicator()
     Proxy.shared.openSettingApp()
     }
     }*/
    
    
    func postData(_ urlStr: String, params: Dictionary<String, Any>? = nil, showIndicator: Bool, completion: @escaping (_ response: NSDictionary) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            debugPrint("URL: ",urlStr)
            debugPrint("Params: ", params!)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = TimeInterval(15)
            configuration.timeoutIntervalForRequest = TimeInterval(15)
            
            KAppDelegate.sessionManager = Alamofire.SessionManager(configuration: configuration)
            
            KAppDelegate.sessionManager.request(urlStr, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers:["Authorization": "\(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"])
                .responseJSON { response in
                    //                    Proxy.shared.hideActivityIndicator()
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                debugPrint("JSON", JSON)
                                completion(JSON)
                            } else {
                                //                            Proxy.shared.hideActivityIndicator()
                                Proxy.shared.displayStatusCodeAlert("Error: Unable to encode JSON Response")
                            }
                            //                            Proxy.shared.hideActivityIndicator()
                        } else {
                            if response.data != nil{
                                debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "Error")
                            }
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        
                        if response.data != nil{
                            debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "Error")
                        }
                        self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    
    //MARKK:- API Interaction
    func postDataForHome(_ urlStr: String, params: Dictionary<String, Any>? = nil, showIndicator: Bool, completion: @escaping (_ response: NSDictionary) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            debugPrint("URL: ",urlStr)
            debugPrint("Params: ", params!)
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = TimeInterval(25)
            configuration.timeoutIntervalForRequest = TimeInterval(25)
            
            KAppDelegate.sessionManager = Alamofire.SessionManager(configuration: configuration)
            //URLEncoding.httpBody
            KAppDelegate.sessionManager.request(urlStr, method: .post, parameters: params, encoding: URLEncoding.default, headers:["Authorization": "\(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"])
                .responseJSON { response in
                    Proxy.shared.hideActivityIndicator()
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                debugPrint("JSON", JSON)
                                completion(JSON)
                            } else {
                                //                            Proxy.shared.hideActivityIndicator()
                                Proxy.shared.displayStatusCodeAlert("Error: Unable to encode JSON Response")
                            }
                            Proxy.shared.hideActivityIndicator()
                        } else {
                            if response.data != nil{
                                debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "Error")
                            }
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        if response.data != nil{
                            debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "Error")
                        }
                        self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
            }
        } else {
            completion([:])

            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    func getData(_ urlStr: String, showIndicator: Bool, completion: @escaping (_ responseDict: NSDictionary) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            debugPrint("URL: ",urlStr)
            request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:["Authorization": "\(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"])
                .responseJSON { response in
                    Proxy.shared.hideActivityIndicator()
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                debugPrint("JSON", JSON)
                                completion(JSON)
                            } else {
                                Proxy.shared.displayStatusCodeAlert("Error: Unable to get response from server")
                            }
                        } else {
                            if response.data != nil{
                                debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                            }
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                        Proxy.shared.hideActivityIndicator()
                    } else {
                        if response.data != nil{
                            debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                        }
                        self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    
    func getCityOfGoogleAddressApi(_ userLat:String,_ userLong:String, _ completion:@escaping(_ city:String) -> Void) {
        var userCity = String()
        WebServiceProxy.shared.getData("\(Apis.KGetGoogleAddress)?latlng=\(userLat),\(userLong)&key=\(Apis.KMapProvideAPIKey)", showIndicator: true) {
            (JSON) in
            if JSON["status"] as? String == "OK" {
                if let detailArray = JSON["results"] as? NSArray {
                    if detailArray.count > 0 {
                        if let detailDict = detailArray[2] as? NSDictionary {
                            if let addressArray = detailDict ["address_components"] as? NSArray {
                                if addressArray.count > 0 {
                                    if let addressDict = addressArray[1] as? NSDictionary {
                                        if let city = addressDict["long_name"] as? String {
                                            userCity = city
                                        }
                                    }
                                }
                            }
                        }
                    }
                    completion(userCity)
                } else {
                    Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "")
                }
            }
        }
    }
    
    
    // MARK: - Error Handling
    func statusHandler(_ response:HTTPURLResponse? , data:Data?, error:NSError?) {
        if let code = response?.statusCode {
            switch code {
            case 400:
                Proxy.shared.displayStatusCodeAlert(AlertValue.urlError)
            case 403 , 401:
                UserDefaults.standard.set("", forKey: "access-token")
                UserDefaults.standard.synchronize()
            // RootControllerProxy.shared.rootWithoutDrawer("WelcomeVC")
            case 404:
                Proxy.shared.displayStatusCodeAlert(AlertValue.urlNotExist)
            case 500:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
            case 408:
                Proxy.shared.displayStatusCodeAlert(AlertValue.serverError)
            default:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
            }
        } else {
            let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
        }
        if let errorCode = error?.code {
            switch errorCode {
            default:
                Proxy.shared.displayStatusCodeAlert(AlertValue.serverError)
            }
        }
    }
}

