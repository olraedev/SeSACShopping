//
//  OnBoardingViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/18/24.
//

import UIKit

class OnboardViewController: UIViewController, ConfigIdentifier {
    static var identifier: String = "OnboardViewController"
    static var sbIdentifier: String = "Onboard"
    
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var onBoardImageView: UIImageView!
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        designOutlets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaultsManager.shared.removeAll()
    }
}

extension OnboardViewController: DesignViews {
    func designOutlets() {
        titleImageView.contentMode = .scaleToFill
        titleImageView.image = .sesacShopping
        onBoardImageView.image = .onboarding
        designPointColorButton(startButton, title: "시작하기")
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
}

extension OnboardViewController: ConfigButtonClicked {
    @objc func startButtonClicked() {
        let sb = UIStoryboard(name: NicknameViewController.sbIdentifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: NicknameViewController.identifier) as! NicknameViewController

        navigationController?.pushViewController(vc, animated: true)
    }
}
