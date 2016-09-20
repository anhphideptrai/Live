//
//  Category.swift
//  Live Wallpapers
//
//  Created by Phi Nguyen on 8/5/16.
//  Copyright © 2016 Terralogic INC. All rights reserved.
//

import UIKit

class CategoryLive: NSObject {
    var name: String = ""
    var liveItemIds: NSArray?
    
    static func parser(_ categoriesJs: AnyObject) -> NSArray{
        let result: NSMutableArray = NSMutableArray()
        let categories: NSDictionary = categoriesJs as! [NSDictionary: AnyObject] as NSDictionary
        for key in categories.allKeys {
            let categoryLive: CategoryLive = CategoryLive()
            categoryLive.name = key as! String
            categoryLive.liveItemIds = NSArray.init(array: categories[categoryLive.name] as! NSArray)
            result.add(categoryLive)
        }
        return result
    }
}

