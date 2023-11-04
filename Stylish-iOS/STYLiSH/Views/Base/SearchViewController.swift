//
//  SearchViewController.swift
//  STYLiSH
//
//  Created by Ray Chang on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController {
    
    let searchTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchViewController()
    }
    
    func setupSearchViewController() {
        view.backgroundColor = .systemBackground
        
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(searchTableView)

        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell {
            
            if indexPath.row == 0 {
                cell.searchTextField.placeholder = "商品收尋"
                cell.searchTextField.borderStyle = .roundedRect
                cell.searchTextField.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(cell.searchTextField)
                
            } else if indexPath.row >= 1 && indexPath.row <= 4 {
                
                cell.searchLabel.text = "Label \(indexPath.row)"
                cell.searchLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(cell.searchLabel)
                
                cell.searchDeleteButton.setTitle("删除", for: .normal)
                cell.searchDeleteButton.setTitleColor(.red, for: .normal)
                cell.searchDeleteButton.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(cell.searchDeleteButton)
                
                // 添加按钮的点击事件
                //            cell.searchDeleteButton.addTarget(self, action: #selector(searchDeleteButtonTapped), for: .touchUpInside)
            } else if indexPath.row == 5 {
                // 在此处理 collection view
                //            setupCollectionView(in: cell.contentView)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70.0
        } else if indexPath.row >= 1 && indexPath.row <= 4 {
            return 50.0
        } else {
            return 258.0
        }
    }
}
