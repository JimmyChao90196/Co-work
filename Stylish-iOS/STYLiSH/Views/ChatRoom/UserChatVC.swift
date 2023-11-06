//
//  ChatRoomViewController.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class UserChatViewController: UIViewController {
    
    let socketIOManager = SocketIOManager.shared
    let keyChainManager = KeyChainManager.shared

    var titleView = UILabel()
    var tableView = ChatTableView()
    var chatProvider = ChatProvider.shared
    let footerView = UIView()
    var inputField = UITextField()
    var isUser = true
    
    var leaveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        // Your logic to customize the button
        button.backgroundColor = .blue
        button.setTitle("leave the room", for: .normal)
        
        return button
    }()
    
    var switchButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.setTitle("User", for: .normal)
        return button
    }()
    
    var sendButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        button.setImage(UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    // MARK: - View did load -
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstranit()
        configureTitle()
        tableView.reloadData()
        scrollToBottom()
        
        socketIOManager.listenOnLeave()
        updateInCommingMessage()
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
    
    // Send button clicked
    @objc func sendButtonClicked() {
        guard let text = inputField.text, !text.isEmpty, let token = keyChainManager.token else { return }
        
        if self.isUser {
            
            chatProvider.userAppendMessages(inputText: text)
            
            Task {
                await socketIOManager.sendMessage("user", message: text, token: "\(token)")
                // chatProvider.userAppendMessages(inputText: text)
                tableView.reloadData()
                scrollToBottom()
                inputField.text = ""
            }
            
        } else {
            
            chatProvider.adminAppendMessages(inputText: text)
        }
        
        tableView.reloadData()
        scrollToBottom()
        inputField.text = ""
    }
    
    // Leave button action
    @objc func leaveButtonClicked() {
        socketIOManager.userLeave(token: keyChainManager.token ?? "none")
    }
    
    // Switch button action
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
    
    // MARK: - Action for incomming event.
    func updateInCommingMessage() {
        
        // Handle leave event
        socketIOManager.recievedLeaveEvent = { error in
            self.presentSimpleAlert(title: "Warning", message: error, buttonText: "Ok") {
                
                // Pop back to view controller
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        // Handle talk result
        socketIOManager.recievedTalkResult = { result in
            switch result {
                
            case .success(let successText):
                print("Look at me" + successText)
                self.chatProvider.adminAppendMessages(inputText: successText)
                
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                    scrollToBottom()
                }
                
            case .failure(let connectError):
                print(connectError)
                
                self.presentSimpleAlert(
                    title: "Error",
                    message: connectError.rawValue,
                    buttonText: "Ok")
            }
        }
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
            scrollToBottom()
        }
    }
    
    // MARK: - Basic setup -
    func setup() {
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        
        view.addSubviews([tableView, footerView])
        footerView.addSubviews([inputField, sendButton, switchButton])
        
        switchButton.setTitleColor(.hexToUIColor(hex: "3F3A3A"), for: .normal)
        sendButton.tintColor = .hexToUIColor(hex: "#3F3A3A")
        
        inputField.textAlignment = .left
        inputField.placeholder = "  Aa"
        inputField.backgroundColor = .hexToUIColor(hex: "#CCCCCC")
        inputField.setCornerRadius(10)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        footerView.backgroundColor = .hexToUIColor(hex: "#F5F5F5")
        footerView.setBoarderColor(.hexToUIColor(hex: "#CCCCCC"))
        footerView.setBoarderWidth(1)
        
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchButtonClicked), for: .touchUpInside)
        leaveButton.addTarget(self, action: #selector(leaveButtonClicked), for: .touchUpInside)
        
        // Create a UIBarButtonItem with title "Click Me"
        let leaveNavButton = UIBarButtonItem(title: "leave",
                                             style: .plain,
                                             target: self,
                                             action: #selector(leaveButtonClicked))

        // Add the button to the navigation bar on the right side
        navigationItem.rightBarButtonItem = leaveNavButton
        
        // Setup listener
        // socketIOManager.setupListener()
    }
    
    func setupConstranit() {
        
        switchButton.leadingConstr(to: footerView.leadingAnchor, 10)
            .centerYConstr(to: footerView.centerYAnchor, 0)
            .heightConstr(40)
            .widthConstr(55)
        
        sendButton.trailingConstr(to: view.trailingAnchor, -10)
            .centerYConstr(to: footerView.centerYAnchor, 0)
            .widthConstr(50)
            .heightConstr(50)
        
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
extension UserChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
                withIdentifier: ChatRightTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? ChatRightTableViewCell else { return UITableViewCell()}
            
            let date = chatProvider.mockConversationData[indexPath.row].sendTime
            cell.messageLabel.text = chatProvider.mockConversationData[indexPath.row].content
            cell.timeLabel.text = dateFormatter.string(from: date)
            cell.backgroundColor = .clear

            return cell
            
        case false:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatLeftTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? ChatLeftTableViewCell else { return UITableViewCell()}
            
            let formattedDate = dateFormatter.string(from: chatProvider.mockConversationData[indexPath.row].sendTime)
            cell.messageLabel.text = chatProvider.mockConversationData[indexPath.row].content
            cell.timeLabel.text = formattedDate
            cell.backgroundColor = .clear
            
            return cell
        }
    }
}

// MARK: - Configure title -
extension UserChatViewController {
    func configureTitle() {
        titleView.customSetup("客服中心", "PingFangTC-Medium", 18, 0.0, hexColor: "#3F3A3A")
        titleView.textAlignment = .center
        titleView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = titleView
    }
}
