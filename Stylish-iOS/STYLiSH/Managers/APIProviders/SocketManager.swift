//
//  ChatProvider.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/4.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import SocketIO

enum SocketConnectionError: String, Error {
    case adminOffLine = "All admin is offline"
    case adminBusy = "All admin is busy"
    case adminInRoom = "Already one admin in room"
    case roomDoesntExist = "Please connect before talking"
    case roomOnlyLeftUser = "Admin left the room"
    case userLeaveTheRoom = "User is removed from room"
    case alreadyConnected = "You are already connected"
}

class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    var recievedTalkEvent: ((String) -> Void)?
    var recievedCheckEvent: ((String) -> Void)?
    var recievedConnectionResult: ((Result<String, SocketConnectionError>) -> Void)?
    var recievedTalkResult: ((Result<String, SocketConnectionError>) -> Void)?
    var recievedCloseResult: ((Result<String, SocketConnectionError>) -> Void)?
        
    func setup() {
        self.manager = SocketManager(
            socketURL: URL(string: "https://deercodeweb.com/")!,
            config: [.log(true)])
        self.socket = manager.defaultSocket
        
        socket.connect()
        print("print socket id when setup: \(String(describing: socket.sid))")
    }
    
    // Send messages
    func sendMessage(_ identifier: String, message: String, token: String) async {
        socket.emit("talk", "\(message)", ["\(identifier)", "\(token)"])
    }
    
    // Check user
    func userCheck(token: String) {
        print("print socke id before user-check: \(String(describing: socket.sid))")
        socket.emit("user-check", ["user", "\(token)"])
    }
    
    // Check admin
    func adminCheck(token: String) {
        print("print socke id before user-check: \(String(describing: socket.sid))")
        socket.emit("user-check", ["admin", "\(token)"])
    }
    
    // Listen for any events
    func listenForAnyEvent() {
        socket.onAny { event in
            print("Received event: \(event.event), with data: \(String(describing: event.items))")
        }
    }
    
    // Admin kick out user, or user leave the room.
    func kickout(token: String) {
        socket.emit("user-close", ["admin", "\(token)"])
    }
    
    // User leave
    func userLeave(token: String) {
        socket.emit("user-close", ["admin", "\(token)"])
    }
    
    // Listen for connected
    func listenForConnected(completion: @escaping ((String) -> Void)) {
        
        socket.on(clientEvent: .connect) { _, _ in
            guard let id = self.socket.sid else { print("id found nil"); return }
            
            completion(id)
        }
    }
    
    // Listen for disconnected
    func listenForDisconnected(completion: @escaping ((String) -> Void)) {
        
        socket.on(clientEvent: .disconnect) { _, _ in
            guard let id = self.socket.sid else { print("id found nil"); return }
            print("Socket disconnected and id is: \(id)")
            
            completion(id)
        }
    }
    
    // Listen for specific events
    func setupListener() {
        // listen to user-close
        socket.on("user-close") { data, _ in
            
            guard let dataArray = data[0] as? [String] else {
                print("Received user-close event: not an array"); return }
            print("Received user-close event: \(dataArray)")
            
            if dataArray[0] == "Connect"{
                
                self.recievedCloseResult?(.success(dataArray[0]))
                
            } else {
                
                self.errorHandeling(switchTaret: dataArray[0])
            }
        }
        
        // listen to talk
        socket.on("talk") { data, _ in
            
            print("look at me: \(data)")
            
            guard let data = data.first as? String else {
                print("Received user-check event: not an array"); return }
            print("Received talk event: \(data)")
            
            self.recievedTalkResult?(.success(data))
        
        }
        
        // listen to user-check
        socket.on("user-check") { data, _ in
            
            guard let dataArray = data[0] as? [String] else {
                print("Received user-check event: not an array"); return }
            print("Received user-check event: \(dataArray)")
            
            if dataArray[0] == "Connect"{
                
                self.recievedConnectionResult?(.success(dataArray[0]))
                
            } else {
                
                self.errorHandeling(switchTaret: dataArray[0])
            }
        }
    }
    
    func errorHandeling(switchTaret: String) {
        switch switchTaret {
            
        case "All admin is offline.":
            self.recievedConnectionResult?(.failure(.adminOffLine))
            
        case "All admin is busy.":
            self.recievedConnectionResult?(.failure(.adminBusy))
            
        case "Already one admin in room.":
            self.recievedConnectionResult?(.failure(.adminInRoom))
            
        case "You are already connected.":
            self.recievedConnectionResult?(.failure(.alreadyConnected))
            
        case "Please connect before talking.":
            self.recievedConnectionResult?(.failure(.roomDoesntExist))
            
        case "Admin left the room.":
            self.recievedConnectionResult?(.failure(.roomOnlyLeftUser))
            
        case "User is removed from room.":
            self.recievedConnectionResult?(.failure(.userLeaveTheRoom))
            
        default: print("unhandled error"); return
        }
    }
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
