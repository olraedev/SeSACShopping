//
//  ResultViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/20/24.
//

import UIKit
import Toast
import RealmSwift

class ResultViewController: UIViewController {
    
    let resultView = ResultView()
    
    let repository = RealmRepository()
    let realm = try! Realm()
    var keyword: String = ""
    var list: NaverShoppingInfo = NaverShoppingInfo(total: 0, start: 0, display: 0, items: [])
    var likeList: List<LikeList>!
    var start: Int = 1
    var nowSort: Sort = .sim
    
    override func loadView() {
        self.view = resultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        designNavigationItem()
        
        configCollectionView()
        requestToNaverShopping(start: start, sort: nowSort.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        likeList = repository.readUser().likeList
        resultView.collectionView.reloadData()
    }
}

extension ResultViewController: DesignViews {
    func designViews() {
        let buttons = [resultView.simButton, resultView.dateButton, resultView.dscButton, resultView.ascButton]
        for idx in 0...buttons.count - 1 {
            buttons[idx].tag = idx
            buttons[idx].addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        }
    }
    
    func designNavigationItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.title = "\(keyword)"
        navigationItem.leftBarButtonItem = leftBarButton
    }
}

extension ResultViewController: ConfigButtonClicked {
    @objc func leftBarButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        let buttons = [resultView.simButton, resultView.dateButton, resultView.dscButton, resultView.ascButton]
        
        nowSort = Sort.allCases[sender.tag]
        requestToNaverShopping(start: start, sort: Sort.allCases[sender.tag].rawValue)
        resultView.collectionView.setContentOffset(.zero, animated: false)
        for button in buttons {
            if button == sender {
                button.setTitleColor(ColorDesign.bgc.fill, for: .normal)
                button.backgroundColor = ColorDesign.text.fill
            } else {
                button.setTitleColor(ColorDesign.text.fill, for: .normal)
                button.backgroundColor = ColorDesign.bgc.fill
            }
        }
        resultView.collectionView.reloadData()
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        let productId = list.items[sender.tag].productId
        
        if let data = realm.object(ofType: LikeList.self, forPrimaryKey: productId) {
            do {
                try realm.write {
                    realm.delete(data)
                    view.makeToast("상품을 찜 목록에서 삭제하셨습니다!", duration: 1)
                }
            } catch {
                print("찜 목록 삭제 실패")
            }
        } else {
            view.makeToast("찜 목록에 추가하였습니다!", duration: 1)
            repository.appendLikeList(list.items[sender.tag])
        }
        
        resultView.collectionView.reloadData()
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configCollectionView() {
        resultView.collectionView.delegate = self
        resultView.collectionView.dataSource = self
        resultView.collectionView.prefetchDataSource = self
        
        resultView.collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        
        cell.likeButton.tag = indexPath.row
        cell.configureCell(list.items[indexPath.row])
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        vc.product = list.items[indexPath.item]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
        
        for item in indexPaths {
            if list.items.count - 3 == item.row {
                start += 30
                APISessionManager.shared.requestToNaverShopping(query: keyword, display: 30, start: start, sort: nowSort.rawValue) { info, error in
                    if let error = error {
                        switch error {
                        case .failedRequest: self.presentAlert(title: "네트워크 오류", message: NaverShoppingError.failedRequest.errorMessage)
                        case .invalidResponse: self.presentAlert(title: "네트워크 오류", message: NaverShoppingError.invalidResponse.errorMessage)
                        case .noData: self.presentAlert(title: "네트워크 오류", message: NaverShoppingError.noData.errorMessage)
                        }
                    } else {
                        guard let info else {
                            self.presentAlert(title: "네트워크 오류", message: "잠시 후 다시 시도해주세요.")
                            return
                        }
                        self.list.items.append(contentsOf: info.items)
                        self.resultView.collectionView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print(#function)
    }
}

extension ResultViewController: MyDefinedFunctions {
    func requestToNaverShopping(start: Int, sort: String) {
        APIManager().requestNaverShopping(query: keyword, display: 30, start: start, sort: sort) { info in
            self.resultView.totalLabel.text = "\(info.total.formatted()) 개의 검색 결과"
            self.list = info
            self.resultView.collectionView.reloadData()
        }
    }
}
