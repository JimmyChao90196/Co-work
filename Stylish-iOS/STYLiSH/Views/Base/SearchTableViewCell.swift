//
//  SearchTableViewCell.swift
//  STYLiSH
//
//  Created by Ray Chang on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell {
    let searchTextField = UITextField()
    let searchLabel = UILabel()
    let searchDeleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(searchTextField)
        addSubview(searchLabel)
        addSubview(searchDeleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            searchTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            searchLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            searchLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            searchDeleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchDeleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
         
        ])
        
    }
}
