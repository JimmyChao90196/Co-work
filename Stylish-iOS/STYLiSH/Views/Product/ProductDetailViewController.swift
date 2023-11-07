//
//  ProductDetailViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/2.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation
import UIKit

protocol DetailProductDataProvider {
    func fetchData(keyword: String?, paging: Int, id: Int?, completion: @escaping ProductsResponseWithIdentifier)
}

class ProductDetailViewController: STBaseViewController {
    
    var provider: DetailProductDataProvider?
    
    var selectProductId: Int?
    
    private var paging: Int?
    var keyword: String?
    
    private struct Segue {
        static let picker = "SeguePicker"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var galleryView: LKGalleryView! {
        didSet {
            galleryView.frame.size.height = CGFloat(Int(UIScreen.width / 375.0 * 500.0))
            galleryView.delegate = self
        }
    }
    
    @IBOutlet weak var productPickerView: UIView!
    
    @IBOutlet weak var addToCarBtn: UIButton!
    
    @IBOutlet weak var baseView: UIView!
    
    private lazy var blurView: UIView = {
        let blurView = UIView(frame: tableView.frame)
        blurView.backgroundColor = .black.withAlphaComponent(0.4)
        return blurView
    }()
    
    private let datas: [ProductContentCategory] = [
        .description, .color, .size, .stock, .texture, .washing, .placeOfProduction, .remarks
    ]
    
    var product: Product? {
        didSet {
            guard let product = product, let galleryView = galleryView else { return }
            galleryView.datas = product.images
            
        }
        
    }
    
    private var pickerViewController: ProductPickerController?
    
    override var isHideNavigationBar: Bool { return true }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDetailData(id: selectProductId!)
        
        print(selectProductId!)
        getShopStock(id: selectProductId!)
        
        //        provider?.fetchData(keyword: nil, paging: 0, id: 123, completion: { result in
        //            switch result {
        //            case .success(let data):
        //                print(data.data)
        //            case .failure(let error):
        //                print(error)
        //            }
        //        })
        
        setupTableView()
        
        guard var product = product else { return }
        
        product.images = product.images.map { "https://handsomelai.shop" + $0 }
        galleryView.datas = product.images
        
    }
    
    private func setupTableView() {
        tableView.lk_registerCellWithNib(
            identifier: String(describing: ProductDescriptionTableViewCell.self),
            bundle: nil
        )
        tableView.lk_registerCellWithNib(
            identifier: ProductDetailCell.color,
            bundle: nil
        )
        tableView.lk_registerCellWithNib(
            identifier: ProductDetailCell.label,
            bundle: nil
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.picker,
           let pickerVC = segue.destination as? ProductPickerController {
            pickerVC.delegate = self
            pickerVC.product = product
            pickerViewController = pickerVC
        }
    }
    
    // MARK: - Action
    @IBAction func didTouchAddToCarBtn(_ sender: UIButton) {
        if productPickerView.superview == nil {
            showProductPickerView()
        } else {
            guard
                let color = pickerViewController?.selectedColor,
                let size = pickerViewController?.selectedSize,
                let amount = pickerViewController?.selectedAmount,
                let product = product
            else {
                return
            }
            StorageManager.shared.saveOrder(
                color: color, size: size, amount: amount, product: product,
                completion: { result in
                    switch result {
                    case .success:
                        LKProgressHUD.showSuccess()
                        dismissPicker(pickerViewController!)
                    case .failure:
                        LKProgressHUD.showFailure(text: "儲存失敗！")
                    }
                }
            )
        }
    }
    
    func showProductPickerView() {
        let maxY = tableView.frame.maxY
        productPickerView.frame = CGRect(
            x: 0, y: maxY, width: UIScreen.width, height: 0.0
        )
        baseView.insertSubview(productPickerView, belowSubview: addToCarBtn.superview!)
        baseView.insertSubview(blurView, belowSubview: productPickerView)
        
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                guard let self = self else { return }
                let height = 451.0 / 586.0 * self.tableView.frame.height
                self.productPickerView.frame = CGRect(
                    x: 0, y: maxY - height, width: UIScreen.width, height: height
                )
                self.isEnableAddToCarBtn(false)
            }
        )
    }
    
    func isEnableAddToCarBtn(_ flag: Bool) {
        if flag {
            addToCarBtn.isEnabled = true
            addToCarBtn.backgroundColor = .B1
        } else {
            addToCarBtn.isEnabled = false
            addToCarBtn.backgroundColor = .B4
        }
    }
    
    func getDetailData(id: Int) {
        let apiURL = URL(string: "https://handsomelai.shop/api/products/details?id=\(id)")
        
        // 創建一個URLSession配置
        
        let token = KeyChainManager.shared.token
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": token ?? nil]
        
        // 創建一個URLSession並套用上述配置
        let session = URLSession(configuration: config)
        
        // 創建一個 URLSession 任務
        let task = session.dataTask(with: apiURL!) { (data, response, error) in
            if error != nil {
                // 處理錯誤
                print("發生錯誤：\(error!)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Product.self, from: data)
                    
                    self.product = response
                    
                    DispatchQueue.main.async {
                        // Reload the tableView on the main thread
                        self.tableView.reloadData()
                    }
                } catch {
                    // 處理 JSON 解析錯誤
                    print("JSON 解析錯誤：\(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func getShopStock(id: Int) {
        let apiURL = URL(string: "https://handsomelai.shop/api/products/shops?id=\(id)")
        
        // 創建一個URLSession配置
        
        let token = KeyChainManager.shared.token
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": token]
        
        // 創建一個URLSession並套用上述配置
        let session = URLSession(configuration: config)
        
        // 創建一個 URLSession 任務
        let task = session.dataTask(with: apiURL!) { (data, response, error) in
            if error != nil {
                // 處理錯誤
                print("發生錯誤：\(error!)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ShopStocksData.self, from: data)
                    
                    print(response)
                    
                    // 将数据传递给ProductPickerController
                    
                    
                    DispatchQueue.main.async {
                        // Reload the tableView on the main thread
                        ProductPickerController().shopStockData = response
                        self.tableView.reloadData()
                    }
                } catch {
                    // 處理 JSON 解析錯誤
                    print("JSON 解析錯誤：\(error)")
                }
            }
        }
        
        task.resume()
    }
}

// MARK: - UITableViewDataSource
extension ProductDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard product != nil else { return 0 }
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let product = product else { return UITableViewCell() }
        return datas[indexPath.row].cellForIndexPath(indexPath, tableView: tableView, data: product)
    }
}

extension ProductDetailViewController: LKGalleryViewDelegate {

    func sizeForItem(_ galleryView: LKGalleryView) -> CGSize {
        return CGSize(width: Int(UIScreen.width), height: Int(UIScreen.width / 375.0 * 500.0))
    }
}

extension ProductDetailViewController: ProductPickerControllerDelegate {

    func dismissPicker(_ controller: ProductPickerController) {
        let origin = productPickerView.frame
        let nextFrame = CGRect(x: origin.minX, y: origin.maxY, width: origin.width, height: origin.height)

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.productPickerView.frame = nextFrame
                self?.blurView.removeFromSuperview()
                self?.isEnableAddToCarBtn(true)
            },
            completion: { [weak self] _ in
                self?.productPickerView.removeFromSuperview()
            }
        )
    }

    func valueChange(_ controller: ProductPickerController) {
        guard
            controller.selectedColor != nil,
            controller.selectedSize != nil,
            controller.selectedAmount != nil
        else {
            isEnableAddToCarBtn(false)
            return
        }
        isEnableAddToCarBtn(true)
    }
}
