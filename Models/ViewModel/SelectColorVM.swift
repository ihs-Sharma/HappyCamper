//
//  SelectColorVM.swift
//  HappyCamper
//
//  Created by wegile on 04/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class SelectColorVM {
    var AviatorModelAry = [AviatorModel]()
    var selectedImage = String()
    
    //MARK:--> SIGN UP API FUNCTION
    func postAviatorApi(_ completion:@escaping() -> Void) {
        let abc = "string"
        let param = [
            "page_type" : "\(abc)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KAviator)", params: param, showIndicator: true, completion: { (JSON) in
            if let resAry = JSON["results"] as? NSArray {
                if resAry.count > 0 {
                    for i in 0..<resAry.count {
                        if let avtrDict = resAry[i] as? NSDictionary {
                            let AviatorModelObj = AviatorModel()
                            AviatorModelObj.getAviator(dict: avtrDict)
                            self.AviatorModelAry.append(AviatorModelObj)
                        }
                    }
                }
            }
            Proxy.shared.hideActivityIndicator()
            completion()
        })
    }
    
    func postChangeprofileThemeColor(StrImg:String , StrThemeColor:String, completion:@escaping(_ Success: Bool) -> Void) {
        
        let param = [
            "id" : "\(Proxy.shared.userId())",
            "image" : "\(StrImg)",
            "theme_color" : "\(StrThemeColor)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KupdateprofileTheme)", params: param, showIndicator: true, completion: { (JSON) in
            
            print(JSON)
            var appResponse = Int()
            appResponse = JSON["code"] as? Int ?? 0
            if appResponse == 200 {
                completion(true)
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
}

extension SelectColorVC: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SelectColorVMObj.AviatorModelAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let colCell = colVwIconBanner.dequeueReusableCell(withReuseIdentifier: "SelectColorBannerCVC", for: indexPath) as! SelectColorBannerCVC
        
        if SelectColorVMObj.AviatorModelAry.count != 0 {
            
            let AviatorModelAryObj = SelectColorVMObj.AviatorModelAry[indexPath.row]
            if selectedButton == "Purple" {
                colCell.imgVwBanner.sd_setImage(with: URL.init(string: "\(Apis.KAviatorBlue)\(AviatorModelAryObj.aviatorImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            } else {
                colCell.imgVwBanner.sd_setImage(with: URL.init(string: "\(Apis.KAviatorGreen)\(AviatorModelAryObj.aviatorGreenImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
            }
        }
        return colCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if SelectColorVMObj.AviatorModelAry.count > 0 {
            let AviatorModelAryObj = SelectColorVMObj.AviatorModelAry[indexPath.row]
            var img_Name:String! = ""
            if self.selectedButton == "Green" {
                img_Name = AviatorModelAryObj.aviatorGreenImage
                selectedButton = "green"
            } else {
                img_Name = AviatorModelAryObj.aviatorImage
                selectedButton = "blue"
            }
            
            SelectColorVMObj.postChangeprofileThemeColor(StrImg: img_Name, StrThemeColor: selectedButton) {(Success) in
                
                if Success {
                    print(Success)
                    
                    
                    if self.selectedButton == "blue" {
                        self.SelectColorVMObj.selectedImage = AviatorModelAryObj.aviatorImage
                        self.imgVwTop.sd_setImage(with: URL.init(string: "\(Apis.KAviatorBlue)\(AviatorModelAryObj.aviatorImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                        
                        let imgString = "\(Apis.KAviatorBlue)\(AviatorModelAryObj.aviatorImage)"
                        
                        if imgString != "" {
                            UserDefaults.standard.set(imgString, forKey: "selected_aviator")
                            UserDefaults.standard.synchronize()
                        }
                    } else {
                        self.SelectColorVMObj.selectedImage = AviatorModelAryObj.aviatorGreenImage
                        self.imgVwTop.sd_setImage(with: URL.init(string: "\(Apis.KAviatorGreen)\(AviatorModelAryObj.aviatorGreenImage)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
                        
                        let imgString = "\(Apis.KAviatorGreen)\(AviatorModelAryObj.aviatorGreenImage)"
                        if imgString != "" {
                            UserDefaults.standard.set(imgString, forKey: "selected_aviator")
                            UserDefaults.standard.synchronize()
                        }
                    }
                    
                    let slectedAviator = Proxy.shared.selectedAviatorImage()
                    if slectedAviator != "" {
                        self.imgVwTop.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "defaultImg"), completed: nil)
                    }
                    self.dismiss(animated: true, completion: nil)
                    SelectAviatorImageObj?.selectedImage(index: 0)
                    
                } else{ print("APiError") }
            }
        }
    }
    
    //varinder3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize    {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = (collectionView.frame.size.width / 6) - 10
            return CGSize(width:width, height: 65)
        }else{
            let width = (collectionView.frame.size.width / 4) - 4
            return CGSize(width:width, height: 65)
        }
    }
    
}
