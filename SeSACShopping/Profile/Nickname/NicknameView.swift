//
//  NicknameView.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 2/24/24.
//

import UIKit
import TextFieldEffects

class NicknameView: UIView {
    
    lazy var profileImageView = PointColorBorderImageView(frame: .zero)
    let cameraImageView = PointColorBorderImageView(frame: .zero)
    let inputTextField = HoshiTextField()
    let stateLabel = UILabel()
    let completeButton = PointColorButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundColor()
        addSubviews([profileImageView, cameraImageView, inputTextField, stateLabel, completeButton])
        designViews()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NicknameView: ConfigConstraints {
    func configConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.size.equalTo(120)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(32)
        }
        cameraImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageView)
            make.size.equalTo(30)
        }
        inputTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(24)
            make.top.equalTo(cameraImageView.snp.bottom).offset(40)
            make.height.equalTo(66)
        }
        stateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(32)
            make.top.equalTo(inputTextField.snp.bottom).offset(8)
            make.height.equalTo(22)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(stateLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self).inset(24)
            make.height.equalTo(44)
        }
    }
}

// 아웃렛 변수, 네비게이션 설정 관련
extension NicknameView: DesignViews {
    func designViews() {
        profileImageView.isUserInteractionEnabled = true
        
        cameraImageView.image = .camera
        cameraImageView.layer.borderWidth = 0
        
        inputTextField.placeholder = "닉네임을 입력해주세요 :)"
        inputTextField.borderStyle = .none
        inputTextField.textColor = ColorDesign.text.fill
        inputTextField.font = FontDesign.biggest.light
        inputTextField.borderInactiveColor = ColorDesign.text.fill
        inputTextField.borderActiveColor = ColorDesign.point.fill
        inputTextField.placeholderColor = .systemGray
        inputTextField.placeholderFontScale = 1.1
        
        stateLabel.font = FontDesign.mid.light
        
        completeButton.setTitle("완료", for: .normal)
    }
}
