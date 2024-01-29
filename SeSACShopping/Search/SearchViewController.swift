//
//  SearchViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    let searchBar = UISearchBar()
    let emptyView = UIView()
    let recLabel = UILabel()
    lazy var recCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configCollectionViewLayout())
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()
    let recentView = UIView()
    let recentLabel = UILabel()
    let allEraseButton = UIButton()
    let recentTableView = UITableView()
    
    var searchList: [String] = UserDefaultsManager.shared.getSearchList()
    var recList: [String] = Recommendation().returnShuffledList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        view.addSubviews([searchBar, emptyView, recentView])
        emptyView.addSubviews([recLabel, recCollectionView, emptyImageView, emptyLabel])
        recentView.addSubviews([recentLabel, allEraseButton, recentTableView])
        designNavigationItem()
        designViews()
        configConstraints()
        configTableView()
        changeView()
        configCollectionView()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            view.endEditing(true)
        } else {
            guard let text = searchBar.text else {
                return
            }
            checkExists(text: text)
            syncSearchList()
            pushResultViewController(keyword: searchBar.text!)
            view.endEditing(true)
            searchBar.text = ""
        }
    }
}

extension SearchViewController: DesignViews {
    func designViews() {
        searchBar.delegate = self
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
        allEraseButton.addTarget(self, action: #selector(allEraseButtonClicked), for: .touchUpInside)
        
        recentTableView.backgroundColor = ColorDesign.clear.fill
        recentTableView.rowHeight = 44
    }
    
    func designNavigationItem() {
        let nickname = UserDefaultsManager.shared.getStringValue(.nickname)
        navigationItem.title = "\(nickname)님의 새싹쇼핑"
    }
}

extension SearchViewController: ConfigConstraints {
    func configConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(44)
        }
        emptyView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
            make.horizontalEdges.equalTo(view)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func configTableView() {
        recentTableView.delegate = self
        recentTableView.dataSource = self
        
        recentTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        cell.configureCell(searchList[indexPath.row], row: indexPath.row)
        cell.eraseButton.addTarget(self, action: #selector(cellEraseButtonClicked), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushResultViewController(keyword: searchList[indexPath.row])
    }
}

extension SearchViewController: ConfigButtonClicked {
    @objc func allEraseButtonClicked() {
        searchList.removeAll()
        syncSearchList()
    }
    
    @objc func cellEraseButtonClicked(_ sender: UIButton) {
        searchList.remove(at: sender.tag)
        syncSearchList()
    }
    
    @objc func recButtonClicked(_ sender: UIButton) {
        checkExists(text: recList[sender.tag])
        syncSearchList()
        pushResultViewController(keyword: recList[sender.tag])
    }
}

extension SearchViewController: MyDefinedFunctions {
    func changeView() {
        emptyView.isHidden = !searchList.isEmpty
        recentView.isHidden = searchList.isEmpty
    }
    
    func syncSearchList() {
        UserDefaultsManager.shared.setSearchList(value: searchList)
        searchList = UserDefaultsManager.shared.getSearchList()
        recentTableView.reloadData()
        changeView()
    }
    
    func pushResultViewController(keyword: String) {
        // 검색 결과 화면으로 이동
        let vc = ResultViewController()
        vc.keyword = keyword
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkExists(text: String) {
        if let idx = searchList.firstIndex(of: text) {
            searchList.remove(at: idx)
        }
        
        searchList.insert(text, at: 0)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configCollectionView() {
        recCollectionView.dataSource = self
        recCollectionView.delegate = self

        recCollectionView.register(RecCollectionViewCell.self, forCellWithReuseIdentifier: RecCollectionViewCell.identifier)
    }
    
    func configCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        
        layout.itemSize = CGSize(width: 60, height: 54)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        //        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = 3
        layout.scrollDirection = .horizontal
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recCollectionView.dequeueReusableCell(withReuseIdentifier: RecCollectionViewCell.identifier, for: indexPath) as! RecCollectionViewCell
        
        cell.configureCell(recList[indexPath.item], row: indexPath.item)
        cell.recButton.addTarget(self, action: #selector(recButtonClicked), for: .touchUpInside)
        
        return cell
    }
}
