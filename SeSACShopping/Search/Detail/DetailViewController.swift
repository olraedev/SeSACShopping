//
//  DetailViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/21/24.
//

import UIKit
import WebKit
import RealmSwift

class DetailViewController: UIViewController {
    let webView = WKWebView()
    
    var product: NaverShoppingItem!
    var likeList: [LikeList] = []
    let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        view.addSubview(webView)
        designViews()
        designNavigationItem()
        configConstraints()
        
        likeList = repository.readAll(LikeList.self)
    }
}

extension DetailViewController: ConfigConstraints {
    func configConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DetailViewController: DesignViews {
    func designViews() {
        let urlString = "https://msearch.shopping.naver.com/product/\(product.productId)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }
    
    func designNavigationItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        let rightButton = UIBarButtonItem(image: checkLikeList(), style: .plain, target: self, action: #selector(rightBarButtonClicked))
        navigationItem.title = replaceTitle(product.title)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightButton
    }
}

extension DetailViewController: ConfigButtonClicked {
    @objc func leftBarButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonClicked() {
        if let data = repository.realm.object(ofType: LikeList.self, forPrimaryKey: product.productId) {
            do {
                try repository.realm.write {
                    self.repository.realm.delete(data)
                }
            } catch {
                
            }
        } else {
            repository.appendLikeList(product)
        }
        navigationItem.rightBarButtonItem?.image = checkLikeList()
    }
}

extension DetailViewController: MyDefinedFunctions {
    func checkLikeList() -> UIImage? {
        if let _ = repository.realm.object(ofType: LikeList.self, forPrimaryKey: product.productId) {
            return UIImage(systemName: "heart.fill")
        } else {
            return UIImage(systemName: "heart")
        }
    }
}
