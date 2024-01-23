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

class SearchViewController: UIViewController, ConfigIdentifier {
    static var identifier: String = "SearchViewController"
    static var sbIdentifier: String = "Search"

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var emptyImageView: UIImageView!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var recentView: UIView!
    @IBOutlet var recentLabel: UILabel!
    @IBOutlet var allEraseButton: UIButton!
    @IBOutlet var recentTableView: UITableView!
    
    var searchList: [String] = UserDefaultsManager.shared.getSearchList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        designNavigationItem()
        designOutlets()
        configTableView()
        changeView()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 값이 없으면 검색 못하게...
        if searchBar.text == "" {
            let alert = UIAlertController(title: "검색", message: "검색어를 입력해주세요.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(cancel)
            
            present(alert, animated: true)
        } else {
            guard let text = searchBar.text else {
                return
            }
            
            if let idx = searchList.firstIndex(of: text) {
                searchList.remove(at: idx)
            }
            
            searchList.insert(text, at: 0)
            syncSearchList()
            
            // 검색 결과 화면으로 이동
            let sb = UIStoryboard(name: ResultViewController.sbIdentifier, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: ResultViewController.identifier) as! ResultViewController
            
            vc.keyword = searchBar.text!
            navigationController?.pushViewController(vc, animated: true)
            
            searchBar.text = ""
        }
        
        view.endEditing(false)
    }
}

extension SearchViewController: DesignViews {
    func designOutlets() {
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.barTintColor = ColorDesign.bgc.fill
        searchBar.tintColor = ColorDesign.text.fill
        searchBar.searchTextField.textColor = ColorDesign.text.fill
        
        emptyView.backgroundColor = ColorDesign.bgc.fill
        
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
        let sb = UIStoryboard(name: ResultViewController.sbIdentifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ResultViewController.identifier) as! ResultViewController
        
        vc.keyword = searchList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
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
}
