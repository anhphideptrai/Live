//
//  ViewController.swift
//  Live Wallpapers
//
//  Created by Phi Nguyen on 7/23/16.
//  Copyright © 2016 Terralogic INC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LivePhotoCustomViewDelegate {
    @IBOutlet weak var livePhoto: LivePhotoCustomView!

    override func viewDidLoad() {
        super.viewDidLoad()
        livePhoto.delegate = self
        livePhoto.reload()
        DownloadManager.sharedInstance.downloadWith(NSURL.init(string: "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/TheNewest/thenewest12.mov")!)
    }
    
    func dataForLivePhotoView() -> (urlVideo: String?, urlImage: String?) {
        return ("https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/TheNewest/thenewest12.mov", "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/TheNewest/thenewest12.jpg")
    }

}

