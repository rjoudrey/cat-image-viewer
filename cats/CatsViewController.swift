//
//  ViewController.swift
//  cats
//
//  Created by Ricky J on 8/5/15.
//  Copyright © 2015 rjoudrey. All rights reserved.
//

import UIKit
import JTSImageViewController

class CatsViewController : UICollectionViewController {
    var catImageSource = CatImageSource()
    var numberOfCatImagesToShow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        catImageSource.delegate = self
        loadCatImages()
    }
    
    /// Generates some cat image parameters, and loads the associated images
    func loadCatImages() {
        var params = CatImageParameters(width: 0, height: 0)
        for width in 1...100 {
            for height in 1...100 {
                params.width = UInt16(width * 5)
                params.height = UInt16(height * 5)
                catImageSource.loadCatImageWithParameters(params)
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCatImagesToShow
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CatCollectionViewCell", forIndexPath: indexPath) as! CatCollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        let catImageParams = catImageSource.catImageParametersAtIndex(indexPath.row)
        cell.catImageView?.image = catImageSource.cachedCatImageWithParameters(catImageParams, getThumbnail: true)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imageInfo = JTSImageInfo();
        let selectedCell = self.collectionView(self.collectionView!, cellForItemAtIndexPath: indexPath) as! CatCollectionViewCell
        let catImageParams = catImageSource.catImageParametersAtIndex(indexPath.row)
        imageInfo.image = catImageSource.cachedCatImageWithParameters(catImageParams, getThumbnail: false)
        imageInfo.referenceRect = selectedCell.frame
        imageInfo.referenceView = collectionView
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image,
            backgroundStyle: JTSImageViewControllerBackgroundOptions.Scaled)
        imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOriginalPosition)
    }
}

extension CatsViewController : CatImageSourceDelegate {
    func finishedLoadingCatImageWithParameters(params: CatImageParameters, index: Int) {
        ++numberOfCatImagesToShow
        collectionView?.insertItemsAtIndexPaths([
            NSIndexPath(forRow: index, inSection: 0) ])
        if index > 250 { // Okay, I think we have enough cats for now
            catImageSource.cancelPendingCatImageLoadingRequests()
        }
    }
}
