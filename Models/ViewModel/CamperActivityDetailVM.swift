//
//  CamperActivityDetailVM.swift
//  HappyCamper
//
//  Created by wegile on 18/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CamperActivityDetailVM: NSObject {

}

extension CamperActivityDetailVC : UITableViewDelegate, UITableViewDataSource {
   //MARK:--> TABLE VIEW DELEGATE FUNCTION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 5 {
            let tblcell = tblVw.dequeueReusableCell(withIdentifier: "AdvertisementTVC", for: indexPath) as! AdvertisementTVC
            cell = tblcell
        } else if indexPath.row == 0 {
            let tblcell = tblVw.dequeueReusableCell(withIdentifier: "CamperActivityTodayCampTVC", for: indexPath) as! CamperActivityTodayCampTVC
            cell = tblcell
        } else {
            let tblcell = tblVw.dequeueReusableCell(withIdentifier: " CamperActivityTodayTVC", for: indexPath) as!  CamperActivityTodayTVC
            cell = tblcell
        }
        return cell
    }
    
}
