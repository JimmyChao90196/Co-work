//
//  BranchCell.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/7.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import UIKit


class BranchCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: BranchCell.self)
    var branchNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addTo()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func addTo(){
        contentView.addSubviews([branchNameLabel])
    }
    
    private func setup(){
        branchNameLabel.customSetup("placeholder", "PingFangTC-Regular", 18, 0.1, hexColor: "#3F3A3A")
    }
    
    private func setupConstraint(){
        branchNameLabel.centerXConstr(to: contentView.centerXAnchor)
            .centerYConstr(to: contentView.centerYAnchor)
    }
}
