//
//  LeftViewController.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/23/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit
enum LeftMenu: Int {
    case category = 0
    case help
    case rating
    case memory
    case nonMenu
}

class LeftViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension LeftViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return DownloadManager.sharedInstance.categories.count
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.textColor = UIColor.white
        cell?.backgroundColor = UIColor.clear
        switch indexPath.section {
        case 0:
            cell?.textLabel?.text = (DownloadManager.sharedInstance.categories[indexPath.row] as! CategoryLive).name
        case 1:
            cell?.textLabel?.text = "Rating"
        default:
            cell?.textLabel?.text = "Need help?"
        }
        return cell!
    }
}
