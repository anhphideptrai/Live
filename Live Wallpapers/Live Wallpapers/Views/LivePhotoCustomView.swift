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
import AlamofireImage

class LivePhotoCustomView: UIView {
    
    var livePhotoView:PHLivePhotoView?
    var imgView:UIImageView?
    
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
        imgView?.contentMode = .scaleToFill
        imgView?.backgroundColor = UIColor.clear
        
        livePhotoView = PHLivePhotoView.init()
        livePhotoView?.isMuted = true
        
        self.addSubview(imgView!)
        self.addSubview(livePhotoView!)
        
        addConstraintForView(imgView!)
        addConstraintForView(livePhotoView!)
    }
    
    fileprivate func addConstraintForView(_ subView: UIView){
        subView.translatesAutoresizingMaskIntoConstraints = false
        let topContraints = NSLayoutConstraint(item: subView, attribute:
            .top, relatedBy: .equal, toItem: self,
                  attribute: .top, multiplier: 1.0,
                  constant: 0)
        let bottomContraints  = NSLayoutConstraint(item: subView, attribute:
            .bottom, relatedBy: .equal, toItem: self,
                     attribute: .bottom, multiplier: 1.0,
                     constant: 0)
        let leftContraints  = NSLayoutConstraint(item: subView, attribute:
            .left, relatedBy: .equal, toItem: self,
                   attribute: .left, multiplier: 1.0,
                   constant: 0)
        let rightontraints  = NSLayoutConstraint(item: subView, attribute:
            .right, relatedBy: .equal, toItem: self,
                    attribute: .right, multiplier: 1.0,
                    constant: 0)
        self.addConstraint(topContraints)
        self.addConstraint(bottomContraints)
        self.addConstraint(leftContraints)
        self.addConstraint(rightontraints)
    }

    func loadLivePhotoWith(uRLPhoto: URL?, uRLVideo: URL?){
        if (uRLPhoto != nil && uRLVideo != nil) {
            PHLivePhoto.request(withResourceFileURLs: [uRLVideo!, uRLPhoto!], placeholderImage: nil, targetSize: CGSize.zero, contentMode: .aspectFill, resultHandler: { (livePhoto, infoDict) in
                self.livePhotoView?.isHidden = false
                self.livePhotoView?.livePhoto = livePhoto
                self.livePhotoView?.startPlayback(with: .full)
            })
        }
    }
    
    func loadPhotoWith(uRLPhoto: URL?){
        imgView?.image = nil
        livePhotoView?.stopPlayback()
        livePhotoView?.isHidden = true
        if uRLPhoto != nil {
            imgView?.af_setImage(withURL: uRLPhoto!)
        }
    }
}
