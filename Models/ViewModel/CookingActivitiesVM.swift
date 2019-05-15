//
//  CookingActivitiesVM.swift
//  HappyCamper
//
//  Created by wegile on 03/01/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class CookingActivitiesVM {
    
}

extension CookingActivitiesVC : UITableViewDelegate,UITableViewDataSource {
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionHeader.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "CookingActivitiesTVC", for: indexPath) as! CookingActivitiesTVC
        cell.lblHeader.text = sectionHeader[indexPath.row]
        cell.headerString = sectionHeader[indexPath.row]
        cell.colVw.tag = indexPath.row
        cell.currentCont = self
        cell.colVwReload()
        return cell
    }
}
