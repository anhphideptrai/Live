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
    
}
