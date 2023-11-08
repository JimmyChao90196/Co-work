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
    var bgView = UIView()
    var addressLabel = UILabel()
    var openingTimeLabel = UILabel()
    var phoneNumLabel = UILabel()
    var divider = UIView()
    var stockNumberLabel = UILabel()
    
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
    
    private func addTo() {
        contentView.addSubviews([bgView])
        bgView.addSubviews([branchNameLabel,
                            addressLabel,
                            openingTimeLabel,
                            phoneNumLabel,
                            divider,
                            stockNumberLabel])}
    
    private func setup() {
        bgView.setbackgroundColor(.white)
        
        branchNameLabel.customSetup("微風旗艦店", "PingFangTC-Medium", 14, 0.1, hexColor: "#000000")
        addressLabel.customSetup("台北市信義區指南路二段65號2樓", "PingFangTC-Regular", 14, 0.1, hexColor: "#000000")
        openingTimeLabel.customSetup("營業時間: 10:00 ~ 22:00", "PingFangTC-Regular", 14, 0.1, hexColor: "#000000")
        phoneNumLabel.customSetup("聯絡方式: 02-6810-8294", "PingFangTC-Regular", 14, 0.1, hexColor: "#000000")
        stockNumberLabel.customSetup("2件", "PingFangTC-Medium", 18, 0.15, hexColor: "#000000")
        
        divider.setbackgroundColor(.hexToUIColor(hex: "#CCCCCC"))
        
        bgView.setBoarderColor(.hexToUIColor(hex: "#CCCCCC"))
            .setCornerRadius(15)
            .setBoarderWidth(1)
    }
    
    private func setupConstraint() {
        
        bgView.leadingConstr(to: contentView.leadingAnchor, 15)
            .trailingConstr(to: contentView.trailingAnchor, -15)
            .topConstr(to: contentView.topAnchor, 8)
            .bottomConstr(to: contentView.bottomAnchor, -8)
        
        branchNameLabel.leadingConstr(to: bgView.leadingAnchor, 15)
            .topConstr(to: bgView.topAnchor, 11)
            .bottomConstr(to: addressLabel.topAnchor, -6)
        
        addressLabel.leadingConstr(to: bgView.leadingAnchor, 15)
            .bottomConstr(to: openingTimeLabel.topAnchor, -2)
        
        openingTimeLabel.leadingConstr(to: bgView.leadingAnchor, 15)
            .bottomConstr(to: phoneNumLabel.topAnchor, -6)
        
        phoneNumLabel.leadingConstr(to: bgView.leadingAnchor, 15)
            .bottomConstr(to: bgView.bottomAnchor, -15)
        
        divider.widthConstr(1).topConstr(to: bgView.topAnchor, 14)
            .trailingConstr(to: stockNumberLabel.leadingAnchor, -12)
            .bottomConstr(to: bgView.bottomAnchor, -14)
            .widthConstr(1)
        
        stockNumberLabel.trailingConstr(to: bgView.trailingAnchor, -12)
            .centerYConstr(to: bgView.centerYAnchor)
    }
}
