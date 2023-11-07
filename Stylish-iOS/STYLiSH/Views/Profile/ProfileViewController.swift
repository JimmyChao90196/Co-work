//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelInfo: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    private let manager = ProfileManager()
    
    private let userProvider = UserProvider()
    
    let socketIOManager = SocketIOManager.shared
    
    let keyChainManager = KeyChainManager.shared
    
    let lkProgressHud = LKProgressHUD.shared
    
    let chatManager = ChatManager.shared
    
    let chatProvider = ChatProvider.shared
    
    private var user: User? {
        didSet {
            if let user = user {
                updateUser(user)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        print(keyChainManager.token ?? "none")
        
        // Customize navigation bar
        UINavigationBar.appearance().backgroundColor = .hexToUIColor(hex: "#3F3A3A")
        
    }

    // MARK: - Action
    private func fetchData() {
        userProvider.getUserProfile(completion: { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                print(user)
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
    
    private func updateUser(_ user: User) {
        imageProfile.loadImage(user.picture, placeHolder: .asset(.Icons_36px_Profile_Normal))
        
        labelName.text = user.name
        labelInfo.text = user.getUserInfo()
        labelInfo.isHidden = false
    }
}

extension ProfileViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.groups.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.groups[section].items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProfileCollectionViewCell.self),
            for: indexPath
        )
        guard let profileCell = cell as? ProfileCollectionViewCell else { return cell }
        let item = manager.groups[indexPath.section].items[indexPath.row]
        profileCell.layoutCell(image: item.image, text: item.title)
        return profileCell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: String(describing: ProfileCollectionReusableView.self),
                for: indexPath
            )
            guard let profileView = header as? ProfileCollectionReusableView else { return header }
            let group = manager.groups[indexPath.section]
            profileView.layoutView(title: group.title, actionText: group.action?.title)
            return profileView
        }
        return UICollectionReusableView()
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.width / 5.0, height: 60.0)
        } else if indexPath.section == 1 {
            return CGSize(width: UIScreen.width / 4.0, height: 60.0)
        }
        return CGSize.zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 24.0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: UIScreen.width, height: 48.0)
    }
}

// MARK: - Delegate methods
extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) 
                as? ProfileCollectionViewCell else { return }
        
        // If the user tapped customer service
        if cell.textLbl.text == "客服訊息" {
            userTapped()
        }
 
        if cell.textLbl.text == "admin" {
            adminTapped()
        }
        
        if cell.textLbl.text == "收藏" {
            testTapped()
        }
    }
    
    // MARK: - If user is tapped -
    func userTapped() {
        LKProgressHUD.showFor(1.5)
        socketIOManager.setup()
        
        socketIOManager.listenForConnected { id in
            print("Socket connected and id is: \(id)")
            self.socketIOManager.setupListener()
            self.socketIOManager.userCheck(token: self.keyChainManager.token ?? "none")
            
            self.socketIOManager.recievedConnectionResult = { result in
                
                switch result {
                    
                case .success(let successText):
                    print(successText)
                    
                    DispatchQueue.main.async {
                        let chatRoomVC = UserChatViewController()
                        self.navigationController?.pushViewController(chatRoomVC, animated: true)
                        
                    }
                    
                    // Fetch chat history
                    self.chatManager.fetchHistory { result in
                        switch result {
                        case .success(let history):
                            print("Successfully fetched history: \(history)")
                            self.chatProvider.conversationHistory.append(contentsOf: history)
                            
                            DispatchQueue.main.async {
                                let chatRoomVC = UserChatViewController()
                                self.navigationController?.pushViewController(chatRoomVC, animated: true)
                            }
                            
                        case .failure(let error):
                            print("You failed: \(error)")
                        }
                    }
                    
                case .failure(let connectError):
                    print(connectError)
                    
                    self.presentSimpleAlert(
                        title: "Error",
                        message: connectError.rawValue,
                        buttonText: "Ok")
                }
            }
        }
        
        // Listen for disconnection
        socketIOManager.listenForDisconnected { id in
            print("Socket disconnected and id is: \(id)")
        }
    }
    
    // MARK: - If test button is tapped -
    func testTapped() {

        // Fetch chat history
        self.chatManager.fetchHistory { result in
            switch result {
            case .success(let history):
                print("Successfully fetched history: \(history)")
                
            case .failure(let error):
                print("You failed: \(error)")
            }
        }
    }
    
    // MARK: - If admin is tapped -
    func adminTapped() {
        LKProgressHUD.showFor(1.5)
        socketIOManager.setup()
        
        socketIOManager.listenForConnected { id in
            print("Socket connected and id is: \(id)")
            self.socketIOManager.setupListener()
            self.socketIOManager.adminCheck(token: self.keyChainManager.token ?? "none")
            
            self.socketIOManager.recievedConnectionResult = { result in
                
                switch result {
                    
                case .success(let successText):
                    print(successText)
                    
                    // Fetch chat history
//                    self.chatManager.fetchHistory { result in
//                        switch result {
//                        case .success(let history):
//                            print("Successfully fetched history: \(history)")
//                            self.chatProvider.conversationHistory.append(contentsOf: history)
//                            
//                            DispatchQueue.main.async {
//                                let chatRoomVC = AdminChatViewController()
//                                self.navigationController?.pushViewController(chatRoomVC, animated: true)
//                            }
//                            
//                        case .failure(let error):
//                            print("You failed: \(error)")
//                        }
//                    }
                    
                case .failure(let connectError):
                    print(connectError)
                    
                    self.presentSimpleAlert(
                        title: "Error",
                        message: connectError.rawValue,
                        buttonText: "Ok")
                }
            }
        }
        
        // Listen for disconnection
        socketIOManager.listenForDisconnected { id in
            print("Socket disconnected and id is: \(id)")
        }
    }
}
