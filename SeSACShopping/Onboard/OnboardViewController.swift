//
//  OnBoardingViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit
import SnapKit

class OnboardViewController: UIViewController {

    let titleImageView = UIImageView()
    let mainImageView = UIImageView()
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        view.addSubviews([titleImageView, mainImageView, startButton])
        designViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaultsManager.shared.removeAll()
    }
}

extension OnboardViewController: DesignViews {
    func designViews() {
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = .sesacShopping
        mainImageView.image = .onboarding
        designPointColorButton(startButton, title: "시작하기")
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
}

extension OnboardViewController: SetupConstraints {
    func setupConstraints() {
        titleImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(130)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view).inset(32)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.height.equalTo(44)
        }
    }
}

extension OnboardViewController: ConfigButtonClicked {
    @objc func startButtonClicked() {
        let sb = UIStoryboard(name: NicknameViewController.sbIdentifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: NicknameViewController.identifier) as! NicknameViewController

        navigationController?.pushViewController(vc, animated: true)
    }
}
