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
import GoogleMobileAds

class LivePhotosViewController: UIViewController{

    public          var liveItems               = [LiveItem]()
    public          var firstItemIndex:         Int     = 0
    public          var frameCarousel:          CGRect?
    
    private         var timerLoad:              Timer?
    private         var timerDate:              Timer?
    fileprivate     var hideControls:           Bool    = false
    
    @IBOutlet weak  var carouselView:           iCarousel!
    @IBOutlet weak  var lbTime:                 UILabel!
    @IBOutlet weak  var lbDate:                 UILabel!
    @IBOutlet weak  var saveView:               UIView!
    @IBOutlet weak  var btnSave:                UIButton!
    @IBOutlet weak  var backView:               UIView!
    @IBOutlet weak  var backHideView:           UIView!
    @IBOutlet weak  var progressView:           UIProgressView!
    @IBOutlet weak  var bottomView:             UIView!
                    var nativeExpressAdView:    GADNativeExpressAdView!
                    var adsRemoved:             Bool = true
    @IBOutlet weak var bannerAds:               GADBannerView!
    @IBOutlet weak var heightBannerAds:         NSLayoutConstraint!
    @IBOutlet weak var bottomOfBottomView:      NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nativeExpressAdView                         = GADNativeExpressAdView(frame: CGRect(x: 10, y: (self.view.bounds.size.height - 350 - 10), width: self.view.bounds.size.width - 20, height: 350))
        nativeExpressAdView.adUnitID                = Constants.Ads.NATIVE_ID_LARGE
        nativeExpressAdView.rootViewController = self
        nativeExpressAdView.load(getRequestAds())
        
        nativeExpressAdView.layer.masksToBounds     = true
        nativeExpressAdView.layer.cornerRadius      = 8
        
        saveView.layer.masksToBounds                = true
        saveView.layer.borderWidth                  = 1
        saveView.layer.borderColor                  = UIColor.gray.cgColor
        saveView.layer.cornerRadius                 = 30
        
        backView.layer.masksToBounds                = true
        backView.layer.borderWidth                  = 1
        backView.layer.borderColor                  = UIColor.gray.cgColor
        backView.layer.cornerRadius                 = 15
        
        updateTime()
        timerDate                                   = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        setupData()
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(delayLoadBannerAds), userInfo: nil, repeats: false)
        
    }
    
    func delayLoadBannerAds(){
        bannerAds.adUnitID              = Constants.Ads.BANNER_ID
        bannerAds.rootViewController    = self
        bannerAds.load(getRequestAds())
    }
    
    func setupData(){
        carouselView.delegate           = self
        carouselView.dataSource         = self
        carouselView.isPagingEnabled    = true
        carouselView.bounces            = false
        carouselView.currentItemIndex   = firstItemIndex
        delayLoadData()
    }
    
    func updateTime(){
        lbTime.text = dateToTimeStringWith(date: Date())
        lbDate.text = dateToDateStringWith(date: Date())
    }
    
    func loadData(){
        
        let tag = carouselView.currentItemIndex
        if tag < liveItems.count {
            let liveItem    = liveItems[tag]
            
            let item        = DownloadItem()
            item.output_dir = liveItem.category
            item.url        = liveItem.urlStringVideo()
            
            DownloadManager.sharedInstance.downloadWith(item, progressHandler: {progress in
                self.progressView.progress = Float(progress.fractionCompleted)
            }, tag: tag) { (isSussess, destinationURL, tag) in
                if isSussess {
                    let urlVideo   = destinationURL
                    item.output_dir = liveItem.category
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
    }
    
    func delayLoadData(){
        if timerLoad != nil {
            timerLoad?.invalidate()
            timerLoad = nil
        }
        progressView.progress = 0
        timerLoad = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadData), userInfo: nil, repeats: false)
    }
    
    func showHideControls() -> () {
        hideControls            = !hideControls
        lbTime.isHidden         = hideControls
        lbDate.isHidden         = hideControls
        bottomView.isHidden     = hideControls
        bannerAds.isHidden      = hideControls
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        let currentLiveItem = liveItems[carouselView.currentItemIndex]
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
    
    @IBAction func backAction(_ sender: AnyObject) {
        
        if timerDate != nil {
            timerDate?.invalidate()
            timerDate = nil
        }
        if timerLoad != nil {
            timerLoad?.invalidate()
            timerLoad = nil
        }
        
        if DownloadManager.sharedInstance.download != nil {
            DownloadManager.sharedInstance.download?.cancel()
        }
        
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
}

extension LivePhotosViewController: iCarouselDataSource, iCarouselDelegate{
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return liveItems.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var itemView: LivePhotoCustomView
        if (view == nil)
        {
            itemView = LivePhotoCustomView()
        }else{
            itemView = view as! LivePhotoCustomView
        }
        
        itemView.frame = frameCarousel != nil ? frameCarousel! : carousel.frame
        let liveItem = liveItems[index]
        
        if checkFileExists(liveItem.urlLocalImage()) {
            itemView.loadPhotoWith(uRLPhoto: liveItem.urlLocalImage())
        }else{
            itemView.loadPhotoWith(uRLPhoto: liveItem.urlImage())
        }
        if index % 7 == 0 && index != 0 {
            adsRemoved = false
            nativeExpressAdView.removeFromSuperview()
            itemView.addSubview(nativeExpressAdView)
        }
        return itemView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if !adsRemoved {
            let idx         = carousel.currentItemIndex
            hideControls    = !(idx % 7 == 0 && idx != 0)
            showHideControls()
            if ((idx + 2) % 7 == 0 || (idx - 2) % 7 == 0) {
                adsRemoved  = true
                nativeExpressAdView.removeFromSuperview()
            }
        }
        delayLoadData()
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .visibleItems {
            return 3
        }
        return value
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if index != 0 && index % 7 == 0 && !adsRemoved{
            adsRemoved      = true
            nativeExpressAdView.removeFromSuperview()
        }
        showHideControls()
    }
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        let livePhoto = carousel.currentItemView as! LivePhotoCustomView
        livePhoto.livePhotoView?.stopPlayback()
    }
}
extension LivePhotosViewController: GADBannerViewDelegate{
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        heightBannerAds.constant    = 50
        bottomOfBottomView.constant = 50
    }
}
