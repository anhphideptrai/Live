//
//  DownloadManager.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/20/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit
import Alamofire

class DownloadItem: NSObject {
    var url: String = ""
    var fileName: String?
    var output_dir: String?
}

class DownloadManager: NSObject {
    
    var categories:NSArray      = []
    var liveItems:NSDictionary  = [:]
    private var loadedData      = false
    var download: DownloadRequest?
    
    class var sharedInstance: DownloadManager {
        struct Singleton {
            static let instance = DownloadManager.init()
        }
        Singleton.instance.loadData()
        return Singleton.instance
    }
    
    func downloadWith(_ item: DownloadItem, progressHandler: Request.ProgressHandler? = nil, tag: Int = 0, completionHandler: @escaping (_ isSussess: Bool, _ urlDestination: URL?, _ tag: Int) -> ()) -> (){
        
        if download != nil{
            download?.cancel()
        }
        
        if !checkFileExists(urlLocalWith(item)) {
            
            let destination: DownloadRequest.DownloadFileDestination = { url, response in
                return (self.urlLocalWith(item)!, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            download = Alamofire.download(item.url, to: destination)
                .downloadProgress { progress in
                    if progressHandler != nil{
                        progressHandler!(progress)
                    }
                }
                
                download?.responseData { response in
                    switch response.result {
                    case .success:
                        completionHandler(true, response.destinationURL, tag)
                    case .failure:
                        completionHandler(false, nil, tag)
                    }
            }
        }else{
            completionHandler(true, urlLocalWith(item), tag)
        }
        
    }
    
    private func loadData() -> (){
        if !loadedData {
            Alamofire.request(Bundle.main.url(forResource: "data", withExtension: "json")!).responseJSON(completionHandler: { (response) in
                if let json = response.result.value as? [String: AnyObject] {
                    self.loadedData = true
                    self.categories = CategoryLive.parser(json["Categories"]! as AnyObject)
                    self.liveItems = json["data"] as! NSDictionary
                }
            })
        }
    }
    
    func urlLocalWith(_ item: DownloadItem) -> URL?{
        let target = Constants.DOWNLOAD_FOLDER + item.output_dir! + "/" + item.url.components(separatedBy: "/").last!
        return urlLocal(target)
    }
    
}
