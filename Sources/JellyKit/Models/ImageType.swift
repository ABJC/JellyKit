//
//  File.swift
//  
//
//  Created by Noah Kamara on 25.10.20.
//

import Foundation

extension API.Models {
    public enum ImageType: String, Decodable {
        case primary = "Primary"
        case backdrop = "Backdrop"
        case art = "Art"
        case banner = "Banner"
        case logo = "Logo"
        case thumb = "Thumb"
        case thumbnail = "Thumbnail"
    }
}
