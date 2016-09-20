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
    
    class var sharedInstance: DownloadManager {
        struct Singleton {
            static let instance = DownloadManager.init()
        }
        Singleton.instance.loadData()
        return Singleton.instance
    }
    /* Get Document URL */
    func getDocumentDirectory() -> URL{
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    /* Create Downloaded folder if not exists */
    fileprivate func createdFolderIfNotExists(_ path: String) -> Bool{
        let documents = getDocumentDirectory()
        if !checkFileExists(path){
            do {
                try FileManager.default.createDirectory(atPath: documents.appendingPathComponent(path).path, withIntermediateDirectories: false, attributes: nil)
            } catch{
                return false
            }
        }
        return true
    }
    
    /* Check File/Folder is exists */
    func checkFileExists(_ path: String) -> Bool{
        return FileManager.default.fileExists(atPath: getDocumentDirectory().appendingPathComponent(path).path)
    }
    
    func downloadWith(_ item: DownloadItem, progressHandler: Request.ProgressHandler? = nil, completionHandler: @escaping (_ isSussess: Bool, _ urlDestination: URL?) -> ()) -> (){
        
        let destination: DownloadRequest.DownloadFileDestination = { url, response in
            let target = Constants.DOWNLOAD_FOLDER + item.output_dir! + "/" + response.suggestedFilename!
            let documentsURL = self.getDocumentDirectory()
            let fileURL = documentsURL.appendingPathComponent(target)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(item.url, to: destination)
            .downloadProgress { progress in
                if progressHandler != nil{
                    progressHandler!(progress)
                }
            }
            .responseData { response in
                switch response.result {
                case .success:
                    completionHandler(true, response.destinationURL)
                case .failure:
                    completionHandler(false, nil)
                }
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
}
