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
    }
}

// MARK: - UITableViewDataSource
extension ProductPickerController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return datas.count
        } else {
            return 10
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
                for: indexPath) as? BranchCell
            else { return UITableViewCell() }
            
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
            return 0
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
            
            return UIView()
        }
    }
}

// MARK: - HeaderView -
class CartHeaderView: UIView {

// Section header element
var titleLabel = UILabel()
var priceLabel = UILabel()
var divider = UIView()
var closeButton = UIButton()

convenience init(title: String, price: String) {
    self.init(frame: .zero)
    titleLabel.text = title
    priceLabel.text = price
}

override init(frame: CGRect) {
    super.init(frame: frame)
    addTo()
    setupHeaderView()
    setupButton()
}

required init?(coder: NSCoder) {
    super.init(coder: coder)
}

func addTo() {
    self.addSubview(titleLabel)
    self.addSubview(priceLabel)
    self.addSubview(divider)
    self.addSubview(closeButton)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    divider.translatesAutoresizingMaskIntoConstraints = false
    closeButton.translatesAutoresizingMaskIntoConstraints = false
}

// Setup buttons
func setupButton() {
    closeButton.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
    //closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        closeButton.heightAnchor.constraint(equalToConstant: 24),
        closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor, multiplier: 1)
    ])
}

// Setup cart view
func setupHeaderView() {
    divider.backgroundColor = .hexStringToUIColor(hex: "#CCCCCC")
    self.backgroundColor = .white
    
    titleLabel.customSetup("厚實毛呢格子外套", "PingFangTC-Regular", 18, 0.15, hexColor: "#3F3A3A")
    priceLabel.customSetup("NT$2140", "PingFangTC-Regular", 18, 0.15, hexColor: "#3F3A3A")
    
    NSLayoutConstraint.activate([
        
        self.topAnchor.constraint(equalTo: topAnchor, constant: 0),
        self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
        
        priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        
        divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        divider.heightAnchor.constraint(equalToConstant: 1),
        divider.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16)
    ])
}
}
