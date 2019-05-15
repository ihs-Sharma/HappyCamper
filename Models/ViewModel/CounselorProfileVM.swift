//
//  CounselorProfileVM.swift
//  HappyCamper
//
//  Created by wegile on 17/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CounselorProfileVM: NSObject {

}

extension CounselorProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:--> COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colVw.dequeueReusableCell(withReuseIdentifier: "CouselorProfileCVC", for: indexPath) as! CouselorProfileCVC
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
