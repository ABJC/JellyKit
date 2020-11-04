//
//  File.swift
//  
//
//  Created by Noah Kamara on 24.10.20.
//

import Foundation

extension API.Models {
    public struct Movie: Decodable, Playable {
        public let id: String
        public let serverId: String?
        public let type: MediaType
        
        public let name: String
        public let originalTitle: String?
        public let sortName: String?
        public let overview: String?
        public let year: Int?
        
        public let canDownload: Bool?
        public let hasSubtitles : Bool?
        
        public let people: [Person]?
        public let genres: [Genre]?
        
        public let criticRating: Int?
        private let communityRating: Double
        
        public let userData: UserData
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case originalTitle = "OriginalTitle"
            case id = "Id"
            case serverId = "ServerId"
            case type = "Type"
            case canDownload = "CanDownload"
            case hasSubtitles = "HasSubtitles"
            case sortName = "SortName"
            case overview = "Overview"
            case year = "ProductionYear"
            case people = "People"
            case genres = "GenreItems"
            
            case criticRating = "CriticRating"
            case communityRating = "CommunityRating"
            
            case userData = "UserData"
        }
    }
}
