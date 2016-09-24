//
//  SplashViewController.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/24/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadHomePage(){
        let _ = DownloadManager.sharedInstance.loadData {
            let delegateApp = UIApplication.shared.delegate as! AppDelegate
            delegateApp.createMenuView()
        }
    }
}
