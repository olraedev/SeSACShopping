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
    let startButton = PointColorButton()
    let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundColor()
        view.addSubviews([titleImageView, mainImageView, startButton])
        designViews()
        configConstraints()
        repository.createUser()
    }
}

extension OnboardViewController: DesignViews {
    func designViews() {
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = .sesacShopping
        mainImageView.image = .onboarding
        startButton.setTitle("시작하기", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
}

extension OnboardViewController: ConfigConstraints {
    func configConstraints() {
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
        let vc = NicknameViewController()

        navigationController?.pushViewController(vc, animated: true)
    }
}
