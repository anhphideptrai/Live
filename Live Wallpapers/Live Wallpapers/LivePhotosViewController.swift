//
//  LivePhotosViewController.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/20/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit
import iCarousel
import Photos

class LivePhotosViewController: UIViewController{

    var category:                       CategoryLive?
    @IBOutlet weak var carouselView:    iCarousel!
    var timerLoad:                      Timer?
    var timerDate:                      Timer?
    var hideControls:                   Bool    = false
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        saveView.layer.masksToBounds             = true
        saveView.layer.borderWidth               = 1
        saveView.layer.borderColor               = UIColor.gray.cgColor
        saveView.layer.cornerRadius              = 30
        
        updateTime()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupData), userInfo: nil, repeats: false)
        timerDate = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func setupData(){
        category                = DownloadManager.sharedInstance.categories[0] as? CategoryLive
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
        
        let item        = DownloadItem()
        item.output_dir = category?.name
        item.url        = liveItem.urlStringVideo()

        DownloadManager.sharedInstance.downloadWith(item, progressHandler: {progress in
            self.progressView.progress = Float(progress.fractionCompleted)
        }, tag: tag) { (isSussess, destinationURL, tag) in
            if isSussess {
                let urlVideo   = destinationURL
                item.output_dir = self.category?.name
                item.url        = liveItem.urlStringImage()
                DownloadManager.sharedInstance.downloadWith(item, tag: tag, completionHandler: { (isSussess, destinationURL, tag) in
                    if isSussess {
                        let urlImage = destinationURL
                        if tag == self.carouselView.currentItemIndex {
                            (self.carouselView.currentItemView as! LivePhotoCustomView).loadLivePhotoWith(uRLPhoto: urlImage, uRLVideo: urlVideo)
                        }
                    }
                })
            }
            self.progressView.progress = 0
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
        progressView.progress = 0
        timerLoad = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadDataWith), userInfo: nil, repeats: false)
    }
    
    func showHideControls() -> () {
        hideControls        = !hideControls
        lbTime.isHidden     = hideControls
        lbDate.isHidden     = hideControls
        saveView.isHidden   = hideControls
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        let currentLiveItem = liveItemWith(idx: carouselView.currentItemIndex)
        if checkFileExists(currentLiveItem.urlLocalImage()) && checkFileExists(currentLiveItem.urlLocalVideo()){
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetCreationRequest.creationRequestForAssetFromImage(atFileURL: currentLiveItem.urlLocalImage()!)
                        request?.addResource(with: .pairedVideo, fileURL: currentLiveItem.urlLocalVideo()!, options: nil)
                    }) { (success, error) in
                        if success {
                            showAlertWith(message: Constants.Messages.MSG_SAVE_SUSSESS, viewController: self)
                        }else{
                            showAlertWith(message: Constants.Messages.MSG_CANNOT_SAVE, viewController: self)
                        }
                    }
                }else{
                    showAlertWith(message: Constants.Messages.MSG_NEED_ACCESS_PHOTOS, viewController: self)
                }
            })
        }else{
            showAlertWith(message: Constants.Messages.MSG_NEED_DOWNLOAD, viewController: self)
        }
    }
}

extension LivePhotosViewController: iCarouselDataSource, iCarouselDelegate{
    
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
        
        if checkFileExists(liveItem.urlLocalImage()) {
            itemView.loadPhotoWith(uRLPhoto: liveItem.urlLocalImage())
        }else{
            itemView.loadPhotoWith(uRLPhoto: liveItem.urlImage())
        }
        
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

