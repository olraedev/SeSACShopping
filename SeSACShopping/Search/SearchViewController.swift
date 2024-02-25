//
//  SearchViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit
import SnapKit
import RealmSwift

class SearchViewController: UIViewController {
    
    let searchView = SearchView()
    
    let repository = RealmRepository()
    let realm = try! Realm()
    var searchList: List<SearchList>!
    var recList: [String] = Recommendation().returnShuffledList
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchList = repository.readUser().searchList
        setBackgroundColor()
        designNavigationItem()
        designViews()
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
            repository.appendSearchList(text)
            searchView.recentTableView.reloadData()
            changeView()
            pushResultViewController(keyword: searchBar.text!)
            view.endEditing(true)
            searchBar.text = ""
        }
    }
}

extension SearchViewController: DesignViews {
    func designViews() {
        searchView.searchBar.delegate = self
        searchView.allEraseButton.addTarget(self, action: #selector(allEraseButtonClicked), for: .touchUpInside)
    }
    
    func designNavigationItem() {
        let nickname = repository.readUser().nickname!
        navigationItem.title = "\(nickname)님의 새싹쇼핑"
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func configTableView() {
        searchView.recentTableView.delegate = self
        searchView.recentTableView.dataSource = self
        
        searchView.recentTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchView.recentTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        cell.configureCell(searchList[indexPath.row].name, row: indexPath.row)
        cell.eraseButton.addTarget(self, action: #selector(cellEraseButtonClicked), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushResultViewController(keyword: searchList[indexPath.row].name)
    }
}

extension SearchViewController: ConfigButtonClicked {
    @objc func allEraseButtonClicked() {
        try! realm.write({
            let list = realm.objects(SearchList.self)
            realm.delete(list)
        })
        syncSearchList()
    }
    
    @objc func cellEraseButtonClicked(_ sender: UIButton) {
        try! realm.write({
            let list = realm.object(ofType: SearchList.self, forPrimaryKey: searchList[sender.tag].name)
            realm.delete(list!)
        })
        syncSearchList()
    }
    
    @objc func recButtonClicked(_ sender: UIButton) {
        repository.appendSearchList(recList[sender.tag])
        syncSearchList()
        pushResultViewController(keyword: recList[sender.tag])
    }
}

extension SearchViewController: MyDefinedFunctions {
    func changeView() {
        searchView.emptyView.isHidden = !searchList.isEmpty
        searchView.recentView.isHidden = searchList.isEmpty
    }
    
    func syncSearchList() {
        repository.readUser().searchList = searchList
        searchView.recentTableView.reloadData()
        changeView()
    }
    
    func pushResultViewController(keyword: String) {
        // 검색 결과 화면으로 이동
        let vc = ResultViewController()
        vc.keyword = keyword
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configCollectionView() {
        searchView.recCollectionView.dataSource = self
        searchView.recCollectionView.delegate = self

        searchView.recCollectionView.register(RecCollectionViewCell.self, forCellWithReuseIdentifier: RecCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchView.recCollectionView.dequeueReusableCell(withReuseIdentifier: RecCollectionViewCell.identifier, for: indexPath) as! RecCollectionViewCell
        
        cell.configureCell(recList[indexPath.item], row: indexPath.item)
        cell.recButton.addTarget(self, action: #selector(recButtonClicked), for: .touchUpInside)
        
        return cell
    }
}
