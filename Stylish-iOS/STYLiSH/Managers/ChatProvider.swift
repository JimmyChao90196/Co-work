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
        
        conversationHistory.append(ChatMessage(sendTime: "1699345032.169744", isUser: true, content: inputText))
    }
    
    func adminAppendMessages(inputText: String) {
        conversationHistory.append(ChatMessage(sendTime: "1699345032.169744", isUser: false, content: inputText))
    }
    
    // Mock data
    var conversationHistory: [ChatMessage] = [ ]
}
