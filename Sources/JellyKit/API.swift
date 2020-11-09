//
//  File.swift
//  
//
//  Created by Noah Kamara on 23.10.20.
//

import Foundation
import AVFoundation

public class API {
    public class Models {}
    public class Responses {}
    public class Errors {}
    
    private let scheme: String = "http"
    public let host: String
    public let port: Int
    
    private let deviceId: String
    private var currentUser: AuthUser?
    
    public init(_ host: String = "192.168.178.10", _ port: Int = 8096, _ user: AuthUser? = nil, _ deviceID: String? = nil) {
        self.host = host
        self.port = port
        self.deviceId = user?.deviceID ?? deviceID ?? UUID().uuidString
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
        request.timeoutInterval = 60.0
        return request
    }
    
    private func get(_ path: String, _ params: [String: String?] = [:], completion: @escaping Completions.Response) {
        let request = self.makeRequest(path, params)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                do {
                    try Errors.ServerError.make(httpResponse.statusCode)
                } catch let error {
                    completion(.failure(error))
                }
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    private func post(_ path: String, _ data: Data? = nil, _ completion: @escaping Completions.Basic) {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.port = self.port
        urlComponents.path = path
        var request = self.makeRequest(path)
        request.httpMethod = "POST"
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    do {
                        try Errors.ServerError.make(httpResponse.statusCode)
                    } catch let error {
                        completion(.failure(error))
                    }
                }
                completion(.success(nil))
            }
        }.resume()
    }
    
    private func delete(_ path: String, _ params: [String: String?], _ data: Data, _ completion: @escaping Completions.Basic) {
        var request = self.makeRequest(path, params)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    do {
                        try Errors.ServerError.make(httpResponse.statusCode)
                    } catch let error {
                        completion(.failure(error))
                    }
                }
                completion(.success(nil))
            }
        }.resume()
    }
    
    
    //MARK: Authorization
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
                                                    deviceID: self.deviceId,
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
        print("HOST: ", host, "PORT: ", port)
        print(username, password)
        self.authorizeByName(username, password, completion: completion)
    }
    
    
    //MARK: System Info
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
    
    
    
    
    //MARK: Query Items
    public func getItems(_ type: Models.MediaType? = nil, completion: @escaping Completions.Items) {
        let path = "/emby/Users/\(self.currentUser?.id ?? "")/Items"
        let params = [
            "Recursive": String(true),
            "IncludeItemTypes": type?.rawValue ?? "Series,Movie",
            "Fields": "Genres,Overview"
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
    
    
    // MARK: Get Images
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
    
    
    // MARK: Shows (Seasons, Episodes)
    public func getSeries(_ item_id: String, completion: @escaping Completions.Series) {
        let path = "/Users/\(currentUser?.id ?? "")/Items/\(item_id)"
        let params = [
            "Fields": "Genres,Overview,People,MediaSources"
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(Models.Series.self, from: data)
                        completion(.success(response))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func getSeasons(for series_id: String, completion: @escaping Completions.Seasons) {
        let path = "/Shows/\(series_id)/Seasons"
        let params = [
            "userId": self.currentUser?.id ?? "",
            "IncludeItemTypes": "Season",
            "SortOrder": "Ascending",
            "Fields": "Genres,Overview,People,CommunityRating"
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(Responses.ItemResponse<[Models.Season]>.self, from: data)
                        completion(.success(response.items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    public func getEpisodes(for series_id: String, completion: @escaping Completions.Episodes) {
        let path = "/Shows/\(series_id)/Episodes"
        let params = [
            "userId": self.currentUser?.id ?? "",
            "IncludeItemTypes": "Episode",
            "SortBy": "PremiereDate",
            "SortOrder": "Ascending",
            "Fields": "Genres,Overview,People,CommunityRating,MediaSources"
        ]
        self.get(path, params) { (result) in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(Responses.ItemResponse<[Models.Episode]>.self, from: data)
                        completion(.success(response.items))
                    } catch let error {
                        completion(.failure(error))
                    }
                case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    
    
    // MARK: Search
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
    
    // MARK: PlaybackStatus
    public func startPlayback(for item_id: String, at positionTicks: Int) {
        let path = "/Sessions/Playing"
        let info = Models.PlaybackInfo.Start(itemId: item_id, positionTicks: positionTicks)
        do {
            let data = try JSONEncoder().encode(info)
            self.post(path, data) { (result) in
                switch result {
                    case .success(_): break
                    case .failure(_): break
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    public func reportPlayback(for item_id: String, positionTicks: Int) {
        let path = "/Sessions/Playing/Progress"
        print("TICKS", positionTicks, positionTicks/1000000)
        let info = Models.PlaybackInfo.Progress(itemId: item_id, positionTicks: positionTicks)
        do {
            let data = try JSONEncoder().encode(info)
            self.post(path, data) { (result) in
                switch result {
                    case .success(_): break
                    case .failure(_): break
                }
            }
        } catch let error {
            print("ERROR", error)
        }
    }
    
    public func stopPlayback(for item_id: String, positionTicks: Int) {
        let path1 = "/Sessions/Playing/Stop"
        self.post(path1) { (result) in
            switch result {
                case .success(_): break
                case .failure(_): break
            }
        }
        let path = "/Videos/ActiveEncodings"
        let params = [
            "DeviceId": self.deviceId
        ]
        let info = Models.PlaybackInfo.Stop(itemId: item_id, positionTicks: positionTicks)
        do {
            let data = try JSONEncoder().encode(info)
            self.delete(path, params, data) { (result) in
                switch result {
                    case .success(_ ): print("SUCCESS")
                    case .failure(let error): print(error)
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    
    
    // MARK: get URLs
    public func getStreamURL(for item_id: String, _ source_id: String) -> URL {
//        let path = "/videos/\(item_id)/main.m3u8"
        let path = "/videos/18f93bce-e588-75f1-5a12-7dc7aa05f041/master.m3u8"
//        let params = [
//            "VideoCodec": "h264",
//            "DeviceId": self.deviceId,
//            "MediaSourceId": source_id,
//            "h264-profile": "high"
//        ]
        let params = [
            "DeviceId": self.deviceId,
            "MediaSourceId": "18f93bcee58875f15a127dc7aa05f041",
            "VideoCodec": "h264",
            "AudioCodec": "ac3,mp3,aac",
            "VideoBitrate": "139680000",
            "AudioBitrate": "320000",
            "api_key": "8fd5be7c5b1247b3aad42b884941eac6",
            "TranscodingMaxAudioChannels": "2",
            "RequireAvc": "false",
            "Tag": "c01e1469dd17e2934103b24417a40794",
            "SegmentContainer": "ts",
            "MinSegments": "2",
            "BreakOnNonKeyFrames": "True",
            "h264-profile": "high,main,baseline,constrainedbaseline",
            "h264-level": "51",
            "h264-deinterlace": "true",
            "TranscodeReasons": "ContainerNotSupported,VideoCodecNotSupported,AudioCodecNotSupported"
        ]
        let request = self.makeRequest(path, params)
        let url = request.url!
        return url
    }
    
    
    public func getPlayerItem(for item_id: String, _ source_id: String) -> AVURLAsset {
        let path = "/videos/\(item_id)/master.m3u8"
        let params = [
            "DeviceId": self.deviceId,
            "MediaSourceId": source_id,
            "VideoCodec": "h264",
            "AudioCodec": "ac3,mp3,aac",
            "VideoBitrate": "139680000",
            "AudioBitrate": "320000",
            "TranscodingMaxAudioChannels": "2",
            "RequireAvc": "false",
            "SegmentContainer": "ts",
            "MinSegments": "2",
            "BreakOnNonKeyFrames": "True",
            "h264-profile": "high,main,baseline,constrainedbaseline",
            "h264-level": "51",
            "h264-deinterlace": "true",
            "TranscodeReasons": "ContainerNotSupported,VideoCodecNotSupported,AudioCodecNotSupported"
        ]
        let request = self.makeRequest(path, params)
        let url = request.url!
        let options = ["AVURLAssetHTTPHeaderFieldsKey": request.allHTTPHeaderFields ?? [:]]
        let item = AVURLAsset(url: url, options: options)
        return item
    }
    
    public func getImageURL(for id: String, _ type: Models.ImageType = .primary, _ maxWidth: Int = 600) -> URL {
        let path = "/Items/\(id)/Images/\(type.rawValue)"
        let params = [
            "MaxWidth": String(maxWidth),
            "Format": "jpg",
            "Quality": String(70)
        ]
        let request = self.makeRequest(path, params)
        let url = request.url!
        return url
    }
}
