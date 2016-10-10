//
//  Utils.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/21/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit
import GoogleMobileAds

/* Get Document URL */
func getDocumentDirectory() -> URL{
    return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
}

func urlLocal(_ path: String) -> URL?{
    return getDocumentDirectory().appendingPathComponent(path)
}

/* Check File/Folder is exists */
func checkFileExists(_ url: URL?) -> Bool{
    if url != nil {
        return FileManager.default.fileExists(atPath: url!.path)
    }else{
        return false
    }
}

func dateToTimeStringWith(date: Date) -> String{
    let dateformatter       = DateFormatter()
    dateformatter.dateFormat = "hh:mm"
    return dateformatter.string(from: date)
}

func dateToDateStringWith(date: Date) -> String{
    let dateformatter       = DateFormatter()
    dateformatter.dateFormat = "EEEE, MMMM dd"
    dateformatter.locale = Locale.current
    return dateformatter.string(from: date)
}

func showAlertWith(title: String? = Constants.Messages.MSG_TITLE_ALERT, message: String?, cancelTitle: String? = Constants.Messages.MSG_OK, otherTitle: String? = nil, viewController: UIViewController, handleOtherAction: ((UIAlertAction) -> Swift.Void)? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if otherTitle != nil {
            let otherAction = UIAlertAction(title: otherTitle, style: .default, handler: handleOtherAction)
            alert.addAction(otherAction)
        }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

func addConstraintForView(_ subView: UIView, _ parent: UIView){
    subView.translatesAutoresizingMaskIntoConstraints = false
    let topContraints = NSLayoutConstraint(item: subView, attribute:
        .top, relatedBy: .equal, toItem: parent,
              attribute: .top, multiplier: 1.0,
              constant: 0)
    let bottomContraints  = NSLayoutConstraint(item: subView, attribute:
        .bottom, relatedBy: .equal, toItem: parent,
                 attribute: .bottom, multiplier: 1.0,
                 constant: 0)
    let leftContraints  = NSLayoutConstraint(item: subView, attribute:
        .left, relatedBy: .equal, toItem: parent,
               attribute: .left, multiplier: 1.0,
               constant: 0)
    let rightontraints  = NSLayoutConstraint(item: subView, attribute:
        .right, relatedBy: .equal, toItem: parent,
                attribute: .right, multiplier: 1.0,
                constant: 0)
    parent.addConstraint(topContraints)
    parent.addConstraint(bottomContraints)
    parent.addConstraint(leftContraints)
    parent.addConstraint(rightontraints)
}

func getRequestAds() -> GADRequest {
    let request                     = GADRequest()
    request.testDevices             = [kGADSimulatorID, "4ae7ba9ea2b6662b5a44578f0c5f6c61"]
    return request
}

func addSkipBackupAttributeToItemAtURL(filePath:String) -> Bool
{
    let URL:NSURL = NSURL.fileURL(withPath: filePath) as NSURL
    
    assert(FileManager.default.fileExists(atPath: filePath), "File \(filePath) does not exist")
    
    var success: Bool
    do {
        try URL.setResourceValue(true, forKey:URLResourceKey.isExcludedFromBackupKey)
        success = true
    } catch let error as NSError {
        success = false
        print("Error excluding \(URL.lastPathComponent) from backup \(error)");
    }
    
    return success
}
