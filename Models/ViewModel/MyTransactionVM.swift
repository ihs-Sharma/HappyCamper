//
//  MyTransactionVM.swift
//  HappyCamper
//
//  Created by wegile on 12/02/19.
//  Copyright © 2019 wegile. All rights reserved.
//

import UIKit

class MyTransactionVM {
    var alertMsg = String()
    var TransactionModelAry = [TransactionModel]()
    var planId = String()
    
    //MARK:--> SIGN UP API FUNCTION
    func myTransactionGetApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "user_id"   :   "\(Proxy.shared.userId())"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KTransaction)", params: param, showIndicator: true, completion: { (JSON) in
            
            self.alertMsg = JSON["message"] as? String ?? ""
            
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            
            if appResponse == 200 {
                
                if let bnrItemAry = JSON["data"] as? NSArray {
                    if bnrItemAry.count > 0 {
                        for i in 0..<bnrItemAry.count {
                            if let bnrDict = bnrItemAry[i] as? NSDictionary {
                                let TransactionModelObj =  TransactionModel()
                                TransactionModelObj.dictDetail(userDict : bnrDict)
                                self.TransactionModelAry.append(TransactionModelObj)
                            }
                        }
                    }
                }
                completion()
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
    
    func cancelPlanApi(_ completion:@escaping() -> Void) {
        
        let param = [
            "id" : "\(planId)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KTransaction)", params: param, showIndicator: true, completion: { (JSON) in
            
            self.alertMsg = JSON["message"] as? String ?? ""
            
            var appResponse = Int()
            appResponse = JSON["app_response"] as? Int ?? 0
            if appResponse == 200 {
                completion()
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
}

extension MyTransactionVC : UITableViewDelegate,UITableViewDataSource {
    
    //MARK:--> TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyTransactionVMObj.TransactionModelAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TransactionModelAryObj = MyTransactionVMObj.TransactionModelAry[indexPath.row]
        
        let cell = tblVw.dequeueReusableCell(withIdentifier: "MyTransactionTVC", for: indexPath) as! MyTransactionTVC
        
        if MyTransactionVMObj.TransactionModelAry.count != 0 {
            cell.lblSubscriptionId.text = TransactionModelAryObj.subscriptionId
            cell.lblCreatedAt.text = TransactionModelAryObj.createdAt
            cell.lblStatus.text = TransactionModelAryObj.transactionStatus
            cell.lblAmount.text = "$\(TransactionModelAryObj.transactionAmount)"
            cell.lblName.text   = TransactionModelAryObj.transactionName
            cell.lblEmail.text  = TransactionModelAryObj.transactionEmail
            
            if TransactionModelAryObj.transactionStatus.lowercased() == "cancel"
            {
                cell.status_lbl.text = "Cancelled"
                cell.status_lbl.isHidden = false
                cell.btnCancelPlan.isHidden = true
                cell.btnChangePlan.isHidden = true
            }
            else
            {
                cell.btnCancelPlan.isHidden = false
                cell.btnChangePlan.isHidden = false
                cell.status_lbl.isHidden = true
                cell.btnCancelPlan.tag = indexPath.row
                cell.btnCancelPlan.addTarget(self, action: #selector(btnCancelPlan), for: .touchUpInside)
                cell.btnChangePlan.tag = indexPath.row
                cell.btnChangePlan.addTarget(self, action: #selector(btnChangePlan), for: .touchUpInside)
            }
            
            cell.btnCancelPlan.isHidden = true
            cell.btnChangePlan.isHidden = true
            
            //varinder3
            if UIDevice.current.userInterfaceIdiom == .phone {
                
                cell.bgView.layer.shadowColor = UIColor.gray.cgColor
                cell.bgView.layer.shadowOpacity = 0.3
                cell.bgView.layer.shadowOffset = CGSize.zero
                cell.bgView.layer.shadowRadius = 3
                cell.bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
                
                cell.btnChangePlan.layer.cornerRadius =   cell.btnChangePlan.frame.size.height/2
                cell.btnCancelPlan.layer.cornerRadius =   cell.btnChangePlan.frame.size.height/2
                
//                cell.btnCancelPlan.isHidden = false
//                cell.btnChangePlan.isHidden = false
            }
        }
        
        return cell
    }
    
    //MARK:--> BUTTON CANCEL PLAN
    @objc func btnCancelPlan(sender: UIButton) {
        let TransactionModelAryObj = MyTransactionVMObj.TransactionModelAry[sender.tag]
        MyTransactionVMObj.planId = TransactionModelAryObj.subscriptionPlan
        MyTransactionVMObj.cancelPlanApi {
            Proxy.shared.presentAlert(withTitle: "", message: "\(self.MyTransactionVMObj.alertMsg)", currentViewController: self)
        }
    }
    
    //MARK:--> BUTTON CHANGE PLAN
    @objc func btnChangePlan(sender: UIButton){
        let TransactionModelAryObj = MyTransactionVMObj.TransactionModelAry[sender.tag]
        Proxy.shared.pushToNextVC(identifier: "SubscriptionDetailVIew", isAnimate: true, currentViewController: self) 
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 150
    //    }
    
    //varinder3
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 150
        }else{
            return 155;
        }
    }
}
