//
//  ProductsListProvider.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/2.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

class ProductsProvider: ProductListDataProvider, HistoryProductListDataProvider {
    
    enum ProductType {
        case men
        case women
        case accessories
        case search
        case history
    }

    private let productType: ProductType

    private let dataProvider: MarketProvider

    init(productType: ProductType, dataProvider: MarketProvider) {
        self.productType = productType
        self.dataProvider = dataProvider
    }

    func fetchData(keyword: String?, paging: Int, completion: @escaping ProductsResponseWithPaging) {
        switch productType {
        case .women: dataProvider.fetchProductForWomen(paging: paging, completion: completion)
        case .men: dataProvider.fetchProductForMen(paging: paging, completion: completion)
        case .accessories: dataProvider.fetchProductForAccessories(paging: paging, completion: completion)
        case .search: dataProvider.fetchProductForSearch(keyword: keyword!, paging: paging, completion: completion)
        case .history: dataProvider.fetchProductForHistory(paging: paging, completion: completion)
        }
    }
}
