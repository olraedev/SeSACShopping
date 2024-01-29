//
//  ResultCollectionViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/20/24.
//

import UIKit
import Kingfisher

class ResultCollectionViewCell: UICollectionViewCell {
    let itemImageView = UIImageView()
    let likeButton = UIButton()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews([itemImageView, likeButton, mallNameLabel, titleLabel, priceLabel])
        configureCell()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultCollectionViewCell: ConfigConstraints{
    func configConstraints() {
        itemImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(170)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.trailing.equalTo(itemImageView.snp.trailing).inset(8)
            make.bottom.equalTo(itemImageView.snp.bottom).inset(8)
        }
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(itemImageView)
            make.height.equalTo(11)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(itemImageView)
            make.height.greaterThanOrEqualTo(22)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(itemImageView)
            make.height.equalTo(22)
        }
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
