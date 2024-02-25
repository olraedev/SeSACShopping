//
//  SearchView.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/25/24.
//

import UIKit

class SearchView: UIView {
    
    let searchBar = UISearchBar()
    let emptyView = UIView()
    let recLabel = UILabel()
    let recCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configCollectionViewLayout())
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()
    let recentView = UIView()
    let recentLabel = UILabel()
    let allEraseButton = UIButton()
    let recentTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        designViews()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchView: DesignViews, ConfigConstraints {
    func designViews() {
        self.addSubviews([searchBar, emptyView, recentView])
        emptyView.addSubviews([recLabel, recCollectionView, emptyImageView, emptyLabel])
        recentView.addSubviews([recentLabel, allEraseButton, recentTableView])
        
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor])
        searchBar.barTintColor = ColorDesign.bgc.fill
        searchBar.tintColor = ColorDesign.text.fill
        searchBar.searchTextField.textColor = ColorDesign.text.fill
        
        emptyView.backgroundColor = ColorDesign.bgc.fill
        
        recLabel.text = "주인장의 추천 검색어"
        recLabel.textAlignment = .center
        recLabel.font = FontDesign.big.light
        recLabel.textColor = ColorDesign.text.fill
        
        recCollectionView.backgroundColor = ColorDesign.clear.fill
        
        emptyImageView.image = .empty
        
        emptyLabel.text = "최근 검색어가 없어요"
        emptyLabel.textAlignment = .center
        emptyLabel.font = FontDesign.biggest.bold
        emptyLabel.textColor = ColorDesign.text.fill
        
        recentView.backgroundColor = ColorDesign.bgc.fill
        
        recentLabel.text = "최근 검색"
        recentLabel.textColor = ColorDesign.text.fill
        recentLabel.font = FontDesign.mid.light
        
        allEraseButton.setTitle("모두 지우기", for: .normal)
        allEraseButton.setTitleColor(ColorDesign.point.fill, for: .normal)
        allEraseButton.titleLabel?.font = FontDesign.mid.bold
        
        recentTableView.backgroundColor = ColorDesign.clear.fill
        recentTableView.rowHeight = 44
    }
    
    func configConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(self)
            make.height.equalTo(44)
        }
        emptyView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        recLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(22)
        }
        recCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(recLabel.snp.bottom)
            make.height.equalTo(54)
        }
        emptyImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(emptyImageView.snp.bottom).offset(8)
        }
        recentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        recentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(22)
        }
        allEraseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(22)
        }
        recentTableView.snp.makeConstraints { make in
            make.top.equalTo(allEraseButton.snp.bottom).offset(16)
            make.bottom.horizontalEdges.equalTo(recentView.safeAreaLayoutGuide)
        }
    }
    
    static func configCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        
        layout.itemSize = CGSize(width: 60, height: 54)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        //        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = 3
        layout.scrollDirection = .horizontal
        
        return layout
    }
}
