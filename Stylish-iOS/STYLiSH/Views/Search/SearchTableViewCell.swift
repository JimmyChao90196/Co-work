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
    
    let searchLabel = UILabel()
    let deleteButton = UIButton()
    
    // Delete by Closure.
    var deleteButtonAction: ((SearchTableViewCell) -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupDeleteButton()
        setupSearchLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            searchLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            searchLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
            
        ])
        
    }
    
    // Delete by Closure.
    @objc func deleteButtonTapped() {
        print(("Tapped"))
        deleteButtonAction?(self)
    }
    
    func setupDeleteButton() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
    
    }
    
    func setupSearchLabel() {
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(searchLabel)
    }
}
