//
//  DetailViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/21/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, ConfigStoryBoardIdentifier{
    static var sbIdentifier: String = "Detail"
    
    @IBOutlet var webView: WKWebView!
    
    var itemTitle: String = ""
    var productId: String = ""
    var likeList: [String] = UserDefaultsManager.shared.getLikeList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        designOutlets()
        designNavigationItem()
    }
}

extension DetailViewController: DesignViews {
    func designOutlets() {
        let urlString = "https://msearch.shopping.naver.com/product/\(productId)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }
    
    func designNavigationItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        let rightButton = UIBarButtonItem(image: checkLikeList(), style: .plain, target: self, action: #selector(rightBarButtonClicked))
        navigationItem.title = replaceTitle(itemTitle)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightButton
    }
}

extension DetailViewController: ConfigButtonClicked {
    @objc func leftBarButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonClicked() {
        if likeList.count == 0 {
            print("add")
            likeList.append(productId)
            syncLikeList()
        } else {
            for idx in 0...likeList.count - 1 {
                if productId == likeList[idx] {
                    print("remove")
                    likeList.remove(at: idx)
                    syncLikeList()
                    return
                }
            }
            print("add2")
            likeList.append(productId)
            syncLikeList()
        }
    }
}

extension DetailViewController: MyDefinedFunctions {
    func checkLikeList() -> UIImage {
        if likeList.count == 0 {
            return UIImage(systemName: "heart")!
        } else {
            for idx in 0...likeList.count - 1 {
                if productId == likeList[idx] {
                    return UIImage(systemName: "heart.fill")!
                }
            }
        }
        return UIImage(systemName: "heart")!
    }
    
    func syncLikeList() {
        UserDefaultsManager.shared.setLikeList(value: likeList)
        likeList = UserDefaultsManager.shared.getLikeList()
        if navigationItem.rightBarButtonItem?.image == UIImage(systemName: "heart") {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        }
        
    }
}
