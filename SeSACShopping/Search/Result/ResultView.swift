//
//  ResultView.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/25/24.
//

import UIKit

class ResultView: UIView {
    
    let totalLabel = UILabel()
    let simButton = UIButton()
    let dateButton = UIButton()
    let dscButton = UIButton()
    let ascButton = UIButton()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configCollectionViewLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews([totalLabel, simButton, dateButton, dscButton, ascButton, collectionView])
        designViews()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultView: DesignViews, ConfigConstraints {
    func designViews() {
        totalLabel.textColor = ColorDesign.point.fill
        totalLabel.font = FontDesign.small.bold
        
        designButtons()
        
        collectionView.backgroundColor = .clear
    }
    
    func designButtons() {
        let buttons: [UIButton] = [simButton, dateButton, dscButton, ascButton]
        
        for idx in 0...buttons.count - 1 {
            buttons[idx].setTitle(Sort.allCases[idx].title, for: .normal)
            buttons[idx].layer.borderColor = ColorDesign.text.fill.cgColor
            buttons[idx].layer.borderWidth = 1
            buttons[idx].layer.cornerRadius = 8
            buttons[idx].titleLabel?.font = FontDesign.small.light
            buttons[idx].setTitleColor(ColorDesign.text.fill, for: .normal)
        }
        simButton.setTitleColor(ColorDesign.bgc.fill, for: .normal)
        simButton.backgroundColor = ColorDesign.text.fill
    }
    
    func configConstraints() {
        totalLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).offset(8)
            make.height.equalTo(22)
        }
        simButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(8)
            make.height.equalTo(33)
            make.width.equalTo(50)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(simButton.snp.trailing).offset(8)
            make.height.equalTo(33)
            make.width.equalTo(50)
        }
        dscButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(dateButton.snp.trailing).offset(8)
            make.height.equalTo(33)
            make.width.equalTo(70)
        }
        ascButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(dscButton.snp.trailing).offset(8)
            make.height.equalTo(33)
            make.width.equalTo(70)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(ascButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    static func configCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (space * 3)
        
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 1.3)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.minimumLineSpacing = space * 2
        layout.minimumInteritemSpacing = space
        
        return layout
    }
}
