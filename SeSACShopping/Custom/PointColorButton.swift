//
//  PointColorButton.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/29/24.
//

import UIKit

class PointColorButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    func configureView() {
        titleLabel?.font = FontDesign.big.bold
        tintColor = ColorDesign.text.fill
        backgroundColor = ColorDesign.point.fill
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
