//
//  OIDAuthState.swift
//  AuthorizationFramework
//
//  Created by Alexey on 06.04.2023.
//

import Foundation
import AppAuth
import Combine

public extension OIDAuthState{
    func performAction() -> AnyPublisher<(accessToken:String?, idToken:String?), any Error>{
        return Future{ promise in
            self.performAction { accessToken, idToken, error in
                if let error{
                    promise(.failure(error))
                }else{
                    promise(.success((accessToken: accessToken, idToken: idToken)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func performAction(additionalRefreshParameters: [String:String]?) -> AnyPublisher<(accessToken:String?, idToken:String?), any Error>{
        return Future{ promise in
            self.performAction(
                freshTokens: { accessToken, idToken, error in
                if let error{
                    promise(.failure(error))
                }else{
                    promise(.success((accessToken: accessToken, idToken: idToken)))
                }
            },
                additionalRefreshParameters:additionalRefreshParameters)
        }.eraseToAnyPublisher()
    }
    
    func performAction(additionalRefreshParameters: [String:String]?, dispatchQueue:DispatchQueue) -> AnyPublisher<(accessToken:String?, idToken:String?), any Error>{
        return Future{ promise in
            self.performAction(
                freshTokens: { accessToken, idToken, error in
                if let error{
                    promise(.failure(error))
                }else{
                    promise(.success((accessToken: accessToken, idToken: idToken)))
                }
            },
                additionalRefreshParameters:additionalRefreshParameters,
                dispatchQueue:dispatchQueue)
        }.eraseToAnyPublisher()
    }
}

