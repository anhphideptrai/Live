//
//  LiveItem.swift
//  Live Wallpapers
//
//  Created by Phi Nguyen on 8/5/16.
//  Copyright © 2016 Terralogic INC. All rights reserved.
//

import UIKit

class LiveItem: NSObject {
    var category: String = ""
    var image: String = ""
    var video: String = ""
    static func parser(_ json: AnyObject)->LiveItem{
        let item: LiveItem = LiveItem()
        let js: NSDictionary = json as! [NSDictionary: AnyObject] as NSDictionary
        item.category = js["category"] as! String
        item.image = js["image"] as! String
        item.video = js["video"] as! String
        return item
    }
    
    func urlLocalImage() -> URL?{
        let target = Constants.DOWNLOAD_FOLDER + category + "/" + image.components(separatedBy: "/").last!
        return urlLocal(target)
    }
    
    func urlLocalVideo() -> URL?{
        let target = Constants.DOWNLOAD_FOLDER + category + "/" + video.components(separatedBy: "/").last!
        return urlLocal(target)
    }
    
    func urlImage() -> URL? {
        return URL.init(string: urlStringImage())
    }

    func urlVideo() -> URL? {
        return URL.init(string: urlStringVideo())
    }
    
    func urlStringImage() -> String {
        return Constants.SERVER_DATA + category + "/" + image
    }
    
    func urlStringVideo() -> String {
        return Constants.SERVER_DATA + category + "/" + video
    }
}
