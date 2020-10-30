//
//  SwiftUIView.swift
//  
//
//  Created by Noah Kamara on 28.10.20.
//

import Foundation


extension API.Models {
    public struct User: Decodable, Identifiable {
        public let id: String
        public let name: String
        public let serverID: String
        
        public let hasPassword: Bool
        public let hasConfiguredPassword: Bool
        public let hasConfiguredEasyPassword: Bool
        public let enableAutoLogin: Bool
        public let lastLoginDate: String
        public let lastActivityDate: String
//        public let configuration: Configuration
//        public let policy: Policy

        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case serverID = "ServerId"
            case id = "Id"
            case hasPassword = "HasPassword"
            case hasConfiguredPassword = "HasConfiguredPassword"
            case hasConfiguredEasyPassword = "HasConfiguredEasyPassword"
            case enableAutoLogin = "EnableAutoLogin"
            case lastLoginDate = "LastLoginDate"
            case lastActivityDate = "LastActivityDate"
//            case configuration = "Configuration"
//            case policy = "Policy"
        }
    }
}

extension API.Models.User {
//    public struct Configuration: Decodable {
//        public let audioLanguagePreference: String
//        public let playDefaultAudioTrack: Bool
//        public let subtitleLanguagePreference: String
//        public let displayMissingEpisodes: Bool
//        public let subtitleMode: String
//        public let displayCollectionsView, enableLocalPassword: Bool
//        public let hidePlayedInLatest, rememberAudioSelections, rememberSubtitleSelections, enableNextEpisodeAutoPlay: Bool
//
//        enum CodingKeys: String, CodingKey {
//            case audioLanguagePreference = "AudioLanguagePreference"
//            case playDefaultAudioTrack = "PlayDefaultAudioTrack"
//            case subtitleLanguagePreference = "SubtitleLanguagePreference"
//            case displayMissingEpisodes = "DisplayMissingEpisodes"
//            case groupedFolders = "GroupedFolders"
//            case subtitleMode = "SubtitleMode"
//            case displayCollectionsView = "DisplayCollectionsView"
//            case enableLocalPassword = "EnableLocalPassword"
//            case orderedViews = "OrderedViews"
//            case latestItemsExcludes = "LatestItemsExcludes"
//            case myMediaExcludes = "MyMediaExcludes"
//            case hidePlayedInLatest = "HidePlayedInLatest"
//            case rememberAudioSelections = "RememberAudioSelections"
//            case rememberSubtitleSelections = "RememberSubtitleSelections"
//            case enableNextEpisodeAutoPlay = "EnableNextEpisodeAutoPlay"
//        }
//    }
}

//extension API.Models.User {
//    public struct Policy: Decodable {
//
//    }
//}
