//
//  File.swift
//  
//
//  Created by Noah Kamara on 28.10.20.
//

import Foundation

extension API {
    public struct AuthUser {
        public var id: String
        public var name: String
        public var serverID: String
        public var token: String
        
        public init(id: String, name: String, serverID: String, token: String) {
            self.id = id
            self.name = name
            self.serverID = serverID
            self.token = token
        }
    }
}
