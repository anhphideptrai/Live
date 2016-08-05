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
    static func parser(json: AnyObject)->LiveItem{
        let item: LiveItem = LiveItem()
        let js: NSDictionary = json as! [NSDictionary: AnyObject]
        item.category = js["category"] as! String
        item.image = js["image"] as! String
        item.video = js["video"] as! String
        return item
    }
}
