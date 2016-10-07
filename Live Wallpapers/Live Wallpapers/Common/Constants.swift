//
//  Constants.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/20/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import Foundation

struct Constants {
    static let DOWNLOAD_FOLDER = "DOWNLOADED/"
    static let SERVER_DATA     = "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/"
    struct Messages {
        static let MSG_TITLE_ALERT          = "Live Wallpapers"
        static let MSG_OK                   = "OK"
        static let MSG_CANNOT_SAVE          = "Live Wallpaper wasn't saved in PHOTOS."
        static let MSG_NEED_DOWNLOAD        = "Live Wallpaper need downloaded before you can save it."
        static let MSG_SAVE_SUSSESS         = "Live Wallpaper was saved in PHOTOS."
        static let MSG_NEED_ACCESS_PHOTOS   = "Live wallpaper wasn't saved in PHOTOS. Please allow Live Wallpapers access to PHOTOS in Settings/Privacy/Photos."
    }
    struct Ads {
        static let APP_ID                   = "ca-app-pub-1775449000819183~4391617956"
        static let NATIVE_ID                = "ca-app-pub-1775449000819183/2775283953"
        static let NATIVE_ID_LARGE          = "ca-app-pub-1775449000819183/1621451557"
    }
}
