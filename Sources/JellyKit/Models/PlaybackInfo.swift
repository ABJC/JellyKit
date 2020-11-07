//
//  File.swift
//  
//
//  Created by Noah Kamara on 05.11.20.
//

import Foundation
extension API.Models {
    public class PlaybackInfo {
        public struct Start: Codable {
            public let itemId: String
            public let positionTicks: Int
            enum CodingKeys: String, CodingKey {
                case itemId = "ItemId"
                case positionTicks = "PositionTicks"
            }
        }
        
        public struct Progress: Codable {
            public let itemId: String
            public let positionTicks: Int
            public var eventName: Event = .timeUpdate
            enum CodingKeys: String, CodingKey {
                case itemId = "ItemId"
                case positionTicks = "PositionTicks"
                case eventName = "EventName"
            }
            
            public enum Event: String, Codable {
                case timeUpdate = "TimeUpdate"
                case pause = "Pause"
                case unpause = "Unpause"
            }
        }
        
        public struct Stop: Codable {
            public let itemId: String
            public let positionTicks: Int
            enum CodingKeys: String, CodingKey {
                case itemId = "ItemId"
                case positionTicks = "PositionTicks"
            }
        }
    }
}
