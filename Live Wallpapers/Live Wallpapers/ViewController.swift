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
    var timerDate:                      Timer?
    var hideControls:                   Bool    = false
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        saveView.layer.masksToBounds             = true
        saveView.layer.borderWidth               = 1
        saveView.layer.borderColor               = UIColor.gray.cgColor
        saveView.layer.cornerRadius              = 25
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupData), userInfo: nil, repeats: false)
        timerDate = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func setupData(){
        category                = DownloadManager.sharedInstance.categories[7] as? CategoryLive
        carouselView.delegate   = self
        carouselView.dataSource = self
        carouselView.isPagingEnabled = true
        carouselView.bounces = false
        delayLoadData()
    }
    
    func updateTime(){
        lbTime.text = dateToTimeStringWith(date: Date())
        lbDate.text = dateToDateStringWith(date: Date())
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
    
    func delayLoadData(){
        if timerLoad != nil {
            timerLoad?.invalidate()
            timerLoad = nil
        }
        timerLoad = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadDataWith), userInfo: nil, repeats: false)
    }
    
    func showHideControls() -> () {
        hideControls        = !hideControls
        lbTime.isHidden     = hideControls
        lbDate.isHidden     = hideControls
        saveView.isHidden   = hideControls
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        
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
        delayLoadData()
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .visibleItems {
            return 3
        }
        return value
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        showHideControls()
    }
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        let livePhoto = carousel.currentItemView as! LivePhotoCustomView
        livePhoto.livePhotoView?.stopPlayback()
    }
}

