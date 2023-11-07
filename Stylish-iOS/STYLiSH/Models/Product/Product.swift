//
//  Product.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

struct PromotedProducts: Codable {
    let title: String
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Int
    let texture: String
    let wash: String
    let place: String
    let note: String
    let story: String
    let colors: [Color]
    let sizes: [String]
    let variants: [Variant]
    var mainImage: String
    var images: [String]

    var size: String {
        return (sizes.first ?? "") + " - " + (sizes.last ?? "")
    }

    var stock: Int {
        return variants.reduce(0, { (previousData, upcomingData) -> Int in
            return previousData + upcomingData.stock
        })
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case texture
        case wash
        case place
        case note
        case story
        case colors
        case sizes
        case variants
        case mainImage = "main_image"
        case images
    }
}

struct Color: Codable {
    let name: String
    let code: String
}

struct Variant: Codable {
    let colorCode: String
    let size: String
    let stock: Int

    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size
        case stock
    }
}


struct Welcome: Codable {
    let records: [Record]
}

// MARK: - Record
struct Record: Codable {
    let timestamp: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int
    let category, title, mainImage: String
    let price: Int
    

    enum CodingKeys: String, CodingKey {
        case id, category, title
        case mainImage = "main_image"
        case price
    }
}

// MARK: - Welcome
struct ShopStocksData: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let colorCode, size: String
    let shopStocks: [ShopStock]

    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size, shopStocks
    }
}

// MARK: - ShopStock
struct ShopStock: Codable {
    let id: Int
    let name, lat, lng, address, phone: String
    let openTime, closeTime: String
    let stock: Int

    enum CodingKeys: String, CodingKey {
        case id, name, lat, lng, address, phone
        case openTime = "open_time"
        case closeTime = "close_time"
        case stock
    }
}
