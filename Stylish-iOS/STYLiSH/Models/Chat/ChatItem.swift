//
//  ChatItem.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation

enum SenderType {
    case user, admin
}

struct ChatMessage {
    let sender: SenderType
    let messages: [String]
}
