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
}

class SocketIOManager {
    
    var manager: SocketManager
    var socket: SocketIOClient
    var recievedTalkEvent: ((String) -> Void)?
    var recievedCheckEvent: ((String) -> Void)?
    var recievedConnectionResult: ((Result<String, SocketConnectionError>) -> Void)?
    var recievedTalkResult: ((Result<String, SocketConnectionError>) -> Void)?
    
    init() {
        self.manager = SocketManager(
            socketURL: URL(string: "https://deercodeweb.com/")!,
            config: [.log(true), .compress])
        self.socket = manager.defaultSocket
        
        setup()
    }
    
    func setup() {
        socket.connect()
    }
    
    // Send messages
    func sendMessage(_ identifier: String, message: String, token: String) async {
        socket.emit("talk", "\(message)", ["\(identifier)", "\(token)"])
    }
    
    // Check user
    func userCheck() async {
        socket.emit("user-check", ["user", "JWT"])
    }
    
    // Check admin
    func adminCheck() async {
        socket.emit("user-check", ["admin", "JWT"])
    }
    
    // Listen for any events
    func listenForAnyEvent() async {
        socket.onAny { event in
            print("Received event: \(event.event), with data: \(String(describing: event.items))")
        }
    }
    
    // Admin kick out user, or user leave the room.
    func kickout() {
        socket.emit("user-close", ["admin", "JWT"])
    }
    
    // User leave
    func userLeave() {
        socket.emit("user-close", ["admin", "JWT"])
    }
    
    // Listen for specific events
    func setupListener() async {
        // listen to talk
        socket.on("talk") { data, _ in
            
            print(data)
            
            guard let data = data.first as? String else {
                print("Received user-check event: not an array"); return }
            print("Received talk event: \(data)")
            
            if data == "Connect"{
                
                self.recievedTalkResult?(.success(data))

            } else {
                
                switch data {
                    
                case "All admin is offline.":
                    self.recievedConnectionResult?(.failure(.adminOffLine))
                    
                case "All admin is busy.":
                    self.recievedConnectionResult?(.failure(.adminBusy))
                    
                case "Already one admin in room.":
                    self.recievedConnectionResult?(.failure(.adminInRoom))
                    
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
        
        // listen to user-check
        socket.on("user-check") { data, _ in
            
            guard let dataArray = data[0] as? [String] else {
                print("Received user-check event: not an array"); return }
            print("Received user-check event: \(dataArray)")
            
            if dataArray[0] == "Connect"{
                
                self.recievedConnectionResult?(.success(dataArray[0]))
            } else {
                
                switch dataArray[1] {
                    
                case "All admin is offline.":
                    self.recievedConnectionResult?(.failure(.adminOffLine))
                    
                case "All admin is busy.":
                    self.recievedConnectionResult?(.failure(.adminBusy))
                    
                case "Already one admin in room.":
                    self.recievedConnectionResult?(.failure(.adminInRoom))
                    
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
        
    }
}
