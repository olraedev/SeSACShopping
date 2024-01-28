//
//  SearchTableViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/20/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    let magnifyImageView = UIImageView()
    let keywordLabel = UILabel()
    let eraseButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([magnifyImageView, keywordLabel, eraseButton])
        configureCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchTableViewCell {
    func configureCell() {
        backgroundColor = .clear
        magnifyImageView.image = UIImage(systemName: "magnifyingglass")
        magnifyImageView.tintColor = ColorDesign.text.fill
        
        keywordLabel.font = FontDesign.mid.light
        keywordLabel.textColor = ColorDesign.text.fill
        
        eraseButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        eraseButton.tintColor = ColorDesign.text.fill
    }
    
    func configureCell(_ text: String, row: Int) {
        keywordLabel.text = text
        eraseButton.tag = row
    }
}

extension SearchTableViewCell: SetupConstraints {
    func setupConstraints() {
        magnifyImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(16)
            make.size.equalTo(22)
        }
        
        keywordLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(magnifyImageView.snp.trailing).offset(24)
            make.height.equalTo(22)
            make.trailing.greaterThanOrEqualTo(eraseButton).inset(24)
        }
        
        eraseButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.size.equalTo(16)
            make.trailing.equalTo(contentView).offset(-24)
        }
    }
}
