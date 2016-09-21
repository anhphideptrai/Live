//
//  ViewController.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/20/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit
import iCarousel

class ViewController: UIViewController{

    var category:                       CategoryLive?
    @IBOutlet weak var carouselView:    iCarousel!
    var timerLoad:                      Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupData), userInfo: nil, repeats: false)
    }

    func setupData(){
        category                = DownloadManager.sharedInstance.categories[7] as? CategoryLive
        carouselView.delegate   = self
        carouselView.dataSource = self
        carouselView.isPagingEnabled = true
        carouselView.bounces = false
    }
    
    func loadDataWith(){
        
        let tag         = carouselView.currentItemIndex
        let liveItem    = liveItemWith(idx: tag)
        let imgUrl      = Constants.SERVER_DATA + liveItem.category + "/" + liveItem.image
        let videoUrl    = Constants.SERVER_DATA + liveItem.category + "/" + liveItem.video
        
        let item        = DownloadItem()
        item.output_dir = category?.name
        item.url        = videoUrl

        DownloadManager.sharedInstance.downloadWith(item, progressHandler: {progress in
            print("Download Progress: \(Int(progress.fractionCompleted * 100))")
        }, tag: tag) { (isSussess, destinationURL, tag) in
            if isSussess {
                let urlVideo   = destinationURL
                item.output_dir = self.category?.name
                item.url        = imgUrl
                DownloadManager.sharedInstance.downloadWith(item, tag: tag, completionHandler: { (isSussess, destinationURL, tag) in
                    if isSussess {
                        let urlImage = destinationURL
                        if tag == self.carouselView.currentItemIndex {
                            (self.carouselView.currentItemView as! LivePhotoCustomView).loadLivePhotoWith(uRLPhoto: urlImage, uRLVideo: urlVideo)
                        }
                    }
                })
            }
        }
    }
    
    func liveItemWith(idx: Int) -> LiveItem{
        return LiveItem.parser(DownloadManager.sharedInstance.liveItems[(category?.liveItemIds?[idx])!]! as AnyObject)
    }
}

extension ViewController: iCarouselDataSource, iCarouselDelegate{
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return (category?.liveItemIds?.count)!
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var itemView: LivePhotoCustomView
        if (view == nil)
        {
            itemView = LivePhotoCustomView.init(frame: carousel.frame)
        }else{
            itemView = view as! LivePhotoCustomView
        }
        
        let liveItem = liveItemWith(idx: index)
        let imgUrl      = Constants.SERVER_DATA + liveItem.category + "/" + liveItem.image
        
        itemView.loadPhotoWith(uRLPhoto: URL.init(string: imgUrl)!)
        
        return itemView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if timerLoad != nil {
            timerLoad?.invalidate()
            timerLoad = nil
        }
        timerLoad = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadDataWith), userInfo: nil, repeats: false)
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .visibleItems {
            return 3
        }
        return value
    }
}

