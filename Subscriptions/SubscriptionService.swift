/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import StoreKit

protocol PurchasedDidFinishDelegate {
    
    func purchaseDidFinish()
    
    
}






class SubscriptionService: NSObject {
  
    var delegate : PurchasedDidFinishDelegate?
  static let sessionIdSetNotification       = Notification.Name("SubscriptionServiceSessionIdSetNotification")
  static let optionsLoadedNotification      = Notification.Name("SubscriptionServiceOptionsLoadedNotification")
  static let restoreSuccessfulNotification  = Notification.Name("SubscriptionServiceRestoreSuccessfulNotification")
  static let purchaseSuccessfulNotification = Notification.Name("SubscriptionServiceRestoreSuccessfulNotification")
  
  static let shared = SubscriptionService()
  
  var hasReceiptData: Bool {
    return loadReceipt() != nil
  }
  
  var currentSessionId: String? {
    didSet {
        NotificationCenter.default.post(name: SubscriptionService.sessionIdSetNotification, object: currentSessionId)
    }
  }
  
  var currentSubscription: PaidSubscription?
  
  var options: [Subscription]? {
    didSet {
        NotificationCenter.default.post(name: SubscriptionService.optionsLoadedNotification, object: options)
    }
  }
  
  func loadSubscriptionOptions() {
    
    let productIDPrefix = Bundle.main.bundleIdentifier!
    
    let monthly = productIDPrefix + ".monthly"
    let quarterly  = productIDPrefix + ".quarterly"
    let yearly = productIDPrefix + ".yearly"
    
    let productIDs = Set([monthly, quarterly, yearly])
    
    let request = SKProductsRequest(productIdentifiers: productIDs)
    request.delegate = self
    request.start()
  }
  
  func purchase(subscription: Subscription) {
    let payment = SKPayment(product: subscription.product)
    SKPaymentQueue.default().add(payment)
  }
  
  func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
    func uploadReceipt(completion: (( _ success: Bool, _ currentSubscription:PaidSubscription?) -> Void)? = nil) {
        if let receiptData = loadReceipt() {
            SelfieService.shared.upload(receipt: receiptData) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let result):
                    
                    strongSelf.currentSessionId = result.sessionId
                    strongSelf.currentSubscription = result.currentSubscription
                    
                    completion?(true, result.currentSubscription)
                    
                case .failure(let error):
                    print("🚫 Receipt Upload Failed: \(error)")
            
                    
                    completion?(false, nil)
                }
            }
        }
    }
  
  private func loadReceipt() -> Data? {
    guard let url = Bundle.main.appStoreReceiptURL else {
      return nil
    }
    
    do {
      let data = try Data(contentsOf: url)
      return data
    } catch {
      print("Error loading receipt data: \(error.localizedDescription)")
      return nil
    }
  }
}

// MARK: - SKProductsRequestDelegate
extension SubscriptionService: SKProductsRequestDelegate {
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    options = response.products.map { Subscription(product: $0) }
  }
  
  func request(_ request: SKRequest, didFailWithError error: Error) {
    if request is SKProductsRequest {
      print("Subscription Options Failed Loading: \(error.localizedDescription)")
    }
  }
}
