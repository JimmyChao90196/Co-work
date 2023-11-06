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
    func fetchData(keyword: String?, paging: Int, completion: @escaping ProductsResponseWithPaging)
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
    
    private var paging: Int? = 0
    var keyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        navigationItem.title = "History"
        navigationController?.navigationBar.backgroundColor = .white
        
        let marketProvider = MarketProvider(httpClient: HTTPClient.shared)
        provider = ProductsProvider(
            productType: ProductsProvider.ProductType.history,
            dataProvider: marketProvider
        )
        let productListVC = HistoryViewController()
        productListVC.provider = provider
    
        setupCollectionView()
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

    // MARK: - Override super class method
    override func headerLoader() {
        paging = nil
        datas = []
        resetNoMoreData()

        provider?.fetchData(keyword: keyword, paging: 0, completion: { [weak self] result in
            self?.endHeaderRefreshing()
            switch result {
            case .success(let response):
                self?.datas = [response.data]
                self?.paging = response.paging
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        })
    }

    override func footerLoader() {
        guard let paging = paging else {
            endWithNoMoreData()
            return
        }
        provider?.fetchData(keyword: keyword, paging: paging, completion: { [weak self] result in
            self?.endFooterRefreshing()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let originalData = self.datas.first else { return }
                let newDatas = response.data
                self.datas = [originalData + newDatas]
                self.paging = response.paging
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        })
    }

    private func showProductDetailViewController(product: Product) {
        let productDetailVC = UIStoryboard.product.instantiateViewController(withIdentifier:
            String(describing: ProductDetailViewController.self)
        )
        guard let detailVC = productDetailVC as? ProductDetailViewController else { return }
        detailVC.product = product
        show(detailVC, sender: nil)
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
        )
        guard
            let productCell = cell as? ProductCollectionViewCell,
            let product = datas[indexPath.section][indexPath.row] as? Product
        else {
            return cell
        }
        productCell.layoutCell(
            image: product.mainImage,
            title: product.title,
            price: product.price
        )
        return productCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let product = datas[indexPath.section][indexPath.row] as? Product else { return }
        showProductDetailViewController(product: product)
    }
}
