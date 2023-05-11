//
//  AuthorizationConfiguration.swift
//  AuthorizationFramework
//
//  Created by Alexey on 11.04.2023.
//

import Foundation
import AppAuth

public enum AuthScopes:String{
    case openId
    case profile
    case email
    case address
    case phone
    case mobileApi
    case offlineAccess
    
    public var rawValue:String{
        switch self {
        case .openId:
            return OIDScopeOpenID
        case .profile:
            return OIDScopeProfile
        case .email:
            return OIDScopeEmail
        case .address:
            return OIDScopeAddress
        case .phone:
            return OIDScopePhone
        case .mobileApi:
            return "mobile_api"
        case .offlineAccess:
            return "offline_access"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue{
        case OIDScopeOpenID:
            self = .openId
        case OIDScopeProfile:
            self = .profile
        case OIDScopeEmail:
            self = .email
        case OIDScopeAddress:
            self = .address
        case OIDScopePhone:
            self = .phone
        case "mobile_api":
            self = .mobileApi
        case "offline_access":
            self = .offlineAccess
        default:
            return nil
        }
    }
}

public struct AuthorizationConfiguration{
    public var issuer:String
    public let clientId:String
    public let scopes:Set<AuthScopes>
    public let callbackUrl:String
    
    public init(issuer: String, clientId: String, scopes: Set<AuthScopes>, callbackUrl: String) {
        self.issuer = issuer
        self.clientId = clientId
        self.scopes = scopes
        self.callbackUrl = callbackUrl
    }
}
