//
//  PointColorBorderImageView.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/29/24.
//

import UIKit

class PointColorBorderImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        designViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}

extension PointColorBorderImageView: DesignViews {
    func designViews() {
        clipsToBounds = true
        layer.borderWidth = 5
        layer.borderColor = ColorDesign.point.fill.cgColor
    }
}
