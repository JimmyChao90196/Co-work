//
//  ChatRoomViewController.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {

    var tableView = ChatTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setup()
        setupConstranit()
    }
    
    func setup() {
        view.addSubview(tableView)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstranit() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ChatTableViewCell else { return UITableViewCell()}
        
        cell.messageLabel.text = "sasdfjsaljdf;asjsdfasdfasdfasdfasdfasdfafdfadafasfdasfadfdf;askdjf;askjdf;skjdf;kasj;dfa"
        return cell
    }
}
