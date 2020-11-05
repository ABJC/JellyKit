//
//  File.swift
//  
//
//  Created by Noah Kamara on 05.11.20.
//

import Foundation

extension API.Errors {
    public enum ServerError: Int, Error {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case serverError = 500
        
        case unknown = 0
        
        public static func make(_ statusCode: Int) throws {
            if statusCode == 200 {
                return
            }
            if statusCode >= 500 && statusCode <= 600 {
                throw Self.serverError
            }
            throw Self.init(rawValue: statusCode) ?? .unknown
        }
    }
}
