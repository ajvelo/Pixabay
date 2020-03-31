//
//  PixabayCollectionViewCell.swift
//  CandySpace Pixabay
//
//  Created by Andreas Velounias on 26/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import UIKit

class PixabayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
        self.authorLabel.text = nil
    }
}
