//
//  ImageViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/19/24.
//

import UIKit

class ImageViewController: UIViewController, ConfigStoryBoardIdentifier {
    static var sbIdentifier: String = "Image"
    
    @IBOutlet var selectImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var selectedImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        designNavigationItem()
        designOutlets()
        configCollectionView()
    }
}

extension ImageViewController: DesignViews {
    func designOutlets() {
        collectionView.backgroundColor = ColorDesign.clear.fill
        configCollectionViewLayout()
        
        selectImageView.image = UIImage(named: selectedImage)
        designCircleImageView(selectImageView)
        designPointBorderImageView(selectImageView)
    }
    
    func designNavigationItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.title = "프로필 이미지 설정"
    }
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let xib = UINib(nibName: ImageCollectionViewCell.identifier, bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Profile.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        
        if selectedImage == Profile.images[indexPath.item] {
            designPointBorderImageView(cell.profileImageView)
        } else {
            cell.profileImageView.layer.borderWidth = 0
        }
        cell.configureCell(image: Profile.images[indexPath.item])
        DispatchQueue.main.async {
            self.designCircleImageView(cell.profileImageView)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = Profile.images[indexPath.item]
        selectImageView.image = UIImage(named: selectedImage)
        collectionView.reloadData()
    }
    
    func configCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (space * 5)
        
        layout.itemSize = CGSize(width: cellWidth/5 * 1.1, height: cellWidth/5 * 1.1)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.minimumLineSpacing = space * 2
        layout.minimumInteritemSpacing = space
        
        collectionView.collectionViewLayout = layout
    }
}

extension ImageViewController: ConfigButtonClicked {
    @objc func leftBarButtonClicked() {
        UserDefaultsManager.shared.setStringValue(.profile, value: selectedImage)
        navigationController?.popViewController(animated: true)
    }
}
