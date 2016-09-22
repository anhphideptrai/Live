//
//  HomeViewController.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/22/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    public var category: CategoryLive?
    public var liveItemsSelected = [LiveItem]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(setupDataWith), userInfo: nil, repeats: false)
    }
    
    func setupDataWith(categoriesIdx: Int = 0){
        category = DownloadManager.sharedInstance.categories[0] as? CategoryLive
        liveItemsSelected.removeAll()
        for liveItemId in (category?.liveItemIds)! {
            liveItemsSelected.append(LiveItem.parser(DownloadManager.sharedInstance.liveItems[liveItemId] as AnyObject))
        }
        
        let livePhotosCV = storyboard!.instantiateViewController(withIdentifier: "LivePhotosViewControllerIdentity") as! LivePhotosViewController
        livePhotosCV.firstItemIndex = 4
        livePhotosCV.liveItems      = liveItemsSelected
        livePhotosCV.frameCarousel  = view.frame
        present(livePhotosCV, animated: true, completion: nil)
        
    }
    
}
