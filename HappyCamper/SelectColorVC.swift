//
//  SelectColorVC.swift
//  HappyCamper
//
//  Created by wegile on 24/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class SelectColorCVC: UICollectionViewCell {
    override var isSelected: Bool{
        didSet{
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.1, y: 1.2) : CGAffineTransform.identity
            }, completion: nil)
        }
    }
}

//MARK:--> PROTOCOLS METHODS
var SelectAviatorImageObj : SelectAviatorImage?

protocol SelectAviatorImage {
    func selectedImage(index: Int);
}


class SelectColorBannerCVC: UICollectionViewCell {
    //MARK:-> IBOUTLETS
    @IBOutlet weak var imgVwBanner: UIImageView!
}

class SelectColorVC: UIViewController {

    //MARK:--> IBOUTLETS
    @IBOutlet weak var colVwIconBanner: UICollectionView!
    @IBOutlet weak var btnGreen: UIButton!
    @IBOutlet weak var btnPurple: UIButton!
    @IBOutlet weak var vwBckgroundColor: SetCornerView!
    @IBOutlet weak var imgVwTop: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    //MARK:--> VARIABLES
    var SelectColorVMObj = SelectColorVM()
    var selectedButton = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text! = KAppDelegate.UserModelObj.userName
        
        let slectedAviator = Proxy.shared.selectedAviatorImage()
        if slectedAviator != "" {
            imgVwTop.sd_setImage(with: URL.init(string: "\(slectedAviator)"),placeholderImage: #imageLiteral(resourceName: "Group 12-1"), completed: nil)
        }
        selectedButton = "Purple"
        vwBckgroundColor.backgroundColor = UIColor(red: 74/255, green: 48/255, blue: 129/255, alpha: 1)
        SelectColorVMObj.postAviatorApi {
            self.colVwIconBanner.reloadData()
        }
    }
    
    //MARK:--> BUTTON ACTIONS
    @IBAction func btnPurpleAction(_ sender: Any) {
        SelectColorVMObj.AviatorModelAry = []
        selectedButton = "Purple"
        vwBckgroundColor.backgroundColor = UIColor(red: 74/255, green: 48/255, blue: 129/255, alpha: 1)
        SelectColorVMObj.postAviatorApi {
            self.colVwIconBanner.reloadData()
        }
    }

    @IBAction func btnGreenAction(_ sender: Any) {
        SelectColorVMObj.AviatorModelAry = []
        selectedButton = "Green"
        vwBckgroundColor.backgroundColor = UIColor(red: 103/255, green: 178/255, blue: 72/255, alpha: 1)
        SelectColorVMObj.postAviatorApi {
            self.colVwIconBanner.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
