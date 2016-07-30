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
    var urlImage: NSURL?
    var urlVideo: NSURL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livePhoto.delegate = self
        test()
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(ViewController.test), userInfo: nil, repeats: true)
    }
    
    func dataForLivePhotoView() -> (urlVideo: NSURL?, urlImage: NSURL?) {
        return (urlVideo, urlImage)
    }
    func test(){
        let array = ["218", "12", "165", "149", "16", "215", "128", "57", "305", "36", "220"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        let output = array[randomIndex]
        let item = DownloadItem()
        item.output_dir = output
        item.url = "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/TheNewest/thenewest"+output+".mov"
        DownloadManager.sharedInstance.downloadWith(item, progress:nil, completionHandler: {(response, url, error) in
            self.urlVideo = url
            item.output_dir = output
            item.url = "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/TheNewest/thenewest"+output+".jpg"
            DownloadManager.sharedInstance.downloadWith(item, progress: nil, completionHandler: { (response, url, error) in
                self.urlImage = url
                self.livePhoto.reload()
            })
        })
    }
}

