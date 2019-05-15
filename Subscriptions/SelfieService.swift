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

private let itcAccountSecret = "318513252bb941cb937e970329522e1c"

import Foundation

public enum Result<T> {
  case failure(SelfieServiceError)
  case success(T)
}

//public typealias LoadSelfieCompletion = (_ selfies: Result<[SelfieSet]>) -> Void
public typealias UploadReceiptCompletion = (_ result: Result<(sessionId: String, currentSubscription: PaidSubscription?)>) -> Void

public typealias SessionId = String

public enum SelfieServiceError: Error {
  case missingAccountSecret
  case invalidSession
  case noActiveSubscription
  case other(Error)
}

public class SelfieService {
  
  
  public static let shared = SelfieService()
  let simulatedStartDate: Date
  
  private var sessions = [SessionId: Session]()
  
  init() {
    let persistedDateKey = "RWSSimulatedStartDate"
    if let persistedDate = UserDefaults.standard.object(forKey: persistedDateKey) as? Date {
      simulatedStartDate = persistedDate
    } else {
      let date = Date().addingTimeInterval(-30)
        // 30 second difference to account for server/client drift.
      UserDefaults.standard.set(date, forKey: "RWSSimulatedStartDate")
      
      simulatedStartDate = date
    }
  }
  
  /// Trade receipt for session id
  public func upload(receipt data: Data, completion: @escaping UploadReceiptCompletion) {
    let body = [
      "receipt-data": data.base64EncodedString(),
      "password": itcAccountSecret
    ]
    let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
    
    let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = bodyData
    
    let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
      if let error = error {
        completion(.failure(.other(error)))
      } else if let responseData = responseData {
        let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as! Dictionary<String, Any>
        print(json)
        let session = Session(receiptData: data, parsedReceipt: json)
        self.sessions[session.id] = session
        let result = (sessionId: session.id, currentSubscription: session.currentSubscription)
        completion(.success(result))
      }
    }
    
    task.resume()
  }
  
  /// Use sessionId to get selfies
  private func paidSubcriptions(since date: Date, for sessionId: SessionId) -> [PaidSubscription] {
    if let session = sessions[sessionId] {
      let subscriptions = session.paidSubscriptions.filter { $0.purchaseDate >= date }
      return subscriptions.sorted { $0.purchaseDate < $1.purchaseDate }
    } else {
      return []
    }
  }
}

