//
//  ProductPickerController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/4.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

private enum ProductPickerCellType {
    case color
    case size
    case amount

    var identifier: String {
        switch self {
        case .color: return String(describing: ColorSelectionCell.self)
        case .size: return String(describing: SizeSelectionCell.self)
        case .amount: return String(describing: AmountSelectionCell.self)
        }
    }
}

protocol ProductPickerControllerDelegate: AnyObject {
    func dismissPicker(_ controller: ProductPickerController)
    func valueChange(_ controller: ProductPickerController)
}

class ProductPickerController: UIViewController {

    var shopStockData: ShopStocksData?
    
    var filteredData: [Datum] = []
    
    var count = 0
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    weak var delegate: ProductPickerControllerDelegate?

    private let datas: [ProductPickerCellType] = [.color, .size, .amount]

    var product: Product?

    var productId: Int?
    
    var selectedColor: Color? {
        didSet {
            guard let index = datas.firstIndex(of: .size) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            manipulaterCell(cell, type: .size)
            selectedSize = nil
            delegate?.valueChange(self)
        }
    }

    var selectedSize: String? {
        didSet {
            guard let index = datas.firstIndex(of: .amount) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            manipulaterCell(cell, type: .amount)
            delegate?.valueChange(self)
        }
    }

    var selectedAmount: Int? {
        guard let index = datas.firstIndex(of: .amount) else { return nil }
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? AmountSelectionCell else { return nil }
        return cell.amount
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 50
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
        setupTableView()
        tableView.register(BranchCell.self, forCellReuseIdentifier: BranchCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        print(productId)
        getShopStock(id: productId!)
    }

    private func setupTableView() {
        tableView.register(
            SizeSelectionCell.self,
            forCellReuseIdentifier: ProductPickerCellType.size.identifier
        )

        tableView.register(
            ColorSelectionCell.self,
            forCellReuseIdentifier: ProductPickerCellType.color.identifier
        )

        tableView.lk_registerCellWithNib(
            identifier: String(describing: AmountSelectionCell.self),
            bundle: nil
        )
    }

    // MARK: - Action
    @IBAction func onDismiss(_ sender: UIButton) {
        delegate?.dismissPicker(self)
    }

    // MARK: - Cell Arrangement
    private func manipulaterCell(_ cell: UITableViewCell, type: ProductPickerCellType) {
        switch type {
        case .color:
            updateColorSelectionCell(cell)
        case .size:
            updateSizeSelectionCell(cell)
        case .amount:
            updateAmountSelectionCell(cell)
        }
    }
    
    private func updateColorSelectionCell(_ cell: UITableViewCell) {
        
        guard
            let colorCell = cell as? ColorSelectionCell,
            let product = product
        else {
            return
        }
        colorCell.colors = product.colors.map { $0.code }
        colorCell.touchHandler = { [weak self] indexPath in
            self?.selectedColor = self?.product?.colors[indexPath.row]
        }
    }
    
    private func updateSizeSelectionCell(_ cell: UITableViewCell) {
        guard
            let sizeCell = cell as? SizeSelectionCell,
            let product = product
        else {
            return
        }
        
        sizeCell.touchHandler = { [weak self] size in
            guard self?.selectedColor != nil else { return false }
            self?.selectedSize = size
            return true
        }
        sizeCell.sizes = product.sizes
        
        guard let selectedColor = selectedColor else { return }
        sizeCell.avalibleSizes = product.variants.compactMap { variant in
            if variant.colorCode == selectedColor.code {
                return variant.size
            }
            
            return nil
        }
    }
    
    private func updateAmountSelectionCell(_ cell: UITableViewCell) {
        
        count += 1
        
        guard let amountCell = cell as? AmountSelectionCell else { return }
        guard
            let product = product,
            let selectedColor = selectedColor,
            let selectedSize = selectedSize
        else {
            amountCell.layoutCell(variant: nil)
            return
        }
        let variant = product.variants.filter { item in
            if item.colorCode == selectedColor.code && item.size == selectedSize {
                return true
            }
            return false
        }
        
        amountCell.layoutCell(variant: variant.first)
        
        if count > 4 {
            count = 0
        } else {
            // showShopStock(color: selectedColor, size: selectedSize)
            // tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
    func showShopStock(color: Color, size: String) {
        
        for datum in shopStockData!.data {
            if datum.colorCode == "#\(color.code)" && datum.size == size {
                filteredData = [datum]
            }
        }
        
        print(filteredData[0].shopStocks[0].stock)
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
                    
                    self.shopStockData = response
                    print(self.shopStockData)
                    
                    // 将数据传递给ProductPickerController
                    DispatchQueue.main.async {
                        
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
extension ProductPickerController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData .isEmpty {
            if section == 0 {
                return datas.count
            } else {
                return 0
            }
        } else {
            if section == 0 {
                return datas.count
            } else {
                return 5
            }
        }
        
        // greturn datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: datas[indexPath.row].identifier,
                for: indexPath)
            manipulaterCell(cell, type: datas[indexPath.row])
            
            return cell
        
        } else {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BranchCell.reuseIdentifier,
                for: indexPath) as? BranchCell else { return UITableViewCell() }
            
            if filteredData .isEmpty {
                
            } else {
                let filterProduct = (filteredData.first?.shopStocks[indexPath.row])!
                cell.configure(with: filterProduct)
            }
            // cell.branchNameLabel.text = String(indexPath.row)
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ProductPickerController: UITableViewDelegate {
    
     // Close Button action
     @objc func closeButtonTapped() {
         delegate?.dismissPicker(self)
     }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 108.0
        } else {
            return 108.0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            guard let product = product else { return CartHeaderView() }
            let price = "NT$\(product.price)"
            let headerView = CartHeaderView(title: product.title, price: price)
            headerView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            return headerView
            
        } else {
            
            return BranchHeaderView()
        }
    }
}

// MARK: - Branch header view -
class BranchHeaderView: UIView {
    
    // Section header element
    var titleLabel = UILabel()
    var leftDivider = UIView()
    var rightDivider = UIView()
    var contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTo()
        setupHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addTo() {
        self.addSubviews([titleLabel, leftDivider, rightDivider, contentLabel])
    }
    
    // Setup cart view
    func setupHeaderView() {
        self.backgroundColor = .white
        
        titleLabel.customSetup("實體商店庫存", "PingFangTC-Medium", 18, 0.1, hexColor: "#8B572A")
            .centerXConstr(to: self.centerXAnchor)
            .topConstr(to: self.topAnchor, 10)
            
        leftDivider.setbackgroundColor(.hexToUIColor(hex: "#CCCCCC"))
            .centerYConstr(to: titleLabel.centerYAnchor)
            .leadingConstr(to: self.leadingAnchor, 10)
            .trailingConstr(to: titleLabel.leadingAnchor, -10)
            .heightConstr(1)
        
        rightDivider.setbackgroundColor(.hexToUIColor(hex: "#CCCCCC"))
            .centerYConstr(to: titleLabel.centerYAnchor)
            .leadingConstr(to: titleLabel.trailingAnchor, 10)
            .trailingConstr(to: self.trailingAnchor, -10)
            .heightConstr(1)
        
        contentLabel.customSetup("僅會顯示各店鋪，特定商品指定的顏色與尺寸數量。若有不確定的細節，請與客服確認。",
                                 "PingFangTC-Regular", 16, 0.05, hexColor: "#3F3A3A")
        .leadingConstr(to: self.leadingAnchor, 15)
        .trailingConstr(to: self.trailingAnchor, -15)
        .topConstr(to: titleLabel.bottomAnchor, 5)
        .bottomConstr(to: self.bottomAnchor, -10)
        .numberOfLines = 0
        
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
}
