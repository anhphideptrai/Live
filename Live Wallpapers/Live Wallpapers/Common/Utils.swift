//
//  Utils.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/21/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

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

func showAlertWith(title: String? = Constants.Messages.MSG_TITLE_ALERT, message: String?, cancelTitle: String? = Constants.Messages.MSG_OK, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
