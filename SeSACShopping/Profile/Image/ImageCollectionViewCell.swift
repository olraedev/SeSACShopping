//
//  ImageCollectionViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    let profileImageView = PointColorBorderImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(profileImageView)
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(image: String) {
        profileImageView.image = UIImage(named: image)
    }
}

extension ImageCollectionViewCell: ConfigConstraints {
    func configConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}
