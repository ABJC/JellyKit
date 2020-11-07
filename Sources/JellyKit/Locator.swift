//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.10.20.
//

import Foundation
    


public class ServerLocator {
    public struct ServerCredential: Codable {
        public let host: String
        public let port: Int
        public let username: String
        public let password: String
        public let deviceId: String
        
        public init(_ host: String, _ port: Int, _ username: String, _ password: String, _ deviceId: String = UUID().uuidString) {
            self.host = host
            self.port = port
            self.username = username
            self.password = password
            self.deviceId = deviceId
        }
    }
    
    public struct ServerLookupResponse: Codable, Hashable, Identifiable {
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
        
        private let address: String
        public let id: String
        public let name: String
        
        public var url: URL {
            URL(string: self.address)!
        }
        public var host: String {
            let components = URLComponents(string: self.address)
            return components!.host!
        }
        
        public var port: Int {
            let components = URLComponents(string: self.address)
            return components!.port!
        }
        
        enum CodingKeys: String, CodingKey {
            case address = "Address"
            case id = "Id"
            case name = "Name"
        }
    }
    private let broadcastConn: UDPBroadcastConnection
        
    public init() {
        func receiveHandler(_ ipAddress: String, _ port: Int, _ response: Data) {
            let utf8String = String(data: response, encoding: .utf8) ?? ""
            print("UDP connection received from \(ipAddress):\(port):\n\(utf8String)\n")
        }
        
        func errorHandler(error: UDPBroadcastConnection.ConnectionError) {
            print(error)
        }
        self.broadcastConn = try! UDPBroadcastConnection(port: 7359, handler: receiveHandler, errorHandler: errorHandler)
    }
    
    public func locateServer(completion: @escaping (ServerLookupResponse?) -> Void) {
        func receiveHandler(_ ipAddress: String, _ port: Int, _ data: Data) {
            do {
                let response = try JSONDecoder().decode(ServerLookupResponse.self, from: data)
                completion(response)
            } catch {
                print(error)
                completion(nil)
            }
        }
        self.broadcastConn.handler = receiveHandler
        do {
            try broadcastConn.sendBroadcast("Who is JellyfinServer?")
        } catch {
            print(error)
        }
    }
}
//
//extension ServerLocator {
//    class UDPClient {
//        var connection: NWConnection
//        var address: NWEndpoint.Host
//        var port: NWEndpoint.Port
//        private var listening = true
//
////        var resultHandler = NWConnection.SendCompletion.contentProcessed { NWError in
////            guard NWError == nil else {
////                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
////                return
////            }
////        }
//
//        init?(address newAddress: String, port newPort: Int32, listener isListener: Bool = true) {
//            guard let codedAddress = IPv4Address(newAddress),
//                let codedPort = NWEndpoint.Port(rawValue: NWEndpoint.Port.RawValue(newPort)) else {
//                    print("Failed to create connection address")
//                    return nil
//            }
//            address = .ipv4(codedAddress)
//            port = codedPort
//            listening = isListener
//            connection = NWConnection(host: address, port: port, using: .udp)
//
//            connect()
//        }
//
//        func connect() {
//            connection.stateUpdateHandler = { newState in
//                switch (newState) {
//                case .ready:
//                    print("State: Ready")
//                    if self.listening { self.listen() }
//                case .setup:
//                    print("State: Setup")
//                case .cancelled:
//                    print("State: Cancelled")
//                case .preparing:
//                    print("State: Preparing")
//                default:
//                    print("ERROR! State not defined!\n")
//                }
//            }
//            connection.start(queue: .global())
//        }
//
//        func send(_ data: Data) {
//            connection.send(content: data, completion: resultHandler)
//        }
//
//        private func listen() {
//            while listening {
//                connection.receiveMessage { data, context, isComplete, error in
//                    print("Receive isComplete: " + isComplete.description)
//                    guard let data = data else {
//                        print("Error: Received nil Data")
//                        return
//                    }
//                    print("Data Received")
//                }
//            }
//        }
//    }
//}
