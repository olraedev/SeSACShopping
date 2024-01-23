//
//  ImageCollectionViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell, ConfigIdentifier {
    static var identifier: String = "ImageCollectionViewCell"
    
    @IBOutlet var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(image: String) {
        profileImageView.image = UIImage(named: image)
    }
}
