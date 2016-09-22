//
//  PhotoCollectionViewCell.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/22/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    private var imgView:    UIImageView?
    private var loading:    UIActivityIndicatorView?
    private var bgView:     UIView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    func initCommon(){
        
        imgView                     = UIImageView()
        imgView?.contentMode        = .scaleToFill
        imgView?.backgroundColor    = UIColor.clear
        
        loading = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loading?.hidesWhenStopped   = true
        
        bgView                      = UIView()
        bgView?.alpha               = 0.1
        bgView?.backgroundColor     = UIColor.lightGray
        
        self.addSubview(bgView!)
        self.addSubview(imgView!)
        self.addSubview(loading!)
        
        addConstraintForView(bgView!, self)
        addConstraintForView(imgView!, self)
        addConstraintForView(loading!, self)
        
    }
    
    func loadImageWith(uRLImage: URL?){
        imgView?.af_cancelImageRequest()
        loading?.startAnimating()
        imgView?.image = nil
        if uRLImage != nil {
            imgView?.af_setImage(withURL: uRLImage!){ response in
                let image = response.result.value
                if  image != nil{
                    self.loading?.stopAnimating()
                    self.imgView?.image = image
                }
            }
        }
    }
}
