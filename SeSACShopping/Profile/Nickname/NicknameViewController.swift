//
//  NicknameViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit

class NicknameViewController: UIViewController {
    
    let nicknameView = NicknameView()
    let nicknameViewModel = NicknameViewModel()
    let repository = RealmRepository()
    
    var nowImage: String!
    
    override func loadView() {
        self.view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designViews()
        designNavigationItem()
        configureProfileImageAndNickname()
    }
}

extension NicknameViewController: DesignViews {
    func designViews() {
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        nicknameView.profileImageView.addGestureRecognizer(tapGesture)
        nicknameView.inputTextField.delegate = self
        nicknameView.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    func designNavigationItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.title = "프로필 설정"
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func configureProfileImageAndNickname() {
        let nowUser = repository.readUser()
        
        // 설정 - 프로필 수정
        if let nickname = nowUser.nickname, let profileImage = nowUser.profileImage {
            nicknameView.inputTextField.text = nickname
            nowImage = profileImage
            nicknameView.profileImageView.image = UIImage(named: profileImage)
        }
        // 초기화면 - 프로필 설정
        else {
            nowImage = Profile().returnRandomImage
            nicknameView.profileImageView.image = UIImage(named: nowImage)
        }
    }
}

// 텍스트 필드 관련
extension NicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nicknameViewModel.inputNicknameText.value = textField.text!
        nicknameViewModel.outputState.bind { state in
            self.nicknameView.stateLabel.text = state.text
            self.nicknameView.stateLabel.textColor = state.color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension NicknameViewController: ConfigButtonClicked {
    @objc func profileImageViewTapped() {
        let vc = ImageViewController()
        
        vc.selectedImage = nowImage
        vc.selectedImageClosure = { image in
            self.nowImage = image
            self.nicknameView.profileImageView.image = UIImage(named: image)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func completeButtonClicked() {
        nicknameViewModel.inputNicknameText.value = nicknameView.inputTextField.text!
        nicknameViewModel.outputState.bind { state in
            if state == .available {
                self.repository.updateUser(id: self.repository.readUser().id,
                                             nickname: self.nicknameView.inputTextField.text,
                                             profileImage: self.nowImage!)
                self.goToMainTabBarView()
            } else {
                self.nicknameView.inputTextField.text = ""
                self.presentAlert(title: "에러", message: "닉네임이 조건에 부합하지 않습니다.")
            }
        }
    }
    
    @objc func leftBarButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
