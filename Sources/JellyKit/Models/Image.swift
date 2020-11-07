//
//  File.swift
//  
//
//  Created by Noah Kamara on 28.10.20.
//

import Foundation

extension API.Models {
    public struct Image: Decodable {
        public let imageType: ImageType
        public let imageIndex: Int?
        public let imageTag: String?
        public let path: String
        public let blurHash: String?
        public let height, width, size: Int

        enum CodingKeys: String, CodingKey {
            case imageType = "ImageType"
            case imageIndex = "ImageIndex"
            case imageTag = "ImageTag"
            case path = "Path"
            case blurHash = "BlurHash"
            case height = "Height"
            case width = "Width"
            case size = "Size"
        }
    }
}
