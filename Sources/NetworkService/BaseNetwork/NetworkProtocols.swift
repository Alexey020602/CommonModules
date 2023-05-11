//
// Created by Alexey on 01.11.2022.
//

import Foundation
import Log



public protocol PService{
    //Нужно реализовать
    var baseURL:URL{get}
    var path:String{get}
    var httpMethod: HTTPMethod{get}
    var queryParameters:Parameters?{get}
    var bodyParameters:Parameters?{get}
    var headers: HTTPHeaders? {get}
    var task: HTTPTask {get}

    
    
    //Не обязательно реализовывать
    var method: String { get }
    //var queryItems:[URLQueryItem]?{get}
    //var bodyItems:Data?{get}
}
public extension PService{
    var method: String {
        return httpMethod.rawValue
    }

    var queryItems: [URLQueryItem]? {
            //print("\(try? JSONSerialization.data(withJSONObject: parameters))")
            return  queryParameters.map { parameters in
                return parameters.keys.map {element in
                    Log.log("Параметр" + "\n" + String(describing:element), category: "Сетевые запросы")
                    return URLQueryItem(name: element, value: "\(parameters[element].isNil ? "" : parameters[element]!)")
                }
            }
    }

    var bodyItems: Data? {
        return try? JSONSerialization.data(withJSONObject: queryParameters as Any)
    }
}


