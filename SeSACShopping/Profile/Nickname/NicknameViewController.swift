//
//  NicknameViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

/*
 1. main 화면 만들고 완료 버튼이랑 연결하기
 */

import UIKit
import TextFieldEffects

class NicknameViewController: UIViewController {
    let profileImageView = UIImageView()
    let cameraImageView = UIImageView()
    let inputTextField = HoshiTextField()
    let stateLabel = UILabel()
    let completeButton = PointColorButton()
    
    var available: Bool = true
    var nowImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        view.addSubviews([profileImageView, cameraImageView, inputTextField, stateLabel, completeButton])
        designNavigationItem()
        designViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let profile = UserDefaultsManager.shared.getStringValue(.profile)
        
        nowImage = profile.isEmpty ? Profile().returnRandomImage : profile
        profileImageView.image = UIImage(named: nowImage)
        
        let nickname = UserDefaultsManager.shared.getStringValue(.nickname)
        
        inputTextField.text = nickname
    }
}

extension NicknameViewController: SetupConstraints {
    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(120)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        cameraImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageView)
            make.size.equalTo(30)
        }
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(24)
            make.top.equalTo(cameraImageView.snp.bottom).offset(40)
            make.height.equalTo(66)
        }
        stateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(32)
            make.top.equalTo(inputTextField.snp.bottom).offset(8)
            make.height.equalTo(22)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view).inset(24)
            make.height.equalTo(44)
        }
    }
}

// 텍스트 필드 관련
extension NicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        stateLabel.isHidden = false
        
        let state = isCheck(text: textField.text!)
        
        stateLabel.text = state.text
        stateLabel.textColor = state.color
        
        available = state == .available ? true : false
    }
}
// 아웃렛 변수, 네비게이션 설정 관련
extension NicknameViewController: DesignViews {
    func designViews() {
        inputTextField.delegate = self
        
        designCircleImageView(profileImageView)
        designPointBorderImageView(profileImageView)
        profileImageView.isUserInteractionEnabled = true
        
        cameraImageView.image = .camera
        designCircleImageView(cameraImageView)
        
        inputTextField.placeholder = "닉네임을 입력해주세요 :)"
        inputTextField.borderStyle = .none
        inputTextField.textColor = ColorDesign.text.fill
        inputTextField.font = FontDesign.biggest.light
        inputTextField.borderInactiveColor = ColorDesign.text.fill
        inputTextField.borderActiveColor = ColorDesign.point.fill
        inputTextField.placeholderColor = .systemGray
        inputTextField.placeholderFontScale = 1.1
        
        stateLabel.font = FontDesign.mid.light
        stateLabel.isHidden = true
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    func designNavigationItem() {
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.title = "프로필 설정"
        navigationItem.leftBarButtonItem = leftBarButton
    }
}

extension NicknameViewController: ConfigButtonClicked {
    
    @IBAction func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: ImageViewController.sbIdentifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ImageViewController.identifier) as! ImageViewController
        
        vc.selectedImage = nowImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func completeButtonClicked() {
        // 닉네임이 조건에 맞지 않을때 경고창 보여주고 textfield 글자 다 지우기
        if !available {
            inputTextField.text = ""
            presentAlert()
        } else {
            UserDefaultsManager.shared.setStringValue(.nickname, value: inputTextField.text!)
            UserDefaultsManager.shared.setStringValue(.profile, value: nowImage)
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    @objc func leftBarButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

extension NicknameViewController: MyDefinedFunctions {
    func presentAlert() {
        let alert = UIAlertController(title: "에러", message: "닉네임이 조건에 부합하지 않습니다.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "돌아가기", style: .cancel)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func isCheck(text: String) -> NicknameState {
        // @, #, $, % 특수문자가 들어 있을 경우
        if text.contains("@") || text.contains("#") || text.contains("$") || text.contains("%") {
            return .special
        }
        // 숫자가 들어 있을 경우
        if text.contains("0") || text.contains("1") || text.contains("2") || text.contains("3") || text.contains("4") || text.contains("5") || text.contains("6") || text.contains("7") || text.contains("8") || text.contains("9") {
            return .number
        }
        // 2글자 이상 10글자 미만이 아닐 경우
        if text.count < 2 || text.count >= 10 {
            return .length
        }
        
        return .available
    }
}
