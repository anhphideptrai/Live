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
    static let SERVER_DATA     = "http://storage.googleapis.com/sweat_pea_apps/wallpaper_live/"
    struct Messages {
        static let MSG_TITLE_ALERT          = "Live Wallpapers"
        static let MSG_OK                   = "OK"
        static let MSG_CANNOT_SAVE          = "Live Wallpaper wasn't saved in PHOTOS."
        static let MSG_NEED_DOWNLOAD        = "Live Wallpaper need to be downloaded before you can save it."
        static let MSG_SAVE_SUSSESS         = "Live Wallpaper was saved in PHOTOS."
        static let MSG_NEED_ACCESS_PHOTOS   = "Live wallpaper wasn't saved in PHOTOS. Please allow Live Wallpapers access to PHOTOS in Settings/Privacy/Photos."
        static let MSG_RATING               = "Help make The Live Wallpapers even better. Rate us 5 stars!"
        static let MSG_RATE_5_STARS         = "Rate it 5 stars"
        static let MSG_DISMISS              = "Dismiss"
    }
    struct Ads {
        static let APP_ID                   = "ca-app-pub-1775449000819183~4391617956"
        static let NATIVE_ID                = "ca-app-pub-1775449000819183/2775283953"
        static let NATIVE_ID_LARGE          = "ca-app-pub-1775449000819183/1621451557"
        static let BANNER_ID                = "ca-app-pub-1775449000819183/9779539952"
        static let INTERSTITIAL_ID          = "ca-app-pub-1775449000819183/6627597151"
    }
    struct App {
        static let  URL_REVIEW              = "https://itunes.apple.com/app/viewContentsUserReviews?id=1163646809"
        static let  URL_APP                 = "https://itunes.apple.com/app/id1163646809?mt=8"
        static let  RATED                   = "RATED"
    }
}
