//
//  DownloadManager.swift
//  Live Wallpapers
//
//  Created by Phi Nguyen on 7/26/16.
//  Copyright © 2016 Terralogic INC. All rights reserved.
//

import UIKit
import AFNetworking

struct Constants {
    static let DOWNLOAD_FOLDER = "DOWNLOADED/"
}

class DownloadItem: NSObject {
    var url: String = ""
    var fileName: String?
    var output_dir: String?
}

class DownloadManager: AFURLSessionManager {
    class var sharedInstance: DownloadManager {
        struct Singleton {
            static let instance = DownloadManager.init(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        }
        return Singleton.instance
    }
    /* Get Document URL */
    func getDocumentDirectory() -> NSURL{
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    }
    /* Create Downloaded folder if not exists */
    private func createdFolderIfNotExists(path: String) -> Bool{
        let documents = getDocumentDirectory()
        if !checkFileExists(path){
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(documents.URLByAppendingPathComponent(path).path!, withIntermediateDirectories: false, attributes: nil)
            } catch{
                return false
            }
        }
        return true
    }
    /* Check File/Folder is exists */
    func checkFileExists(path: String) -> Bool{
        return NSFileManager.defaultManager().fileExistsAtPath(getDocumentDirectory().URLByAppendingPathComponent(path).path!)
    }
    func downloadWith(item: DownloadItem, progress: ((NSProgress) -> Void)?, completionHandler:((NSURLResponse?, NSURL?, NSError?) -> Void)?) -> NSURLSessionDownloadTask?{
        let url = NSURL.init(string: item.url)!
        let documents = self.getDocumentDirectory()
        let target = Constants.DOWNLOAD_FOLDER + item.output_dir! + "/" + url.lastPathComponent!
        if checkFileExists(target) {
            let myCompletionHandler: (NSURLResponse?, NSURL?, NSError?) -> Void = completionHandler!
            myCompletionHandler(nil, documents.URLByAppendingPathComponent(Constants.DOWNLOAD_FOLDER + item.output_dir! + "/" + url.lastPathComponent!), nil)
            return nil
        }
        /* Create Downloaded folder if not exists */
        self.createdFolderIfNotExists(Constants.DOWNLOAD_FOLDER)
        
        let request = NSURLRequest.init(URL: url)
        let downloadTask = downloadTaskWithRequest(request, progress:progress, destination:{(targetPath, response) -> NSURL in
            let dir = Constants.DOWNLOAD_FOLDER + (item.output_dir ?? "")
            self.createdFolderIfNotExists(dir)
            let fileName = (dir != "" ? dir + "/" : "") + (item.fileName ?? response.suggestedFilename!)
            return documents.URLByAppendingPathComponent(fileName)
            
            }, completionHandler:completionHandler)
        downloadTask.resume()
        return downloadTask
    }
}
