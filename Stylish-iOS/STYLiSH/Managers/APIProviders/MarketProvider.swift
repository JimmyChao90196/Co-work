//
//  MarketProvider.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

typealias PromotionHanlder = (Result<[PromotedProducts], Error>) -> Void
typealias ProductsResponseWithPaging = (Result<STSuccessParser<[Product]>, Error>) -> Void
typealias ProductsResponseWithIdentifier = (Result<STSuccessParser<[Product]>, Error>) -> Void
typealias ProductsResponseWithHistory = (Result<STSuccessParser<[Product]>, Error>) -> Void

class MarketProvider {

    let decoder = JSONDecoder()
    let httpClient: HTTPClientProtocol

    private enum ProductType {
        case men(Int)
        case women(Int)
        case accessories(Int)
        case search(Int)
        case history(Int)
        case detail(Int)
    }
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    // MARK: - Public method
    func fetchHots(completion: @escaping PromotionHanlder) {
        httpClient.request(STMarketRequest.hots, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let products = try self.decoder.decode(
                        STSuccessParser<[PromotedProducts]>.self,
                        from: data
                    )
                    DispatchQueue.main.async {
                        completion(.success(products.data))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func fetchProductForMen(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.men(paging: paging), completion: completion)
    }

    func fetchProductForWomen(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.women(paging: paging), completion: completion)
    }

    func fetchProductForAccessories(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.accessories(paging: paging), completion: completion)
    }
    
    func fetchProductForSearch(keyword: String, paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.search(keywodr: keyword, paging: paging), completion: completion)
    }

    func fetchProductForHistory(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.history(paging: paging), completion: completion)
    }
    
    func fetchProductForDetail(id: Int, completion: @escaping ProductsResponseWithIdentifier) {
        fetchDetails(request: STMarketRequest.details(id: 161), completion: completion)
    }
    
    // MARK: - Private method
    private func fetchProducts(request: STMarketRequest, completion: @escaping ProductsResponseWithPaging) {
        HTTPClient.shared.request(request, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(STSuccessParser<[Product]>.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func fetchDetails(request: STMarketRequest, completion: @escaping ProductsResponseWithIdentifier) {
        HTTPClient.shared.request(request, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(STSuccessParser<[Product]>.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
