//
//  DownloadManager.swift
//  Live Wallpapers
//
//  Created by Phi Nguyen on 7/26/16.
//  Copyright © 2016 Terralogic INC. All rights reserved.
//

import UIKit
import AFNetworking

class DownloadManager: AFURLSessionManager {
    class var sharedInstance: DownloadManager {
        struct Singleton {
            static let instance = DownloadManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        }
        return Singleton.instance
    }
    func downloadWith(url: NSURL) -> NSURLSessionDownloadTask{
        let request = NSURLRequest.init(URL: url)
        let downloadTask = self.downloadTaskWithRequest(request, progress:{(progress) in
            
            print(progress.localizedDescription)
            
            }, destination:{(targetPath, response) -> NSURL in
                
            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            return documents.URLByAppendingPathComponent(response.suggestedFilename!)
            
            }, completionHandler:{(response, url, error) in
             
        })
        downloadTask.resume()
        return downloadTask
    }
}
