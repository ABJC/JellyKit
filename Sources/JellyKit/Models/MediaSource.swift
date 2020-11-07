//
//  MediaSource.swift
//  
//
//  Created by Noah Kamara on 05.11.20.
//

import Foundation

extension API.Models {
    public struct MediaSource: Codable {
        public var id: String
        public var type: String
        public var container: String
        
        public var canPlay: Bool {
            return container == "mp4"
        }
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case type = "Type"
            case container = "Container"
        }
    }
}
