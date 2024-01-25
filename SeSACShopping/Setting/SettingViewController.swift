//
//  SettingViewController.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/21/24.
//

import UIKit

class SettingViewController: UIViewController, ConfigStoryBoardIdentifier {
    static var sbIdentifier: String = "Setting"
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        designOutlets()
        designNavigationItem()
        
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension SettingViewController: DesignViews {
    func designOutlets() {
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
        
        let infoXib = UINib(nibName: InfoTableViewCell.identifier, bundle: nil)
        let settingXib = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        tableView.register(infoXib, forCellReuseIdentifier: InfoTableViewCell.identifier)
        tableView.register(settingXib, forCellReuseIdentifier: SettingTableViewCell.identifier)
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
            
            cell.selectionStyle = .none
            cell.configCell()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
            
            cell.textLabel?.text = Setting.allCases[indexPath.row].rawValue
            cell.textLabel?.font = FontDesign.mid.light
            cell.textLabel?.textColor = ColorDesign.text.fill
            cell.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            let sb = UIStoryboard(name: NicknameViewController.sbIdentifier, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: NicknameViewController.identifier) as! NicknameViewController
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath == IndexPath(row: Setting.allCases.count - 1, section: 1) {
            presentAlert(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?", button: "확인") {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let sb = UIStoryboard(name: "Onboard", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: OnboardViewController.identifier) as! OnboardViewController
                let nav = UINavigationController(rootViewController: vc)
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
}
