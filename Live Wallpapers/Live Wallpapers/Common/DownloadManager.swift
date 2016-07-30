//
//  DownloadManager.swift
//  Live Wallpapers
//
//  Created by Phi Nguyen on 7/26/16.
//  Copyright © 2016 Terralogic INC. All rights reserved.
//

import UIKit
import AFNetworking

class DownloadItem: NSObject {
    var url: String = ""
    var fileName: String!
    var output_dir: String!
}

class DownloadManager: AFURLSessionManager {
    class var sharedInstance: DownloadManager {
        struct Singleton {
            static let instance = DownloadManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        }
        return Singleton.instance
    }
    func downloadWith(item: DownloadItem) -> NSURLSessionDownloadTask{
        let request = NSURLRequest.init(URL: NSURL.init(string: item.url)!)
        let downloadTask = self.downloadTaskWithRequest(request, progress:{(progress) in
            
            print(progress.localizedDescription)
            
            }, destination:{(targetPath, response) -> NSURL in
                
            let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
            let fileName = (item.output_dir ?? "") + "/" + (item.fileName ?? response.suggestedFilename)
            return documents.URLByAppendingPathComponent(fileName)
            
            }, completionHandler:{(response, url, error) in
             
        })
        downloadTask.resume()
        return downloadTask
    }
}
