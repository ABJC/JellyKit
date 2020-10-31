//
//  SwiftUIView.swift
//  
//
//  Created by Noah Kamara on 31.10.20.
//

import Foundation

extension API.Models {
    public struct Series: Decodable {
        public let id: String
        public let serverId: String?
        
        public let name: String
        public let sortName: String?
        public let overview: String?
        public let year: Int?
        
        public let canDownload: Bool?
        public let hasSubtitles : Bool?
        
        public let people: [Person]?
        public let genres: [Genre]?
        
        private let communityRating: Double
        
        public let userData: UserData?
        
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case serverId = "ServerId"
            
            case name = "Name"
            case sortName = "SortName"
            case overview = "Overview"
            case year = "ProductionYear"
            
            case canDownload = "CanDownload"
            case hasSubtitles = "HasSubtitles"
            
            
            case people = "People"
            case genres = "GenreItems"
            
            case communityRating = "CommunityRating"
            
            case userData = "UserData"
        }
    }
}
