//
//  File.swift
//  
//
//  Created by Noah Kamara on 24.10.20.
//

import Foundation

extension API.Models {
    public struct Genre: Decodable, Hashable {
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        public var id: String
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
        }
    }
}
