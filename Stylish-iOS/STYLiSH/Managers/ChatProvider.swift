//
//  ChatManager.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import UIKit

class ChatProvider {
    
    static let shared = ChatProvider()
    
    func userAppendMessages(inputText: String) {
        mockConversationData.append(ChatMessage(sendTime: Date(), isUser: true, content: inputText))
    }
    
    func adminAppendMessages(inputText: String){
        mockConversationData.append(ChatMessage(sendTime: Date(), isUser: false, content: inputText))
    }
    
    // Mock data
    var mockConversationData = [
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -19 * 60), isUser: true, content: "Hi there!"),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -18 * 60), isUser: false, content: "Hey! How are you?"),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -17 * 60), isUser: true, content: "I'm good, thanks! And you?"),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -16 * 60), isUser: false, content: "Doing well. Working on a project."),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -15 * 60), isUser: true, content: "Oh, what kind of project?"),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -4 * 60), isUser: true, content: "Definitely will. How's your family?"),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -3 * 60), isUser: false, content: "Everyone's great, thanks for asking!"),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -2 * 60), isUser: true, content: "Glad to hear that. Let's catch up more soon."),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: -1 * 60), isUser: false, content: "Sure, looking forward to it. Bye for now!"),
        ChatMessage(sendTime: Date(timeIntervalSinceNow: 0), isUser: true, content: "Bye!")
    ]

}
