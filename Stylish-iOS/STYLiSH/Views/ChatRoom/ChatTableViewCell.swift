//
//  RequestTableViewCell.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/24.
//

import UIKit
import Foundation

class ChatTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ChatTableViewCell.self)
    var messageLabel = UILabel()
    var textBG = UIView()
    
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
        textBG.setCornerRadius(20)
            .setbackgroundColor(.blue)
    }
    
    private func addTo() {
        contentView.addSubviews([textBG])
        textBG.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.setTextColor(.white)
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate( [
            textBG.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textBG.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textBG.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: 0),
            textBG.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            messageLabel.leadingAnchor.constraint(equalTo: textBG.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: textBG.trailingAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: textBG.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: textBG.bottomAnchor, constant: -15)
        ])
    }
}
