//
//  PhotoCollectionViewCell.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/22/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    private var imgView:UIImageView?
    private var loading: UIActivityIndicatorView?
    
    
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
        
        self.addSubview(imgView!)
        
        addConstraintForView(imgView!, self)
        
    }
    
    func loadImageWith(uRLImage: URL?){
        imgView?.af_cancelImageRequest()
        imgView?.image = nil
        if uRLImage != nil {
            imgView?.af_setImage(withURL: uRLImage!)
        }
    }
}
