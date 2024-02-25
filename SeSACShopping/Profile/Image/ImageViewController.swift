//
//  ImageViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit
import SnapKit

class ImageViewController: UIViewController {
    let selectImageView = PointColorBorderImageView(frame: .zero)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configCollectionViewLayout())
    
    var selectedImage: String = ""
    var selectedImageClosure: ((String) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        view.addSubviews([selectImageView, collectionView])
        designNavigationItem()
        designViews()
        configConstraints()
        configCollectionView()
    }
}

extension ImageViewController: DesignViews {
    func designViews() {
        selectImageView.image = UIImage(named: selectedImage)
        
        collectionView.backgroundColor = ColorDesign.clear.fill
    }
    
    func designNavigationItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.title = "프로필 이미지 설정"
    }
}

extension ImageViewController: ConfigConstraints {
    func configConstraints() {
        selectImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.size.equalTo(150)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(selectImageView.snp.bottom).offset(32)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Profile.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        
        if selectedImage == Profile.images[indexPath.item] {
            cell.profileImageView.layer.borderWidth = 5
        } else {
            cell.profileImageView.layer.borderWidth = 0
        }
        cell.configureCell(image: Profile.images[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = Profile.images[indexPath.item]
        selectImageView.image = UIImage(named: selectedImage)
        collectionView.reloadData()
    }
    
    static func configCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (space * 5)
        
        layout.itemSize = CGSize(width: cellWidth/5 * 1.1, height: cellWidth/5 * 1.1)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.minimumLineSpacing = space * 2
        layout.minimumInteritemSpacing = space
        
        return layout
    }
}

extension ImageViewController: ConfigButtonClicked {
    @objc func leftBarButtonClicked() {
        selectedImageClosure(selectedImage)
        navigationController?.popViewController(animated: true)
    }
}
