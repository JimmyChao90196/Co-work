//
//  STRequest.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

enum STMarketRequest: STRequest {
    case hots
    case women(paging: Int)
    case men(paging: Int)
    case accessories(paging: Int)
    case search(keywodr: String, paging: Int)
    case history(paging: Int)
    case details(id: Int)

    var headers: [String: String] {
        switch self {
        case .hots, .women, .men, .accessories, .search, .history, .details: return [:]
        }
    }

    var body: Data? {
        switch self {
        case .hots, .women, .men, .accessories, .search, .history, .details: return nil
        }
    }

    var method: String {
        switch self {
        case .hots, .women, .men, .accessories, .search, .history, .details: return STHTTPMethod.GET.rawValue
        }
    }

    var endPoint: String {
        switch self {
        case .hots: return "/marketing/hots"
        case .women(let paging): return "/products/women?paging=\(paging)"
        case .men(let paging): return "/products/men?paging=\(paging)"
        case .accessories(let paging): return "/products/accessories?paging=\(paging)"
        case .search(let keyword, let paging): return "/products/search?keyword=\(keyword)&paging=\(paging)"
        case .history: return "/user/browsingHistory"
        case .details(let id): return "/products/details?id=\(id)"
        }
    }
}
