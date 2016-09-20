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
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(test), userInfo: nil, repeats: false)
    }

    func dataForLivePhotoView() -> (urlVideo: URL?, urlImage: URL?) {
        return (urlVideo, urlImage)
    }
    func test() -> () {
        loadDataWith()
    }
    func loadDataWith(index: Int = 0) -> (){
        
        let category: CategoryLive = DownloadManager.sharedInstance.categories[index] as! CategoryLive
        let array = category.liveItemIds
        let randomIndex = Int(arc4random_uniform(UInt32((array?.count)!)))
        let output = array?[randomIndex] as! String
        let livePhoto: LiveItem = LiveItem.parser(DownloadManager.sharedInstance.liveItems[output]! as AnyObject)
        
        let item = DownloadItem()
        item.output_dir = output
        let imgUrl      = Constants.SERVER_DATA + livePhoto.category + "/" + livePhoto.image
        let videoUrl    = Constants.SERVER_DATA + livePhoto.category + "/" + livePhoto.video
        item.url        = videoUrl
        
        self.urlImage = URL.init(string: imgUrl)!
        self.livePhoto.reload()
        
        DownloadManager.sharedInstance.downloadWith(item) { (isSussess, destinationURL, index) in
            if isSussess {
                self.urlVideo   = destinationURL
                item.output_dir = output
                item.url        = imgUrl
                DownloadManager.sharedInstance.downloadWith(item, completionHandler: { (isSussess, destinationURL, index) in
                    if isSussess {
                        self.urlImage = destinationURL
                        self.livePhoto.reload()
                    }
                })
            }
        }
    }
    
}

