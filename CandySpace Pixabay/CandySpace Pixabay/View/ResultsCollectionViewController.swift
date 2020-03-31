//
//  ResultsCollectionViewController.swift
//  CandySpace Pixabay
//
//  Created by Andreas Velounias on 26/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import UIKit

class ResultsCollectionViewController: UICollectionViewController {
    
    var viewModel: PixabayViewModel!
    var minLinespacing: CGFloat = 32.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configurePixaCollectionCell(_ cell: PixabayCollectionViewCell, indexPath: IndexPath) {
        // Configure the cell
        let item = viewModel.pixabayItems[indexPath.row]
        cell.authorLabel.text = item.authorName
        
        cell.imageView.layer.cornerRadius = 5.0
        if let cacheImage = viewModel.imageCache[item.imageURL] as? [String: Any] {
            cell.imageView.image = cacheImage["image"] as? UIImage
        }
        else {
            viewModel.downloadImage(with: item.imageURL) { (error, image) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                guard let image = image else { return }
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
                
                self.viewModel.optimizeCache()
                
                // Save image to cache
                let cacheInfo = [
                    "image" : image,
                    "date" : Date()
                    ] as [String : Any]
                
                self.viewModel.saveImageToCache(with: item.imageURL, cacheInfo: cacheInfo)
            }
        }
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
    }
}

// MARK: UICollectionViewDataSource

extension ResultsCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.pixabayItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! PixabayCollectionViewCell
        configurePixaCollectionCell(cell, indexPath: indexPath)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ResultsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minLinespacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32.0,
                      height: collectionView.frame.height / 2.5)
    }
}
