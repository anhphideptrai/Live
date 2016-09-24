//
//  HomeViewController.swift
//  Live Wallpapers
//
//  Created by Nguyen Duc Phi on 9/22/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class HomeViewController: UIViewController {

    public var category: CategoryLive?
    public var liveItemsSelected = [LiveItem]()
    
    @IBOutlet weak var lbCategoryTitle: UILabel!
    @IBOutlet weak var collectionView:  UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        setupData()
    }
    
    func setupData(){
        category = DownloadManager.sharedInstance.categories[DownloadManager.sharedInstance.currentIdxCategory] as? CategoryLive
        lbCategoryTitle.text = category?.name
        liveItemsSelected.removeAll()
        for liveItemId in (category?.liveItemIds)! {
            liveItemsSelected.append(LiveItem.parser(DownloadManager.sharedInstance.liveItems[liveItemId] as AnyObject))
        }
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.reloadData()
    }
    
    func openLivePhotosWith(selectedIdx: Int){
        let livePhotosCV = storyboard!.instantiateViewController(withIdentifier: "LivePhotosViewControllerIdentity") as! LivePhotosViewController
        livePhotosCV.firstItemIndex = selectedIdx
        livePhotosCV.liveItems      = liveItemsSelected
        livePhotosCV.frameCarousel  = view.frame
        present(livePhotosCV, animated: true, completion: nil)
    }
    @IBAction func menuAction(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellInRow : Int = 3
        let padding : Int = 2
        let collectionCellWidth : CGFloat = (self.view.frame.size.width/CGFloat(numberOfCellInRow)) - CGFloat(padding)
        let collectionCellHeight : CGFloat = (self.view.frame.size.height/CGFloat(numberOfCellInRow)) - CGFloat(padding)
        return CGSize(width: collectionCellWidth , height: collectionCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveItemsSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let liveItem = liveItemsSelected[indexPath.row]
        cell.loadImageWith(uRLImage: liveItem.urlImage())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openLivePhotosWith(selectedIdx: indexPath.row)
    }
}

extension HomeViewController: SlideMenuControllerDelegate {
    func leftDidClose() {
        if DownloadManager.sharedInstance.lastIdxCategory != DownloadManager.sharedInstance.currentIdxCategory {
            DownloadManager.sharedInstance.lastIdxCategory = DownloadManager.sharedInstance.currentIdxCategory
            setupData()
        }
        
    }
}
