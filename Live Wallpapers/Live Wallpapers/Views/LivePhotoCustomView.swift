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
        
        addConstraintForView(imgView!, self)
        addConstraintForView(livePhotoView!, self)
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
        imgView?.af_cancelImageRequest()
        imgView?.image = nil
        livePhotoView?.stopPlayback()
        livePhotoView?.isHidden = true
        if uRLPhoto != nil {
            imgView?.af_setImage(withURL: uRLPhoto!)
        }
    }
}
