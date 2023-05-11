//
//  PublisherModifier.swift
//  RabotaVsem
//
//  Created by Alexey on 16.02.2023.
//

import Foundation
import Combine
import Log

extension Publishers{
    struct ProcessNetwork<T:Decodable, Upstream:Publisher>:Publisher
    where Upstream.Output == (data:Data, response:URLResponse), Upstream.Failure == URLError{
        typealias Output = T
        typealias Failure = Error
        private let upstream:Upstream
        private let decoder:JSONDecoder
        init(_ type:T.Type, upstream:Upstream){
            self.upstream = upstream
            self.decoder = JSONDecoder()
            self.decoder.dateDecodingStrategy = .custom{ decoder in
                let container = try decoder.singleValueContainer()
                let dateString:String = try container.decode(String.self)
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [
                    .withFullDate,
                    .withDashSeparatorInDate,
                    .withColonSeparatorInTime,
                    .withTime
                    //.withColonSeparatorInTimeZone,
                    //.withTimeZone
                    
                ]
                guard let date = formatter.date(from:dateString) else {
                    throw RequestError.invalidDate(message: dateString)
                }
                return date
            }
        }
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            upstream.tryMap{(data, response) in
                if let body = String(data: data, encoding: .utf8){
                    Log.log("Data after request: \(body)", category: "Сетевые запросы")
                }
                guard let response = response as? HTTPURLResponse else{throw RequestError.noHttpResponse}
                try response.validate(data)
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(subscriber: subscriber)
        }
    }
}

public extension Publisher where Output == (data:Data, response:URLResponse), Failure == URLError{
    
//    func processNetworkResponse<T:Decodable>(_ type:T.Type) -> AnyPublisher<T, Error>{
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .custom{ decoder in
//            let container = try decoder.singleValueContainer()
//            let dateString:String = try container.decode(String.self)
//            let formatter = ISO8601DateFormatter()
//            formatter.formatOptions = [
//                .withFullDate,
//                .withDashSeparatorInDate,
//                .withColonSeparatorInTime,
//                .withTime
//                //.withColonSeparatorInTimeZone,
//                //.withTimeZone
//
//            ]
//            guard let date = formatter.date(from:dateString) else {
//                throw RequestError.invalidDate(message: dateString)
//            }
//            return date
//        }
//        return self
//            .tryMap{(data, response) in
//                if let body = String(data: data, encoding: .utf8){
//                    Log.log("Data after request: \(body)", category: "Сетевые запросы")
//                }
//                guard let response = response as? HTTPURLResponse else{throw RequestError.noHttpResponse}
//                do {
//                    try response.validate(data)
//                } catch{
//                    throw error
//                }
//                return data
//            }
//            .decode(type: T.self, decoder: decoder)
//            .print(#function)
//            .eraseToAnyPublisher()
//    }
    func processNetworkResponse<T:Decodable>(_ type:T.Type) -> AnyPublisher<T, Error>{
        Publishers.ProcessNetwork(type, upstream: self)
            .eraseToAnyPublisher()
    }
    
}

public extension HTTPURLResponse{
    func validate(_ data:Data?) throws{
        if let error = RequestError( self, data: data){
            throw error
        }
    }
}
