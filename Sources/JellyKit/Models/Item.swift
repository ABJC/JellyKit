//
//  File.swift
//  
//
//  Created by Noah Kamara on 24.10.20.
//

import Foundation

extension API.Models {
    public struct Item: Decodable, Identifiable, Equatable {
        public static func == (lhs: API.Models.Item, rhs: API.Models.Item) -> Bool {
            return lhs.id == rhs.id
        }
        
        
        public var id: String
        public var name: String
        public let overview: String?
        public let year: Int?
        public var genres: [Genre] = []
        public var type: MediaType
        public var people: [Person]?
        private var runTimeTicks: Int?
        private var imageBlurHashes: [String: [String: String]]?
        
        public func blurHash(for imageType: ImageType) -> String? {
            guard let hashes = imageBlurHashes else { return nil }
            return hashes[imageType.rawValue]?.values.first
        }
        
        public var runTime: Int {
            return Int(runTimeTicks ?? 0/1000000)
        }
        public var userData: UserData
        
        enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
            case overview = "Overview"
            case year = "ProductionYear"
            case genres = "GenreItems"
            case type = "Type"
            case people = "People"
            case imageBlurHashes = "ImageBlurHashes"
            case runTimeTicks = "RunTimeTicks"
            case userData = "UserData"
        }
    }
}
