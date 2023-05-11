//
//  UpdatableWrapForService.swift
//  NetworkService
//
//  Created by Alexey on 12.04.2023.
//

import Foundation
import FoundationExtensions
/*
@propertyWrapper
public struct UpdateService<Value:Service>:Service{
    public var headers: HTTPHeaders?{
        guard var heads = service.headers else {
            return self.additionalHeaders
        }
        heads.add(additionalHeaders)
        return heads
    }
    
    var service:Value
    public var wrappedValue: Value{
        get{
            service
        }
        set{
            service = newValue
        }
    }
    /*
    public var pojectedValue:URL{
        get{
            
        }
        set{
            
        }
    }
    */
    public var baseURL:URL = URL(string: "/")!
    private var additionalHeaders:HTTPHeaders = [:]
    
    public init() {
        
    }
}

public extension UpdateService{
    
    var path: String {
        service.path
    }
    
    var httpMethod: HTTPMethod {
        service.httpMethod
    }
    
    var parameters: Parameters? {
        service.parameters
    }
    
    var task: HTTPTask {
        service.task
    }
}
*/
@dynamicMemberLookup
public struct UpdatableWrapForService<TargetService:PService>:PService{
    public var service:TargetService!
    public var additionalHeaders:HTTPHeaders = [:]
    public init(){}
    public var baseURL:URL = URL(string: "/")!
    
    public var headers: NetworkService.HTTPHeaders?{
        guard var heads = service.headers else {
            return self.additionalHeaders
        }
        heads.add(additionalHeaders)
        return heads
    }
    
    public subscript<T>(dynamicMember keyPath:KeyPath<TargetService?, T>) -> T{
        service[keyPath: keyPath]
    }
     
    public subscript(_ key:String) -> String?{
        set {
            additionalHeaders[key] = newValue
        }
        get{
            return additionalHeaders[key]
        }
    }
}

public extension UpdatableWrapForService{
    
    var path: String {
        service.path
    }
    
    var httpMethod: HTTPMethod {
        service.httpMethod
    }
    
    var task: HTTPTask {
        service.task
    }
    
    var queryParameters: Parameters?{
        service.queryParameters
    }
    
    var bodyParameters: Parameters?{
        service.bodyParameters
    }
}
