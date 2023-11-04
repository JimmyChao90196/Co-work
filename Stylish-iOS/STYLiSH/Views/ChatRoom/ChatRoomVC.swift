//
//  ChatRoomViewController.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatRoomViewController: UIViewController {

    var titleView = UILabel()
    var tableView = ChatTableView()
    var chatProvider = ChatProvider.shared
    let footerView = UIView()
    var inputField = UITextField()
    var isUser = true
    
    var switchButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        button.backgroundColor = .yellow
        button.setTitle("User", for: .normal)
        return button
    }()
    
    var sendButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        
        button.backgroundColor = .cyan
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        return button
    }()
    
    // MARK: - View did load -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setup()
        setupConstranit()
        configureTitle()
        tableView.reloadData()
        scrollToBottom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Button Action -
    @objc func sendButtonClicked() {
        guard let text = inputField.text, !text.isEmpty else { return }
        
        if self.isUser {
            chatProvider.userAppendMessages(inputText: text)
            
        } else {
            
            chatProvider.adminAppendMessages(inputText: text)
        }
        
        tableView.reloadData()
        scrollToBottom()
        inputField.text = ""
    }
    
    @objc func switchButtonClicked() {
        isUser.toggle()
        if isUser {
            switchButton.setTitle("User", for: .normal)
        } else {
            switchButton.setTitle("Admin", for: .normal)
        }
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async { [self] in
            let indexPath = IndexPath(
                row: tableView.numberOfRows(inSection: 0) - 1,
                section: 0)
            
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - Basic setup -
    func setup() {
        view.addSubviews([tableView, footerView])
        footerView.addSubviews([inputField, sendButton, switchButton])
        
        inputField.textAlignment = .left
        inputField.placeholder = "  Aa"
        inputField.setCornerRadius(10)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        footerView.backgroundColor = .gray
        inputField.backgroundColor = .lightGray
        
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
    }
    
    func setupConstranit() {
        
        switchButton.leadingConstr(to: footerView.leadingAnchor, 10)
            .centerYConstr(to: footerView.centerYAnchor, 0)
            .heightConstr(40)
            .widthConstr(40)
        
        sendButton.trailingConstr(to: view.trailingAnchor, -10)
            .centerYConstr(to: footerView.centerYAnchor, 0)
            .widthConstr(35)
            .heightConstr(35)
        
        footerView.leadingConstr(to: view.leadingAnchor, 0)
            .trailingConstr(to: view.trailingAnchor, 10)
            .bottomConstr(to: view.safeAreaLayoutGuide.bottomAnchor, 0)
            .heightConstr(50)
        
        inputField.leadingConstr(to: switchButton.trailingAnchor, 10)
            .trailingConstr(to: sendButton.leadingAnchor, -10)
            .bottomConstr(to: footerView.bottomAnchor, -10)
            .topConstr(to: footerView.topAnchor, 10)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
    }
}

// MARK: - Delegate and DataSource method -
extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatProvider.mockConversationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isUser = chatProvider.mockConversationData[indexPath.row].isUser
        
        // Date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE HH:mm"
        
        switch isUser {
        case true:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatUserTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? ChatUserTableViewCell else { return UITableViewCell()}
            
            let date = chatProvider.mockConversationData[indexPath.row].sendTime
            cell.messageLabel.text = chatProvider.mockConversationData[indexPath.row].content
            cell.timeLabel.text = dateFormatter.string(from: date)
            cell.backgroundColor = .clear

            return cell
            
        case false:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatAdminTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? ChatAdminTableViewCell else { return UITableViewCell()}
            
            let formattedDate = dateFormatter.string(from: chatProvider.mockConversationData[indexPath.row].sendTime)
            cell.messageLabel.text = chatProvider.mockConversationData[indexPath.row].content
            cell.timeLabel.text = formattedDate
            cell.backgroundColor = .clear
            
            return cell
        }
    }
}

// MARK: - Configure title -
extension ChatRoomViewController {
    func configureTitle() {
        titleView.customSetup("客服中心", "PingFangTC-Medium", 18, 0.0, hexColor: "#3F3A3A")
        titleView.textAlignment = .center
        titleView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = titleView
    }
}
