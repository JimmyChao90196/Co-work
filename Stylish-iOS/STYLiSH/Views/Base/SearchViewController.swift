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
    let searchTextField = UITextField()
    let searchButton = UIButton()
    
    var searchHistory: [String] = ["無商品收尋紀錄", "無商品收尋紀錄", "無商品收尋紀錄", "無商品收尋紀錄"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchTableView()
        setupTextField()
        setupSearchButton()
        setupConstraint()
        
    }
    func setupSearchTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(searchTableView)
    }
    
    func setupTextField() {
        searchTextField.placeholder = "收尋商品"
        searchTextField.borderStyle = .roundedRect
        view.addSubview(searchTextField)
    }
    
    func setupSearchButton() {
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        view.addSubview(searchButton)
    }
    
    func setupConstraint() {
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110),
            
            searchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchButton.leadingAnchor.constraint(greaterThanOrEqualTo: searchTextField.trailingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set table view cell number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell {
            cell.searchLabel.text = String(searchHistory[indexPath.row])
            
            // Delete by Closure.
            cell.deleteButtonAction = { [weak self] cell in
                self?.deleteCell(for: cell)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    // Delete by Closure.
    func deleteCell(for cell: SearchTableViewCell) {
        if let indexPath = searchTableView.indexPath(for: cell) {
            searchHistory.remove(at: indexPath.row)
            searchTableView.deleteRows(at: [indexPath], with: .automatic)
            print("Delete search history: \(searchHistory)")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchHeaderView = UIView()
        
        let label = UILabel()
        label.text = "收尋紀錄"
        label.translatesAutoresizingMaskIntoConstraints = false
        searchHeaderView.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: searchHeaderView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: searchHeaderView.trailingAnchor, constant: -15),
            label.centerYAnchor.constraint(equalTo: searchHeaderView.centerYAnchor)
            
        ])
        
        return searchHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    @objc func searchButtonTapped() {
        // Handle search button action here
        // You can implement the search functionality when the button is tapped
    }
    
}
