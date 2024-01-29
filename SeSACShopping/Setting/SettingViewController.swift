//
//  SettingViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/21/24.
//

import UIKit

class SettingViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        view.addSubview(tableView)
        designViews()
        designNavigationItem()
        configConstraints()
        
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}
extension SettingViewController: ConfigConstraints {
    func configConstraints() {
        tableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SettingViewController: DesignViews {
    func designViews() {
        tableView.backgroundColor = ColorDesign.bgc.fill
    }
    
    func designNavigationItem() {
        navigationItem.title = "설정"
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifier)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        else { return Setting.allCases.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
            
            cell.configCell()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
            
            cell.titleLabel.text = Setting.allCases[indexPath.row].rawValue
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            let vc = NicknameViewController()
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath == IndexPath(row: Setting.allCases.count - 1, section: 1) {
            presentAlert(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?", button: "확인") {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let nav = UINavigationController(rootViewController: OnboardViewController())
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
}
