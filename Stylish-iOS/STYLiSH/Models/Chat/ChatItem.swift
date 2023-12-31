//
//  ChatItem.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

// Define a struct to represent the message.
struct ChatMessage: Codable {
    let sendTime: String
    let isUser: Bool
    let content: String
}

// Define a struct to represent the data model that holds an array of messages.
struct ChatData: Codable {
    let data: [ChatMessage]
}

// struct Message: Codable {
//    let content: String
//    let isUser: Bool
//    let sendTime: Date
//    
//    enum CodingKeys: String, CodingKey {
//        case content
//        case isUser
//        case sendTime
//    }
// }

// Define the structure of chat history request body
struct ChatHistoryBody: Codable {
    var jwtToken: String
}
