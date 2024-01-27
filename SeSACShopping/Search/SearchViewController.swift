//
//  SearchViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

/*
 1. 그냥 로직을 다시 짜야함.. 졸려서 이만...
 */

import UIKit

class SearchViewController: UIViewController, ConfigStoryBoardIdentifier {
    static var sbIdentifier: String = "Search"

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var recLabel: UILabel!
    @IBOutlet var recCollectionView: UICollectionView!
    @IBOutlet var emptyImageView: UIImageView!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var recentView: UIView!
    @IBOutlet var recentLabel: UILabel!
    @IBOutlet var allEraseButton: UIButton!
    @IBOutlet var recentTableView: UITableView!
    
    var searchList: [String] = UserDefaultsManager.shared.getSearchList()
    var recList: [String] = Recommendation().returnShuffledList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        designNavigationItem()
        designViews()
        configTableView()
        changeView()
        configCollectionView()
        configCollectionViewLayout()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            view.endEditing(true)
            searchBar.text = ""
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
        allEraseButton.tintColor = ColorDesign.point.fill
        allEraseButton.titleLabel?.font = FontDesign.mid.bold
        allEraseButton.addTarget(self, action: #selector(allEraseButtonClicked), for: .touchUpInside)
        
        recentTableView.backgroundColor = ColorDesign.clear.fill
    }
    
    func designNavigationItem() {
        let nickname = UserDefaultsManager.shared.getStringValue(.nickname)
//        let nickname = "자고싶다..."
        navigationItem.title = "\(nickname)님의 새싹쇼핑"
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func configTableView() {
        recentTableView.delegate = self
        recentTableView.dataSource = self
        
        let xib = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        recentTableView.register(xib, forCellReuseIdentifier: SearchTableViewCell.identifier)
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
        let sb = UIStoryboard(name: ResultViewController.sbIdentifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ResultViewController.identifier) as! ResultViewController
        
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
        
        let xib = UINib(nibName: RecCollectionViewCell.identifier, bundle: nil)
        recCollectionView.register(xib, forCellWithReuseIdentifier: RecCollectionViewCell.identifier)
    }
    
    func configCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        
        layout.itemSize = CGSize(width: 60, height: 54)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
//        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = 3
        layout.scrollDirection = .horizontal
        
        recCollectionView.collectionViewLayout = layout
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
