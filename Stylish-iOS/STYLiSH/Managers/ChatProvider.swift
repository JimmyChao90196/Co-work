//
//  ChatManager.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

class ChatProvider {
    
    static let shared = ChatProvider()
    
    static let userColor: UIColor = .hexToUIColor(hex: "#3F3A3A")
    static let adminColor: UIColor = .hexToUIColor(hex: "CCCCCC")
    
    func userAppendMessages(inputText: String) {
        conversationHistory.append(ChatMessage(sendTime: Date(), isUser: true, content: inputText))
    }
    
    func adminAppendMessages(inputText: String) {
        conversationHistory.append(ChatMessage(sendTime: Date(), isUser: false, content: inputText))
    }
    
    // Mock data
    var conversationHistory = [
        ChatMessage(
            sendTime: Date(timeIntervalSinceNow: -19 * 60),
            isUser: true, content: "Hi there!"),
        ChatMessage(
            sendTime: Date(timeIntervalSinceNow: -18 * 60),
            isUser: false, content: "Hey! How are you?"),
        ChatMessage(
            sendTime: Date(timeIntervalSinceNow: -18 * 60),
            isUser: true, content: "Fine"),
        ChatMessage(
            sendTime: Date(timeIntervalSinceNow: -18 * 60),
            isUser: false, content: "Get lost then!!")
    ]
}
