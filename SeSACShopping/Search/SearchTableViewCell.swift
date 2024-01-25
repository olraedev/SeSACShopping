//
//  SearchTableViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/20/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet var magnifyImageView: UIImageView!
    @IBOutlet var keywordLabel: UILabel!
    @IBOutlet var eraseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
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
