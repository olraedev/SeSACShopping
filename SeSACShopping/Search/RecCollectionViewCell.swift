//
//  RecCollectionViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/23/24.
//

import UIKit

class RecCollectionViewCell: UICollectionViewCell {
//    @IBOutlet var recButton: UIButton!
    let recButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(recButton)
        configureCell()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecCollectionViewCell {
    func configureCell() {
        backgroundColor = ColorDesign.clear.fill
        
        recButton.layer.borderWidth = 1
        recButton.layer.borderColor = ColorDesign.text.fill.cgColor
        recButton.titleLabel?.font = FontDesign.small.light
        recButton.tintColor = ColorDesign.text.fill
        recButton.backgroundColor = ColorDesign.bgc.fill
        recButton.layer.cornerRadius = 10
    }
    
    func configureCell(_ item: String, row: Int) {
        recButton.setTitle(item, for: .normal)
        recButton.tag = row
    }
}

extension RecCollectionViewCell: ConfigConstraints {
    func configConstraints() {
        recButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(60)
        }
    }
}
