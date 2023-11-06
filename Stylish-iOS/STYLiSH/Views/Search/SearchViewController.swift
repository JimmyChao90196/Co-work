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
    let image = UIImageView()
    
    var searchHistory: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchTableView()
        setupTextField()
        setupSearchButton()
        setupImage()
        setupConstraint()
        
        if let savedSearchHistory = UserDefaults.standard.stringArray(forKey: "SearchHistory") {
               searchHistory = savedSearchHistory
           }
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
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.layer.borderWidth = 2.0
        searchButton.layer.borderColor = UIColor.darkGray.cgColor
        searchButton.layer.cornerRadius = 8.0
        searchButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        view.addSubview(searchButton)
    }
    
    func setupImage() {
        image.image = UIImage(named: "Image_Logo02")
        image.contentMode = .scaleAspectFit
        view.addSubview(image)
    }
    
    func setupConstraint() {
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130),
            
            searchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchButton.leadingAnchor.constraint(greaterThanOrEqualTo: searchTextField.trailingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            image.topAnchor.constraint(equalTo: searchTableView.bottomAnchor),
            image.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            
            UserDefaults.standard.set(searchHistory, forKey: "SearchHistory")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped")
        let selectedCell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell
        let searchText = selectedCell?.searchLabel.text
            var provider: ProductListDataProvider?
            let marketProvider = MarketProvider(httpClient: HTTPClient.shared)
            provider = ProductsProvider(
                productType: ProductsProvider.ProductType.search,
                dataProvider: marketProvider
            )
            
            let productListVC = ProductListViewController()
            productListVC.provider = provider
            
            productListVC.searchKeywordClosure = { keyword in
                productListVC.keyword = keyword
            }

            productListVC.searchKeywordClosure?(searchText)
        self.navigationController?.pushViewController(productListVC, animated: true)
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchHeaderView = UIView()
        searchHeaderView.backgroundColor = .white
        
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
        if let searchText = searchTextField.text, !searchText.isEmpty {
            var provider: ProductListDataProvider?
            let marketProvider = MarketProvider(httpClient: HTTPClient.shared)
            provider = ProductsProvider(
                productType: ProductsProvider.ProductType.search,
                dataProvider: marketProvider
            )
            
            let productListVC = ProductListViewController()
            productListVC.provider = provider
            
            productListVC.searchKeywordClosure = { keyword in
                productListVC.keyword = keyword
            }

            productListVC.searchKeywordClosure?(searchText)
            
            self.navigationController?.pushViewController(productListVC, animated: true)

            if let index = searchHistory.firstIndex(of: searchText) {
                searchHistory.remove(at: index)
                searchHistory.insert(searchText, at: 0)
            } else {
                searchHistory.insert(searchText, at: 0)
            }
            UserDefaults.standard.set(searchHistory, forKey: "SearchHistory")
            self.searchTableView.reloadData()
            searchTextField.text = ""
            
            print(searchHistory)
            
        } else {
            showAlert(title: "警告", message: "請輸入收尋關鍵字")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
