//
//  AppDelegate.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/20/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func createMenuView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerIdentity") as! HomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewControllerIdentity") as! LeftViewController
        
        let slideMenuController = SlideMenuController(mainViewController: homeViewController, leftMenuViewController: leftViewController)
        slideMenuController.delegate = homeViewController
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            self.window?.rootViewController = slideMenuController
            self.window?.makeKeyAndVisible()
            }, completion: nil)
        
    }
}

