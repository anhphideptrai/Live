//
//  LivePhotoCustomView.swift
//  Live Wallpapers
//
//  Created by Phi Nguyen on 7/24/16.
//  Copyright © 2016 Terralogic INC. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import AFNetworking.UIImageView_AFNetworking

protocol LivePhotoCustomViewDelegate {
    func dataForLivePhotoView() -> (urlVideo: NSURL?, urlImage: NSURL?)
}
class LivePhotoCustomView: UIView {
    
    var livePhotoView:PHLivePhotoView?
    var imgView:UIImageView?
    var delegate:LivePhotoCustomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    func initCommon(){
        imgView = UIImageView()
        imgView?.contentMode = .ScaleToFill
        imgView?.backgroundColor = UIColor.clearColor()
        
        livePhotoView = PHLivePhotoView.init()
        
        self.addSubview(imgView!)
        self.addSubview(livePhotoView!)
        
        addConstraintForView(imgView!)
        addConstraintForView(livePhotoView!)
    }
    
    private func addConstraintForView(subView: UIView){
        subView.translatesAutoresizingMaskIntoConstraints = false
        let topContraints = NSLayoutConstraint(item: subView, attribute:
            .Top, relatedBy: .Equal, toItem: self,
                  attribute: .Top, multiplier: 1.0,
                  constant: 0)
        let bottomContraints  = NSLayoutConstraint(item: subView, attribute:
            .Bottom, relatedBy: .Equal, toItem: self,
                     attribute: .Bottom, multiplier: 1.0,
                     constant: 0)
        let leftContraints  = NSLayoutConstraint(item: subView, attribute:
            .Left, relatedBy: .Equal, toItem: self,
                   attribute: .Left, multiplier: 1.0,
                   constant: 0)
        let rightontraints  = NSLayoutConstraint(item: subView, attribute:
            .Right, relatedBy: .Equal, toItem: self,
                    attribute: .Right, multiplier: 1.0,
                    constant: 0)
        self.addConstraint(topContraints)
        self.addConstraint(bottomContraints)
        self.addConstraint(leftContraints)
        self.addConstraint(rightontraints)
    }
    
    func reload(){
        if delegate != nil {
            let urlImage = delegate?.dataForLivePhotoView().urlImage
            let urlVideo = delegate?.dataForLivePhotoView().urlVideo
            if (urlImage != nil) {
                imgView?.setImageWithURL(urlImage!)
            }
            if (urlImage != nil && urlVideo != nil) {
                PHLivePhoto.requestLivePhotoWithResourceFileURLs([urlVideo!, urlImage!], placeholderImage: nil, targetSize: CGSize.zero, contentMode: .AspectFill, resultHandler: { (livePhoto, infoDict) in
                    self.livePhotoView?.livePhoto = livePhoto
                    self.livePhotoView?.startPlaybackWithStyle(PHLivePhotoViewPlaybackStyle.Full)
                })
            }
        }
    }
}
