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
        public var deviceID: String
        public var token: String
        
        public init(id: String, name: String, serverID: String, deviceID: String, token: String) {
            self.id = id
            self.name = name
            self.serverID = serverID
            self.deviceID = deviceID
            self.token = token
        }
    }
}
