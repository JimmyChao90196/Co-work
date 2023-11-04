//
//  RequestTableViewCell.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/24.
//

import UIKit
import Foundation

class ChatAdminTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ChatAdminTableViewCell.self)
    var messageLabel = UILabel()
    var timeLabel = UILabel()
    var textBG = UIView()
    var profileBG = UIView()
    var profilePic = UIImageView(image: UIImage(resource: .icons24PxCustomerService))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addTo()
        setup()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        messageLabel.numberOfLines = 0
        timeLabel.customSetup("", "PingFanTC-Regular", 4, 0.0, hexColor: "#CBCBCB")
        textBG.setCornerRadius(20)
            .setbackgroundColor(.systemPink)
        
        profileBG.clipsToBounds = true
        profilePic.clipsToBounds = true
        profilePic.backgroundColor = .clear
        
        profileBG.setCornerRadius(20)
            .setbackgroundColor(.lightGray)
    }
    
    private func addTo() {
        contentView.addSubviews([textBG, profileBG, timeLabel])
        textBG.addSubviews([messageLabel])
        profileBG.addSubviews([profilePic])
        
        messageLabel.textAlignment = .center
        timeLabel.textAlignment = .center
        timeLabel.setTextColor(.gray)
        messageLabel.setTextColor(.white)
    }

    private func setupConstraint() {
        
        profileBG.leadingConstr(to: contentView.leadingAnchor, 10)
            .topConstr(to: textBG.topAnchor, 5)
            .heightConstr(40)
            .widthConstr(40)
        
        profilePic.leadingConstr(to: profileBG.leadingAnchor, 5)
            .trailingConstr(to: profileBG.trailingAnchor, -5)
            .topConstr(to: profileBG.topAnchor, 5)
            .bottomConstr(to: profileBG.bottomAnchor, -5)
        
        timeLabel.leadingConstr(to: textBG.leadingAnchor, 0)
            .topConstr(to: textBG.bottomAnchor, 2)
            .bottomConstr(to: contentView.bottomAnchor, -2)
        
        NSLayoutConstraint.activate( [
            textBG.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textBG.leadingAnchor.constraint(equalTo: profileBG.trailingAnchor, constant: 10),
            textBG.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: 80),
            
            messageLabel.leadingAnchor.constraint(equalTo: textBG.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: textBG.trailingAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: textBG.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: textBG.bottomAnchor, constant: -15)
        ])
    }
}
