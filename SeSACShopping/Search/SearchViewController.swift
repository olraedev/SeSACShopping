//
//  SearchViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    let searchView = SearchView()
    let viewModel = SearchViewModel()
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        viewModel.inputViewDidLoad.value = ()
        designNavigationItem()
        designViews()
        bindData()
    }
    
    func bindData() {
        viewModel.searchList.bind { _ in
            self.searchView.recentTableView.reloadData()
        }
        
        viewModel.outputViewState.bind { state in
            self.searchView.emptyView.isHidden = state
            self.searchView.recentView.isHidden = !state
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchText.value = searchBar.text
        pushResultViewController(keyword: searchBar.text)
        view.endEditing(true)
    }
}

extension SearchViewController: DesignViews {
    func designViews() {
        searchView.searchBar.delegate = self
        searchView.allEraseButton.addTarget(self, action: #selector(allEraseButtonClicked), for: .touchUpInside)
        
        searchView.recentTableView.delegate = self
        searchView.recentTableView.dataSource = self
        searchView.recentTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        searchView.recCollectionView.dataSource = self
        searchView.recCollectionView.delegate = self
        searchView.recCollectionView.register(RecCollectionViewCell.self, forCellWithReuseIdentifier: RecCollectionViewCell.identifier)
    }
    
    func designNavigationItem() {
        navigationItem.title = "\(viewModel.nickname)님의 새싹쇼핑"
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchView.recentTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        cell.configureCell(viewModel.searchList.value[indexPath.row].name, row: indexPath.row)
        cell.eraseButton.addTarget(self, action: #selector(cellEraseButtonClicked), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushResultViewController(keyword: viewModel.searchList.value[indexPath.row].name)
    }
}

extension SearchViewController: ConfigButtonClicked {
    @objc func allEraseButtonClicked() {
        viewModel.inputAllEraseButtonTrigger.value = ()
    }
    
    @objc func cellEraseButtonClicked(_ sender: UIButton) {
        viewModel.inputCellEraseButton.value = sender.tag
    }
    
    @objc func recButtonClicked(_ sender: UIButton) {
        viewModel.inputSearchText.value = viewModel.recList[sender.tag]
        pushResultViewController(keyword: viewModel.recList[sender.tag])
    }
}

extension SearchViewController: MyDefinedFunctions {
    
    func pushResultViewController(keyword: String?) {
        guard let keyword else { return }
        // 검색 결과 화면으로 이동
        let vc = ResultViewController()
        vc.keyword = keyword
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchView.recCollectionView.dequeueReusableCell(withReuseIdentifier: RecCollectionViewCell.identifier, for: indexPath) as! RecCollectionViewCell
        
        cell.configureCell(viewModel.recList[indexPath.item], row: indexPath.item)
        cell.recButton.addTarget(self, action: #selector(recButtonClicked), for: .touchUpInside)
        
        return cell
    }
}
