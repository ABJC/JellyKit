//
//  File.swift
//  
//
//  Created by Noah Kamara on 31.10.20.
//

import Foundation

public protocol Playable {
    var id: String { get }
    var userData: API.Models.UserData { get }
    var type: API.Models.MediaType { get }
}

