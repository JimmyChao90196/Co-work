//
//  HistoryViewController.swift
//  STYLiSH
//
//  Created by Ray Chang on 2023/11/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryProductListDataProvider {
    func fetchData(keyword: String?, paging: Int, id: Int?, completion: @escaping ProductsResponseWithPaging)
}

class HistoryViewController: STCompondViewController {
    
    var provider: HistoryProductListDataProvider?
    
    private let userProvider = UserProvider()
    
    private var user: User? {
        didSet {
            if let user = user {
            }
        }
    }
    
    var historyProducts: [Record] = []
    
    private var paging: Int? = 0
    var keyword: String?
    var id: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchHistoryProducts()

        navigationItem.title = "History"
        navigationController?.navigationBar.backgroundColor = .white
        
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHistoryProducts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    private func fetchData() {
        userProvider.getUserProfile(completion: { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
    
    // MARK: - Private method
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.lk_registerCellWithNib(
            identifier: String(describing: ProductCollectionViewCell.self),
            bundle: nil
        )
        setupCollectionViewLayout()
        
        collectionView.dataSource = self
    }
    
    private func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: Int(164.0 / 375.0 * UIScreen.width),
            height: Int(164.0 / 375.0 * UIScreen.width * 308.0 / 164.0)
        )
        flowLayout.sectionInset = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 24.0
        collectionView.collectionViewLayout = flowLayout
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyProducts.count // 使用数组的计数
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
        )
        
        let product = historyProducts[indexPath.row] // Get the product at the current index
        
        if let productCell = cell as? ProductCollectionViewCell {
            productCell.layoutCell(
                image: "https://handsomelai.shop\(product.data.mainImage)",
                title: product.data.title,
                price: product.data.price
            )
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        
//        let product = historyProducts[indexPath.row] // 获取选定单元格的产品对象
//        let productDetailVC = UIStoryboard.product.instantiateViewController(withIdentifier:
//            String(describing: ProductDetailViewController.self)
//        )
//        guard let detailVC = productDetailVC as? ProductDetailViewController else { return }
//        detailVC.selectProductId = product.data.id
//        show(detailVC, sender: nil)
//    }
    
    func fetchHistoryProducts() {
        let apiURL = URL(string: "https://handsomelai.shop/api/user/browsingHistory")
        
        let token = KeyChainManager.shared.token

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": token!]
        print("fetchHistory: \(String(describing: token))")
        // Create a URLSession with the specified configuration
        let session = URLSession(configuration: config)
        
        // Create a URLSession task
        let task = session.dataTask(with: apiURL!) { [weak self] (data, response, error) in
            if error != nil {
                // Handle the error
                print("Error occurred: \(error!)")
            } else if let data = data {
                print(data)
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Welcome.self, from: data)
                    
                    // Here, you handle the parsed data
                    self?.historyProducts = response.records // Get Product array
                    
                    print("Received data: \(String(describing: self?.historyProducts))")
                    
                    DispatchQueue.main.async {
                        // Reload the tableView on the main thread
                        self?.collectionView.reloadData()
                    }
                    
                } catch {
                    // Handle JSON parsing error
                    print("JSON parsing error: \(error)")
                }
            }
        }
        
        task.resume()
    }
}
