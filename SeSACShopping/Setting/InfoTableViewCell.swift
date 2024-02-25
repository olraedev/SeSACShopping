//
//  InfoTableViewCell.swift
//  SeSACShopping
//
//  Created by SangRae Kim on 1/21/24.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    let profileImageView = PointColorBorderImageView(frame: .zero)
    let nicknameLabel = UILabel()
    let likeLabel = UILabel()
    let textsLabel = UILabel()
    let repository = RealmRepository()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
        contentView.addSubviews([profileImageView, nicknameLabel, likeLabel, textsLabel])
        designCell()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InfoTableViewCell: ConfigConstraints {
    func configConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView).inset(24)
            make.size.equalTo(60)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(32)
            make.top.equalTo(contentView).offset(24)
            make.height.equalTo(33)
        }
        likeLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(32)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.height.equalTo(22)
        }
        textsLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeLabel.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.height.equalTo(22)
        }
    }
}

extension InfoTableViewCell {
    func designCell() {
        selectionStyle = .none
        nicknameLabel.textColor = ColorDesign.text.fill
        nicknameLabel.font = FontDesign.biggest.bold
        likeLabel.textColor = ColorDesign.point.fill
        likeLabel.font = FontDesign.small.bold
        textsLabel.text = "을 좋아하고 있어요!"
        textsLabel.textColor = ColorDesign.text.fill
        textsLabel.font = FontDesign.small.bold
    }
    
    func configCell() {
        let user = repository.readUser()
        let profile = user.profileImage!
        let nickname = user.nickname
        let likeList = repository.readUser().likeList
        
        profileImageView.image = UIImage(named: profile)
        nicknameLabel.text = nickname
        likeLabel.text = "\(likeList.count)개의 상품"
    }
}
