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

class NicknameViewController: UIViewController, ConfigIdentifier {
    static var identifier: String = "NicknameViewController"
    static var sbIdentifier: String = "Nickname"

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var cameraImageView: UIImageView!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var completeButton: UIButton!
    
    var available: Bool = true
    var nowImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        designNavigationItem()
        designOutlets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let profile = UserDefaultsManager.shared.getStringValue(.profile)
        
        nowImage = profile.isEmpty ? Profile().returnRandomImage : profile
        profileImageView.image = UIImage(named: nowImage)
        
        let nickname = UserDefaultsManager.shared.getStringValue(.nickname)
        
        inputTextField.text = nickname
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
    func designOutlets() {
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
        
        stateLabel.font = FontDesign.mid.light
        stateLabel.isHidden = true
        
        designPointColorButton(completeButton, title: "완료")
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
