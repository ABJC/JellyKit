//
//  File.swift
//  
//
//  Created by Noah Kamara on 30.10.20.
//

import Foundation
extension API.Models {
    public struct Episode: Decodable, Playable {
        public let id: String
        public let name: String
        public let type: MediaType
        
        public let seasonName: String
        public let seasonId: String
        public let index: Int?
        public let parentIndex: Int
        
        public let overview: String?
                
        public let genres: [Genre]?
        private var imageBlurHashes: [String: [String: String]]?
        
        public func blurHash(for imageType: ImageType) -> String? {
            guard let hashes = imageBlurHashes else { return nil }
            return hashes[imageType.rawValue]?.values.first
        }
        
        private let communityRatingRaw: Double?
        public var communityRating: Int? {
            if let raw = communityRatingRaw {
                return Int(round(raw*10))
            } else {
                return nil
            }
        }
        
        public let userData: UserData
        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case id = "Id"
            case type = "Type"
            case seasonName = "SeasonName"
            case seasonId = "SeasonId"
            case index = "IndexNumber"
            case parentIndex = "ParentIndexNumber"
            
            case imageBlurHashes = "ImageBlurHashes"
            case overview = "Overview"
            case genres = "GenreItems"
            case communityRatingRaw = "CommunityRating"
            case userData = "UserData"
            
            
        }
    }
}
