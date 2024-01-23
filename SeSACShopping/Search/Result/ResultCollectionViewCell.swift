//
//  ResultCollectionViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/20/24.
//

import UIKit
import Kingfisher

class ResultCollectionViewCell: UICollectionViewCell, ConfigIdentifier {
    static var identifier: String = "ResultCollectionViewCell"

    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var mallNameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCell()
    }
}

extension ResultCollectionViewCell {
    func configureCell() {
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.cornerRadius = 8
        
        likeButton.layer.cornerRadius = likeButton.frame.width / 2
        likeButton.backgroundColor = .clear
        likeButton.tintColor = ColorDesign.bgc.fill
        
        mallNameLabel.textColor = ColorDesign.text.fill
        mallNameLabel.font = FontDesign.smallest.light
        
        titleLabel.numberOfLines = 2
        titleLabel.textColor = ColorDesign.text.fill
        titleLabel.font = FontDesign.small.light
        
        priceLabel.textColor = ColorDesign.text.fill
        priceLabel.font = FontDesign.mid.bold
    }
    
    func configureCell(_ item: Item, likeList: [String]) {
        let url = URL(string: item.image)
        
        itemImageView.kf.setImage(with: url)
        mallNameLabel.text = item.mallName
        titleLabel.text = replaceTitle(item.title)
        priceLabel.text = Int(item.lprice)!.formatted()
        
        if likeList.contains(item.productId) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
