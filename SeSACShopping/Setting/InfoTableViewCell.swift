//
//  InfoTableViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/21/24.
//

import UIKit

class InfoTableViewCell: UITableViewCell, ConfigIdentifier {
    static var identifier: String = "InfoTableViewCell"
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var textsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        designCell()
    }
    
    func designCell() {
        designCircleImageView(profileImageView)
        designPointBorderImageView(profileImageView)
        nicknameLabel.textColor = ColorDesign.text.fill
        nicknameLabel.font = FontDesign.biggest.bold
        likeLabel.textColor = ColorDesign.point.fill
        likeLabel.font = FontDesign.small.bold
        textsLabel.text = "을 좋아하고 있어요!"
        textsLabel.textColor = ColorDesign.text.fill
        textsLabel.font = FontDesign.small.bold
    }
    
    func configCell() {
        let profile = UserDefaultsManager.shared.getStringValue(.profile)
        let nickname = UserDefaultsManager.shared.getStringValue(.nickname)
        let likeList = UserDefaultsManager.shared.getLikeList()
        
        profileImageView.image = UIImage(named: profile)
        nicknameLabel.text = nickname
        likeLabel.text = "\(likeList.count)개의 상품"
    }
}
