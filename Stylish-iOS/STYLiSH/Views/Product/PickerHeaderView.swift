//
//  PickerHeaderView.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/7.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import UIKit

// MARK: - HeaderView -
class CartHeaderView: UIView {
    
    // Section header element
    var titleLabel = UILabel()
    var priceLabel = UILabel()
    var divider = UIView()
    var closeButton = UIButton()
    
    convenience init(title: String, price: String) {
        self.init(frame: .zero)
        titleLabel.text = title
        priceLabel.text = price
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTo()
        setupHeaderView()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addTo() {
        self.addSubview(titleLabel)
        self.addSubview(priceLabel)
        self.addSubview(divider)
        self.addSubview(closeButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Setup buttons
    func setupButton() {
        closeButton.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
        //closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor, multiplier: 1)
        ])
    }
    
    // Setup cart view
    func setupHeaderView() {
        divider.backgroundColor = .hexStringToUIColor(hex: "#CCCCCC")
        self.backgroundColor = .white
        
        titleLabel.customSetup("厚實毛呢格子外套", "PingFangTC-Regular", 18, 0.15, hexColor: "#3F3A3A")
        priceLabel.customSetup("NT$2140", "PingFangTC-Regular", 18, 0.15, hexColor: "#3F3A3A")
        
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            
            priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16)
        ])
    }
}
