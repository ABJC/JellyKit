//
//  File.swift
//  
//
//  Created by Noah Kamara on 23.10.20.
//

import Foundation


public class API {
    public class Models {}
    public class Responses {}
    
    private let scheme: String = "http"
    private let host: String
    private let port: Int
    
    private let deviceId: String
    private var currentUser: AuthUser?
    
    public init(_ host: String = "192.168.178.10", _ port: Int = 8096, _ user: AuthUser? = nil) {
        self.host = host
        self.port = port
        self.deviceId = "12345678"
        self.currentUser = user
    }
    
    private func makeRequest(_ path: String, _ params: [String: String?] = [:], _ headers: [String: String] = [:]) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.port = self.port
        urlComponents.path = path
        if !params.isEmpty {
            urlComponents.queryItems = params.map({URLQueryItem(name: $0.key, value: $0.value)})
        }
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Content-type": "application/json",
            "X-Emby-Authorization": "Emby Client=abjc, Device=iOS, DeviceId=\(self.deviceId), Version=1.0.0",
            "X-Emby-Token": self.currentUser?.token ?? ""
        ]
        request.timeoutInterval = 15.0
        return request
    }
    
    private func get(_ path: String, _ params: [String: String?] = [:], completion: @escaping Completions.Response) {
        let request = self.makeRequest(path, params)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    private func authorizeByName(_ username: String, _ password: String, completion: @escaping Completions.AuthResponse) {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.port = self.port
        urlComponents.path = "/Users/AuthenticateByName"
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 5.0
        request.allHTTPHeaderFields = [
            "Content-type": "application/json",
            "X-Emby-Authorization": "Emby Client=abjc, Device=iOS, DeviceId=\(self.deviceId), Version=1.0.0",
        ]
        let jsonBody = [
            "Username": username,
            "Pw": password
        ]
        if let data = try? JSONEncoder().encode(jsonBody) {
            request.httpBody = data
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(Responses.AuthResponse.self, from: data)
                        self.currentUser = AuthUser(id: response.user.id,
                                                    name: response.user.name,
                                                    serverID: response.serverId,
                                                    token: response.token)
                        completion(.success(response))
                    } catch let error {
                        completion(.failure(error))
                    }
                } else {
                    print("ERROR")
                }
            }.resume()
        } else {
            print(jsonBody)
        }
    }
    
    
    public func authorize(_ username: String, _ password: String, completion: @escaping Completions.AuthResponse) {
        self.authorizeByName(username, password, completion: completion)
    }
    
    
    public func getSystemInfo(completion: @escaping Completions.SystemInfo) {
        let path = "/System/Info"
        self.get(path) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(API.Models.SystemInfo.self, from: data)
                        completion(.success(response))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    
    
    
    
    public func getItems(_ type: Models.MediaType? = nil, completion: @escaping Completions.Items) {
        let path = "/emby/Users/\(self.currentUser?.id ?? "")/Items"
        let params = [
            "Recursive": String(true),
            "IncludeItemTypes": type?.rawValue ?? "Series,Movie",
            "Fields": "Genres"
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(Responses.ItemResponse<[Models.Item]>.self, from: data)
                        completion(.success(response.items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func getLatest(_ type: Models.MediaType? = nil, completion: @escaping Completions.Items) {
        let path = "/emby/Users/\(self.currentUser?.id ?? "")/Items/Latest"
        let params = [
            "Recursive": String(true),
            "IncludeItemTypes": type?.rawValue ?? "Series,Movie",
            "Fields": "Genres"
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let items = try JSONDecoder().decode([Models.Item].self, from: data)
                        completion(.success(items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func getResumable(_ type: Models.MediaType? = nil, completion: @escaping Completions.Items) {
        let path = "/emby/Users/\(self.currentUser?.id ?? "")/Items/Latest"
        let params = [
            "Recursive": String(true),
            "IncludeItemTypes": type?.rawValue ?? "Series,Movie",
            "SortBy": "DatePlayed",
            "SortOrder": "Descending",
            "Filters": "IsResumable",
            "Fields": "Genres"
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let items = try JSONDecoder().decode([Models.Item].self, from: data)
                        completion(.success(items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func getFavorites(_ type: Models.MediaType? = nil, completion: @escaping Completions.Items) {
        let path = "/emby/Users/\(self.currentUser?.id ?? "")/Items/Latest"
        let params = [
            "Recursive": String(true),
            "IncludeItemTypes": type?.rawValue ?? "Series,Movie",
            "Filters": "IsFavorite",
            "Fields": "Genres"
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let items = try JSONDecoder().decode([Models.Item].self, from: data)
                        completion(.success(items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func getSimilar(for item_id: String, completion: @escaping Completions.Items) {
        let path = "/Items/\(item_id)/Similar"
        let params = [
            "Recursive": String(true),
            "IncludeItemTypes": "Series,Movie",
            "Fields": "Genres",
            "userId": self.currentUser?.id ?? ""
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(Responses.ItemResponse<[Models.Item]>.self, from: data)
                        completion(.success(response.items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func getMovie(_ item_id: String, completion: @escaping Completions.Movie) {
        let path = "/Users/\(currentUser?.id ?? "")/Items/\(item_id)"
        
        self.get(path) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(Models.Movie.self, from: data)
                        completion(.success(response))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }

    public func getImages(for item_id: String, completion: @escaping Completions.Images) {
        let path = "/Items/\(item_id)/Images"
        self.get(path) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode([Models.Image].self, from: data)
                        completion(.success(response))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func searchItems(_ searchTerm: String, completion: @escaping Completions.Items) {
        let path = "/Users/\(currentUser?.id ?? "")/Items"
        let params = [
            "searchTerm": searchTerm,
            "IncludeItemTypes": "Series,Movie",
            "Recursive": String(true),
            "Fields": "Genres",
            "Limit": String(24)
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(Responses.ItemResponse<[Models.Item]>.self, from: data)
                        completion(.success(response.items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func searchPeople(_ searchTerm: String, completion: @escaping Completions.People) {
        let path = "/Persons"
        let params = [
            "searchTerm": searchTerm,
            "IncludeTypes": "Person",
            "Recursive": String(true),
            "Limit": String(24)
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(Responses.ItemResponse<[Models.Person]>.self, from: data)
                        completion(.success(response.items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    
    
    public func getStreamURL(for item_id: String) -> URL {
        let path = "/Videos/\(item_id)/stream"
        let params = [
            "static": String(true)
        ]
        let request = self.makeRequest(path, params)
        let url = request.url!
        return url
        
    }
    
    public func getImageURL(for id: String, _ type: Models.ImageType = .primary) -> URL {
        let path = "/Items/\(id)/Images/\(type.rawValue)"
        let request = self.makeRequest(path)
        let url = request.url!
        return url
    }
}
