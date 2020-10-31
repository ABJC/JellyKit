//
//  File.swift
//  
//
//  Created by Noah Kamara on 31.10.20.
//

import Foundation

extension API.Models {
    public struct Season: Decodable, Hashable, Identifiable {
        public static func == (lhs: API.Models.Season, rhs: API.Models.Season) -> Bool {
            return lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        public let id: String
        public let serverId: String
        
        public let name: String
        
        public let index: Int
        public let seriesId: String
        public let seriesName: String
        
        public let userData: UserData?
        
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case serverId = "ServerId"
            
            case name = "Name"
            
            case index = "IndexNumber"
            case seriesId = "SeriesId"
            case seriesName = "SeriesName"
            
            case userData = "UserData"
        }
    }
}
