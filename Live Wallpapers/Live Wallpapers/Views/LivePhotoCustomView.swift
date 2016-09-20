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

protocol LivePhotoCustomViewDelegate {
    func dataForLivePhotoView() -> (urlVideo: URL?, urlImage: URL?)
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
        imgView?.contentMode = .scaleToFill
        imgView?.backgroundColor = UIColor.clear
        
        livePhotoView = PHLivePhotoView.init()
        
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
    
    func reload(){
        if delegate != nil {
            let urlImage = delegate?.dataForLivePhotoView().urlImage
            let urlVideo = delegate?.dataForLivePhotoView().urlVideo
            if (urlImage != nil) {
                imgView?.af_setImage(withURL: urlImage!)
            }
            if (urlImage != nil && urlVideo != nil) {
                PHLivePhoto.request(withResourceFileURLs: [urlVideo!, urlImage!], placeholderImage: nil, targetSize: CGSize.zero, contentMode: .aspectFill, resultHandler: { (livePhoto, infoDict) in
                    self.livePhotoView?.livePhoto = livePhoto
                    self.livePhotoView?.startPlayback(with: PHLivePhotoViewPlaybackStyle.full)
                })
            }
        }
    }
}
