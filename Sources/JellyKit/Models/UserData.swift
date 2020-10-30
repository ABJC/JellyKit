//
//  File.swift
//  
//
//  Created by Noah Kamara on 24.10.20.
//

import Foundation

extension API.Models {
    public struct UserData: Decodable {
        private let playbackPositionTicks: Int
        public var playbackPosition: Int {
            return Int(playbackPositionTicks/1000000)
        }
        public let playCount: Int
        public let isFavorite: Bool
        public let played: Bool
        public let key: String
        
        enum CodingKeys: String, CodingKey {
            case playbackPositionTicks = "PlaybackPositionTicks"
            case playCount = "PlayCount"
            case isFavorite = "IsFavorite"
            case played = "Played"
            case key = "Key"
        }
        
    }
}
