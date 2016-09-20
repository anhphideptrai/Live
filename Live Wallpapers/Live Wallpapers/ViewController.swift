//
//  ViewController.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/20/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LivePhotoCustomViewDelegate{

    var urlImage: URL?
    var urlVideo: URL?
    @IBOutlet var livePhoto: LivePhotoCustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livePhoto.delegate = self
        livePhoto.isUserInteractionEnabled = true
        Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(ViewController.test), userInfo: nil, repeats: true)
    }
    
    func dataForLivePhotoView() -> (urlVideo: URL?, urlImage: URL?) {
        return (urlVideo, urlImage)
    }
    
    func test(){
        
        let category: CategoryLive = DownloadManager.sharedInstance.categories[17] as! CategoryLive
        let array = category.liveItemIds
        let randomIndex = Int(arc4random_uniform(UInt32((array?.count)!)))
        let output = array?[randomIndex] as! String
        let livePhoto: LiveItem = LiveItem.parser(DownloadManager.sharedInstance.liveItems[output]! as AnyObject)
        let item = DownloadItem()
        item.output_dir = output
        
        
        let imgUrl      = "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/"+livePhoto.category+"/"+livePhoto.image
        let videoUrl    = "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/"+livePhoto.category+"/"+livePhoto.video
        item.url        = videoUrl
        
        self.urlImage = URL.init(string: imgUrl)!
        self.livePhoto.reload()
        
        DownloadManager.sharedInstance.downloadWith(item) { (isSussess, destinationURL) in
            if isSussess {
                self.urlVideo   = destinationURL
                item.output_dir = output
                item.url        = imgUrl
                DownloadManager.sharedInstance.downloadWith(item, completionHandler: { (isSussess, destinationURL) in
                    if isSussess {
                        self.urlImage = destinationURL
                        self.livePhoto.reload()
                    }
                })
            }
        }
    }
    
}

