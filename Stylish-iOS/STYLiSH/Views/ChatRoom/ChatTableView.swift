//
//  FriendTableView.swift
//  FireBaseGroup2_iOS
//
//  Created by JimmyChao on 2023/10/24.
//

import UIKit

class ChatTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupTableView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(ChatUserTableViewCell.self, forCellReuseIdentifier: ChatUserTableViewCell.reuseIdentifier )
        self.register(ChatAdminTableViewCell.self, forCellReuseIdentifier: ChatAdminTableViewCell.reuseIdentifier)
        
        // Self sizing row height
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 150
        self.separatorStyle = .none
    }
}
