//
//  ChatProvider.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager {
    static let shared = SocketIOManager()
    
    var manager: SocketManager
    var socket: SocketIOClient

    init() {
        self.manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress, .connectParams(["token": "ABCDEF"])])
        self.socket = manager.defaultSocket
    }
    
    
    /*
    // Connect
    socketIOManager.socket.connect()
    
    // Listen for connect
    socketIOManager.socket.on(clientEvent: .connect){ data, ack in
        print("socket connected")
    }
    
    // Listen for event
    socketIOManager.socket.on("myCustom event"){dataArray, ack in
        let data = dataArray[0] as! [String: Any]
        print("Received data: \(data)")
    }
    
    // Send event
    socketIOManager.socket.emit("myCustomEvent", ["key": "value"])
    
    // Disconnect
    socketIOManager.socket.disconnect()
    
    // Send event to server and wait for acknoledgement
    SocketIOManager.shared.socket.emitWithAck("myEventWithAck", ["data"]).timingOut(after: 0) { data in
        print("Acknowledgment received with data: \(data)")
    }
    
    // Listen for all events
    SocketIOManager.shared.socket.onAny { event in
        print("Received event: \(event.event), with data: \(event.items)")
    }
    */
    
    
    
}
