//
//  File.swift
//  
//
//  Created by Noah Kamara on 26.10.20.
//

import Foundation

extension API.Models {
    public enum MediaType: String, Decodable {
        case movie = "Movie"
        case series = "Series"
        case episode = "Episode"
    }
}
