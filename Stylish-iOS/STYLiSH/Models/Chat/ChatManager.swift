//
//  ChatHistoryRequest.swift
//  STYLiSH
//
//  Created by JimmyChao on 2023/11/7.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import Foundation
import UIKit

class ChatManager {
    
    static let shared = ChatManager()
    let keyChainManager = KeyChainManager.shared
    
    struct RequestBody: Codable {
        let jwtToken: String
    }
    
    func fetchHistory(userToken: String = KeyChainManager.shared.token ?? "none",
                      _ completion: @escaping (Result<[ChatMessage], Error>) -> Void) {
        guard let url = URL(string: "https://handsomelai.shop/api/user/chat/history")
        
        else { return }
        
        let token = userToken
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = RequestBody(jwtToken: "\(token)")
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(requestBody)
            urlRequest.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            print("before decoding: \(data)")
            
            let decoder = JSONDecoder()
            
            do {
                let chatData = try decoder.decode(ChatData.self, from: data)
                
                print("look at me.... + \(chatData.data)")
                
                completion(.success(chatData.data))
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
