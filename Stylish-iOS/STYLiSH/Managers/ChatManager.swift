//
//  ChatManager.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import UIKit

class ChatManager {
    
    static let shared = ChatManager()
    
    var adminMessage = ChatMessage(sender: .admin, messages: [
        "Hi there!",
        "How's it going?",
        "What are you up to?",
        "Have you seen the latest movie?",
        "I can't believe how fast time flies.",
        "Do you want to grab a coffee sometime?",
        "Did you complete the assignment?",
        "What's your favorite type of music?",
        "Are you going to the game tonight?",
        "Can you recommend a good book?"
    ])
    
    var senderMessage = ChatMessage(sender: .user, messages: [
        "Hello! Nice to see you.",
        "I'm doing well, thanks! And you?",
        "Just working on some coding projects.",
        "Not yet, but I'm planning to watch it soon.",
        "I know, right? It's already the weekend!",
        "Sure, that sounds great!",
        "Yes, I finished it last night.",
        "I'm really into jazz lately.",
        "No, I'll be watching it at home. You?",
        "Definitely! 'Sapiens' by Yuval Noah Harari is a good read."
    ])
}
