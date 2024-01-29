//
//  ResultViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/20/24.
//

import UIKit
import Toast

class ResultViewController: UIViewController {
    let totalLabel = UILabel()
    let simButton = UIButton()
    let dateButton = UIButton()
    let dscButton = UIButton()
    let ascButton = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configCollectionViewLayout())
    
    lazy var buttons: [UIButton] = [simButton, dateButton, dscButton, ascButton]
    var keyword: String = ""
    var list: Info = Info(total: 0, start: 0, display: 0, items: [])
    var likeList: [String] = UserDefaultsManager.shared.getLikeList()
    var start: Int = 1
    var nowSort: Sort = .sim
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        view.addSubviews([totalLabel, simButton, dateButton, dscButton, ascButton, collectionView])
        designViews()
        designNavigationItem()
        configConstraints()
        
        configCollectionView()
        requestToNaverShopping(start: start, sort: nowSort.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        likeList = UserDefaultsManager.shared.getLikeList()
        collectionView.reloadData()
    }
}

extension ResultViewController: ConfigConstraints {
    func configConstraints() {
        totalLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.equalTo(22)
        }
        simButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(view).offset(8)
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
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ResultViewController: DesignViews {
    func designViews() {
        totalLabel.textColor = ColorDesign.point.fill
        totalLabel.font = FontDesign.small.bold
        
        designButtons()
        
        collectionView.backgroundColor = .clear
    }
    
    func designNavigationItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.title = "\(keyword)"
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func designButtons() {
        for idx in 0...buttons.count - 1 {
            buttons[idx].setTitle(Sort.allCases[idx].title, for: .normal)
            buttons[idx].layer.borderColor = ColorDesign.text.fill.cgColor
            buttons[idx].layer.borderWidth = 1
            buttons[idx].layer.cornerRadius = 8
            buttons[idx].titleLabel?.font = FontDesign.small.light
            buttons[idx].setTitleColor(ColorDesign.text.fill, for: .normal)
            buttons[idx].tag = idx
            buttons[idx].addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        }
        simButton.setTitleColor(ColorDesign.bgc.fill, for: .normal)
        simButton.backgroundColor = ColorDesign.text.fill
    }
}

extension ResultViewController: ConfigButtonClicked {
    @objc func leftBarButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        nowSort = Sort.allCases[sender.tag]
        requestToNaverShopping(start: start, sort: Sort.allCases[sender.tag].rawValue)
        collectionView.setContentOffset(.zero, animated: false)
        for button in buttons {
            if button == sender {
                button.setTitleColor(ColorDesign.bgc.fill, for: .normal)
                button.backgroundColor = ColorDesign.text.fill
            } else {
                button.setTitleColor(ColorDesign.text.fill, for: .normal)
                button.backgroundColor = ColorDesign.bgc.fill
            }
        }
        collectionView.reloadData()
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        let productId = list.items[sender.tag].productId
        
        if likeList.count == 0 {
            view.makeToast("찜 목록에 추가하였습니다!", duration: 1)
            likeList.append(productId)
            syncLikeList()
        } else {
            for idx in 0...likeList.count - 1 {
                if productId == likeList[idx] {
                    view.makeToast("상품을 찜 목록에서 삭제하셨습니다!", duration: 1)
                    likeList.remove(at: idx)
                    syncLikeList()
                    return
                }
            }
            view.makeToast("찜 목록에 추가하였습니다!", duration: 1)
            likeList.append(productId)
            syncLikeList()
        }
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        
        cell.likeButton.tag = indexPath.row
        cell.configureCell(list.items[indexPath.row], likeList: likeList)
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        vc.itemTitle = list.items[indexPath.row].title
        vc.productId = list.items[indexPath.row].productId
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configCollectionViewLayout() -> UICollectionViewLayout{
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

extension ResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
        
        for item in indexPaths {
            if list.items.count - 3 == item.row {
                start += 30
                APIManager().requestNaverShopping(query: keyword, display: 30, start: start, sort: nowSort.rawValue) { info in
                    self.list.items.append(contentsOf: info.items)
                    self.collectionView.reloadData()
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
            self.totalLabel.text = "\(info.total.formatted()) 개의 검색 결과"
            self.list = info
            self.collectionView.reloadData()
        }
    }
    
    func syncLikeList() {
        UserDefaultsManager.shared.setLikeList(value: likeList)
        likeList = UserDefaultsManager.shared.getLikeList()
        collectionView.reloadData()
    }
}
