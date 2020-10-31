//
//  File.swift
//  
//
//  Created by Noah Kamara on 24.10.20.
//

import Foundation

extension API {
    public class Completions {
        public typealias Basic = (Result<Void?, Error>) -> Void
        public typealias Response = (Result<Data, Error>) -> Void
        
        public typealias Items = (Result<[Models.Item], Error>) -> Void
        
        public typealias Movie = (Result<Models.Movie, Error>) -> Void
        public typealias Movies = (Result<[Models.Movie], Error>) -> Void
        
        public typealias Series = (Result<Models.Series, Error>) -> Void
        public typealias Seasons = (Result<[Models.Season], Error>) -> Void
        public typealias Episodes = (Result<[Models.Episode], Error>) -> Void
        
        public typealias People = (Result<[Models.Person], Error>) -> Void
        public typealias AuthResponse = (Result<Responses.AuthResponse, Error>) -> Void
        public typealias Images = (Result<[Models.Image], Error>) -> Void
        
        public typealias SystemInfo = (Result<Models.SystemInfo, Error>) -> Void
    }
}
