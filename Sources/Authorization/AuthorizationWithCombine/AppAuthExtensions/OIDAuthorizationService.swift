//
//  OIDAuthorizationService.swift
//  AuthorizationFramework
//
//  Created by Alexey on 06.04.2023.
//

import Foundation
import AppAuth
import Combine

public extension OIDAuthorizationService{
    static func discoverConfiguration(forIssuer:URL) -> AnyPublisher<OIDServiceConfiguration?, any Error>{
        return Future{ promise in
            OIDAuthorizationService.discoverConfiguration(forIssuer: forIssuer) { configuration, error in
                if let error{
                    promise(.failure(error))
                }
                promise(.success(configuration))
            }
        }.eraseToAnyPublisher()
    }
    
    static func discoverConfiguration(forDiscoveryURL:URL) -> AnyPublisher<OIDServiceConfiguration?, any Error>{
        return Future{ promise in
            OIDAuthorizationService.discoverConfiguration(forDiscoveryURL: forDiscoveryURL) { configuration, error in
                if let error{
                    promise(.failure(error))
                } else {
                    promise(.success(configuration))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func perform(_ request:OIDRegistrationRequest) -> AnyPublisher<OIDRegistrationResponse?, any Error>{
        return Future{ promise in
            Self.perform(request) { registrationResponse, error in
                if let error{
                    promise(.failure(error))
                    return
                }else{
                    promise(.success(registrationResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func perform(_ request:OIDTokenRequest) -> AnyPublisher<OIDTokenResponse?, any Error>{
        return Future{ promise in
            Self.perform(request) { tokenResponse, error in
                if let error{
                    promise(.failure(error))
                }else{
                promise(.success(tokenResponse))
                    
                }
            }
        }.eraseToAnyPublisher()
    }
    
    static func perform(_ request:OIDTokenRequest, originalAuthorizationResponse:OIDAuthorizationResponse?) -> AnyPublisher<OIDTokenResponse?, any Error>{
        return Future{ promise in
            Self.perform(request, originalAuthorizationResponse: originalAuthorizationResponse) { tokenResponse, error in
                if let error{
                    promise(.failure(error))
                } else{
                    promise(.success(tokenResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
}

