//
//  CacheManager.swift
//  BeatBoxingVC
//
//  Created by Wegile on 21/03/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
public enum Result1<T> {
    case success(T)
    case failure(NSError)
}

class CacheManager {
    
    static let shared = CacheManager()
    
    private let fileManager = FileManager.default
    
    private lazy var mainDirectoryUrl: URL = {
        
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
    func getFileWith(stringUrl: String, completionHandler: @escaping (Result1<URL>) -> Void ) {
        let file = directoryFor(stringUrl: stringUrl)
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(Result1.success(file))
            return
        }
        
        DispatchQueue.global().async {
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)
                DispatchQueue.main.async {
                    completionHandler(Result1.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    let err = NSError()
                   // err = nil
                    completionHandler(Result1.failure(err))
                    
                    //completionHandler(Result.failure(NSError.errorWith(text: "Can't download video")))
                }
            }
        }
    }
    
    private func directoryFor(stringUrl: String) -> URL {        
        let fileURL = URL(string: stringUrl)!.lastPathComponent
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        return file
    }
}






