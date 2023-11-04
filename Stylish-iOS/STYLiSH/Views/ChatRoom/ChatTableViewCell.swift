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
        messageLabel.setbackgroundColor(.brown)
            .setCornerRadius(15)
            .setTextColor(.white)
    }
    
    private func addTo() {
        contentView.addSubview( messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate( [
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }
}
