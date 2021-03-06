//
//  ViewController.swift
//  Screen Shot
//
//  Created by Nguyen Duc Phi on 9/25/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bgImageView:         UIImageView!
    @IBOutlet weak var bgView:              UIView!
    @IBOutlet weak var borderIphoneView:    UIView!
    @IBOutlet weak var speakerView:         UIView!
    @IBOutlet weak var insideIphoneView:    UIView!
    @IBOutlet weak var insideImageView:     UIImageView!
    @IBOutlet weak var lbTime:              UILabel!
    @IBOutlet weak var lbDate:              UILabel!
    @IBOutlet weak var introView:           UIView!
    @IBOutlet weak var lbIntro1:            UILabel!
    @IBOutlet weak var lbIntro2:            UILabel!
    @IBOutlet weak var handTouchImg:        UIImageView!
    var idxImg:                             Int = 0
    var arrIntros                               = [(String, String)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        borderIphoneView.layer.cornerRadius     = 30
        borderIphoneView.layer.masksToBounds    = true
        borderIphoneView.layer.borderWidth      = 6
        borderIphoneView.layer.borderColor      = UIColor.white.cgColor
        
        insideIphoneView.layer.borderWidth      = 2
        insideIphoneView.layer.borderColor      = UIColor.white.cgColor
        
        speakerView.layer.cornerRadius          = 2.5
        speakerView.layer.masksToBounds         = true
        
        introView.layer.cornerRadius          = 30
        introView.layer.masksToBounds         = true
        
        lbTime.text = dateToTimeStringWith(date: Date())
        lbDate.text = dateToDateStringWith(date: Date())
        
        arrIntros.append((Constants.MSG_UNIQUE_BACKGROUDS, Constants.MSG_FIT_ANY_SCREEN))
        arrIntros.append((Constants.MSG_LIVE_WALLPAPERS, Constants.MSG_FOR_YOUR_IPHONE))
        arrIntros.append((Constants.MSG_AWESOME_THEMES, Constants.MSG_HUGE_COLLECTION))
        arrIntros.append((Constants.MSG_CUSTOM_LOCK_SCREEN, Constants.MSG_ENDLESS_OPTIONS))
        arrIntros.append((Constants.MSG_PIXEL_PERFECT, Constants.MSG_HD_QUALITY))
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        bgView.addSubview(blurEffectView)
        
        changeImage()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
        
    }
    
    func changeImage(){
        lbTime.text                             = dateToTimeStringWith(date: Date())
        lbDate.text                             = dateToDateStringWith(date: Date())
        bgImageView.image                       = UIImage.init(named: "\(idxImg%5 + 1).jpg")
        insideImageView.image                   = UIImage.init(named: "\(idxImg%5 + 1).jpg")
        let msg                                 = arrIntros[idxImg%5]
        lbIntro1.text                           = msg.0
        lbIntro2.text                           = msg.1
        introView.isHidden                      = idxImg%5 != 0
        handTouchImg.isHidden                   = idxImg%5 != 1
        idxImg += 1
    }
}

