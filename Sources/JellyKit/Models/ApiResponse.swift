//
//  File.swift
//  
//
//  Created by Noah Kamara on 24.10.20.
//

import Foundation

extension API.Responses {
    public struct ApiResponse<T: Decodable>: Decodable {
        let success: Bool
        // var error: ApiError?
        let data: T
    }
}

extension API.Responses {
    public struct ItemResponse<T: Decodable>: Decodable {
        let items: T
        
        enum CodingKeys: String, CodingKey {
            case items = "Items"
        }
    }
}

extension API.Responses {
    public struct AuthResponse: Decodable {
        public let user: API.Models.User
    //    let sessionInfo: API.Models.SessionInfo
        public let token: String
        public let serverId: String
        
        enum CodingKeys: String, CodingKey {
            case user = "User"
            case token = "AccessToken"
            case serverId = "ServerId"
        }
    }
}
