//
//  UpoadFilePopup.swift
//  HappyCamper
//
//  Created by Wegile on 11/04/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftSpinner
import SwiftyJSON
import AVFoundation

class UploadFilePopup: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Title: UITextField!
    @IBOutlet weak var txt_TellUs: UITextField!
    @IBOutlet weak var img_Check: UIImageView!

    var videoURL: URL?
    var unchecked = true

    var isFromContest = false
    var type_item = String()
    var contest_Id = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        let userName = Proxy.shared.selectedUserName()
        if KAppDelegate.UserModelObj.userName == "" {
            txt_Name.text! = userName
        } else {
            txt_Name.text! = KAppDelegate.UserModelObj.userName
        }
        txt_Email.text! = KAppDelegate.UserModelObj.userEmail
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCloseWindow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUploadFileAction(_ sender: Any) {
        
        if isFromContest {
            if type_item == "video"  {
                self.initializeImagePicker(isType:type_item)
            } else if type_item == "image" {
                self.initializeImagePicker(isType:type_item)
            } else {
                self.openCloudDrive()
            }
        } else {
            self.initializeImagePicker(isType:"video")
        }
    }
    
    func openCloudDrive() {
        
        var documentPickerController : UIDocumentPickerViewController?
        
        if type_item == "video"
        {
            documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypeMovie), String(kUTTypeVideo),String(kUTTypeAVIMovie),String(kUTTypeMPEG4)], in: .import)
        }
        if type_item == "image"
        {
            documentPickerController = UIDocumentPickerViewController(documentTypes: [ String(kUTTypeImage)], in: .import)
        }
        if type_item == "doc"
        {
            
            documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeFlatRTFD), String(kUTTypeRTFD), String(kUTTypeWebArchive)], in: .import)
        }
        
        documentPickerController?.delegate = self
        present(documentPickerController!, animated: true, completion: nil)
    }

    
    func initializeImagePicker(isType:String) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.allowsEditing=false
        if isType == "image" {
          imagePicker.sourceType = .photoLibrary
        } else {
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
            imagePicker.mediaTypes = ["public.movie"]
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnAllowTerms(_ sender: UIButton) {
        if unchecked {
            img_Check.image = UIImage(named:"check.jpg")
            unchecked = false
        }
        else {
            img_Check.image = UIImage(named:"Uncheck.jpg")
            unchecked = true
        }
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnSubmitAction(_ sender: Any) {
        self.validationInformation()
    }
    
    //MARK:--> VALIDATION TEXTFIELD
    @objc func validationInformation() {
        if txt_Name.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.firstname, currentViewController: self)
        } else if !Proxy.shared.isValidInput(txt_Name.text!) {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.validName, currentViewController: self)
        } else if  txt_Email.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: AlertValue.email, currentViewController: self)
        }  else if txt_Title.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "Please enter Title", currentViewController: self)
        } else if txt_TellUs.isBlank {
            Proxy.shared.presentAlert(withTitle: "", message: "Please enter Description", currentViewController: self)
        } else if unchecked == true {
            Proxy.shared.presentAlert(withTitle: "", message: "Please allow Happy Camper Terms and Policies", currentViewController: self)
        }  else if self.videoURL == nil || self.videoURL?.absoluteString == "" {
            Proxy.shared.presentAlert(withTitle: "", message: "Please select file to upload", currentViewController: self)
        } else {
            //  here you can see data bytes of selected video, this data object is upload to server by multipartFormData upload
            Proxy.shared.showActivityIndicator()
            var parameters = [String:String]()
            parameters = ["frontend_user_id":Proxy.shared.userId(),"first_name":txt_Name.text!,"user_email":txt_Email.text!,"video_title":txt_Title.text!,"video_description":txt_TellUs.text!]
            
            var fileParam = "video"
            var url_Api = "\(Apis.KServerUrl)\(Apis.KCampfireUploadVideo)"
            
            if self.isFromContest {
                fileParam = "contest"
                url_Api = "\(Apis.KServerUrl)\(Apis.KCampfireUploadContest)"
                parameters.removeAll()
                parameters = ["frontend_user_id":Proxy.shared.userId(),"first_name":txt_Name.text!,"user_email":txt_Email.text!,"title":txt_Title.text!,"description":txt_TellUs.text!,"type": type_item,"contest_id":contest_Id]
            }
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = TimeInterval(20)
            configuration.timeoutIntervalForRequest = TimeInterval(20)
            
            KAppDelegate.sessionManager = Alamofire.SessionManager(configuration: configuration)
            KAppDelegate.sessionManager.upload(multipartFormData: { (multipartFormData) in
                //                    multipartFormData.append(data, withName: "files")
                
                multipartFormData.append(self.videoURL!, withName: fileParam)
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, usingThreshold: UInt64.init(), to: url_Api, method: .post, headers: nil) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        SwiftSpinner.show(progress: progress.fractionCompleted, title: "Uploading...")
                    })
                    
                    upload.responseJSON { response in
                        SwiftSpinner.hide()
                    }
                    upload.responseJSON { response in
                        
                        if let err = response.error {
                            Proxy.shared.presentAlert(withTitle: "", message: err.localizedDescription , currentViewController: self)
                            Proxy.shared.hideActivityIndicator()
                            return
                        }
                        print("Succesfully uploaded")
                        guard let json = JSON.init(response.value ?? "").dictionary else {
                            return
                        }
                        Proxy.shared.hideActivityIndicator()
                        self.dismiss(animated: true, completion: {
                        })
                        self.perform(#selector(UploadFilePopup.dismissAlertController(message:)), with: json["message"]!.stringValue, afterDelay: 2.0)
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    Proxy.shared.hideActivityIndicator()
                }
            }
        }
    }

    @objc internal func dismissAlertController(message:String) {
        Proxy.shared.presentAlert(withTitle: "", message: message, currentViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
    }
    
    //MARK:- delegate of text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_Name {
            txt_Name.resignFirstResponder()
            txt_Name.becomeFirstResponder()
        } else if textField == txt_Email {
            txt_Email.resignFirstResponder()
            txt_Email.becomeFirstResponder()
        } else if textField == txt_Title {
            txt_Title.resignFirstResponder()
            txt_Title.becomeFirstResponder()
        } else {
            txt_TellUs.resignFirstResponder()
            txt_TellUs.becomeFirstResponder()
        }
        return true
    }
}

extension UploadFilePopup: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let url_Video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//            print(url_Video)
//            videoURL = url_Video
//        }
        
        //varinder9
        self.dismiss(animated: true, completion: nil)
        
        
        if let url_Video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print(url_Video)
            videoURL = url_Video
            
            // needed only for didFinishPickingMediaWithInfo
            let outputFileURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            
            // get the asset
            let asset = AVURLAsset(url: outputFileURL!)
            
            // get the time in seconds
            let durationInSeconds = asset.duration.seconds
            print("==== Duration is ",durationInSeconds)
            
            if  durationInSeconds < 3 {
                Proxy.shared.presentAlert(withTitle: "", message: "Please select video length atleast 3 sec", currentViewController: self)
                return
            }
        }
        
    
        
        if #available(iOS 11.0, *) {
            if let url_Image = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                print(url_Image)
                videoURL = url_Image
            }
        } else {
            
            let imageUrl          = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            let imageName         = imageUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
            let localPath         = photoURL.appendingPathComponent(imageName!)
            let image             = info[UIImagePickerController.InfoKey.originalImage]as! UIImage
            let data              = image.pngData()
            
            do
            {
                try data?.write(to: localPath!, options: Data.WritingOptions.atomic)
            }
            catch
            {
                // Catch exception here and act accordingly
            }
            // Fallback on earlier versions
        }
    
        
//        if let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL{
//
//            let imgName = imgUrl.lastPathComponent
//            let documentDirectory = NSTemporaryDirectory()
//            let localPath = documentDirectory.appending(imgName)
//
//            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
////            let data = UIImageJPEGRepresentation(image, 0.3)! as NSData
//            let data = image.jpegData(compressionQuality: 0.3)
//
////            data?.write(to: localPath, options: true)
//            let photoURL = URL.init(fileURLWithPath: localPath)
//
//        }

     //   self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UIDocumentMenuDelegates
extension UploadFilePopup :UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        if (url as URL?) != nil {
//            DispatchQueue.main.async {
//                let fileData = NSData(contentsOf: url)
//                //                self.gotToNext(array: [ UIImage.init(named: "icon_Docx") ?? ""
//                //                    ], url: [url],mediaType:"Documents", data: [fileData!])
//            }
//        }
//    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls as [URL]
        if url.count > 0 {
            videoURL = url[0]
            DispatchQueue.main.async {
                let fileData = NSData(contentsOf: url[0])
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}

