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
    var categories:NSArray = []
    var liveItems:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livePhoto.delegate = self
        DownloadManager.sharedInstance.getDataFromUrl(NSBundle.mainBundle().URLForResource("data", withExtension: "json")!) { (response, data, error) in
            
                let json:NSDictionary = data as! [NSDictionary: AnyObject]
                self.categories = CategoryLive.parser(json["Categories"]!)
                self.liveItems = json["data"] as! NSDictionary
                NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(ViewController.test), userInfo: nil, repeats: true)
        }
    }
    func dataForLivePhotoView() -> (urlVideo: NSURL?, urlImage: NSURL?) {
        return (urlVideo, urlImage)
    }
    func test(){
        let category: CategoryLive = self.categories[17] as! CategoryLive
        let array = category.liveItemIds
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        let output = array[randomIndex] as! String
        let livePhoto: LiveItem = LiveItem.parser(liveItems[output]!)
        let item = DownloadItem()
        item.output_dir = output
        item.url = "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/"+livePhoto.category+"/"+livePhoto.video
        print(item.url)
        DownloadManager.sharedInstance.downloadWith(item, progress:nil, completionHandler: {(response, url, error) in
            if (error != nil) {
                self.urlVideo = url
                item.output_dir = output
                item.url = "https://storage.googleapis.com/orgit-prod-bucket/6000334795177984/wallpaper_live/"+livePhoto.category+"/"+livePhoto.image
                print(item.url)
                DownloadManager.sharedInstance.downloadWith(item, progress: nil, completionHandler: { (response, url, error) in
                    if (error != nil) {
                        self.urlImage = url
                        self.livePhoto.reload()
                    }
                })
            }
        })
    }
}

