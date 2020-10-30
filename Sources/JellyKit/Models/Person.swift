//
//  File.swift
//  
//
//  Created by Noah Kamara on 24.10.20.
//

import Foundation

extension API.Models {
    public struct Person: Decodable {
        public var id: String
        public var name: String
        public var role: String?
        public var type: String
        public var image: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
            case role = "Role"
            case type = "Type"
            case image = "PrimaryImageTag"
        }
    }
}
