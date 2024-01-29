//
//  SettingTableViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/21/24.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        configureCell()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        titleLabel.textColor = ColorDesign.text.fill
        titleLabel.font = FontDesign.mid.light
    }
}

extension SettingTableViewCell: ConfigConstraints {
    func configConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(24)
        }
    }
}
