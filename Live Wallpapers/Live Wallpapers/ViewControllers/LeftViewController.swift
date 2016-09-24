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
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: CategoryCell.categoryCellIdentifier)
    }
    
}

extension LeftViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DownloadManager.sharedInstance.categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.categoryCellIdentifier) as? CategoryCell
        if cell == nil {
            cell = CategoryCell(style: .default, reuseIdentifier: CategoryCell.categoryCellIdentifier)
        }
        let category = DownloadManager.sharedInstance.categories[indexPath.row] as! CategoryLive
        cell?.setNormalBackground(isEven: indexPath.row%2==0)
        cell?.lbTitle.text = category.name
        cell?.lbSubTitle.text = "\(category.liveItemIds!.count) Items"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        DownloadManager.sharedInstance.currentIdxCategory = indexPath.row
        self.slideMenuController()?.closeLeft()
    }
}
