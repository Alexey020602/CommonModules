//
// Created by Alexey on 21.12.2022.
//

import Foundation

public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String:Any]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum HTTPTask{
    case request
    
    case download

//    case requestParameters(
//        bodyParameters:Parameters?,
//        urlParameters:Parameters?
//    )
    

    /*case requestParametersAndHeaders(
            bodyParameters:Parameters?,
            urlParameters:Parameters?,
             additionHeaders:HTTPHeaders?
    )*/
}

public enum NetworkError: String, Error{
    case parameterNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case decodingFailed = "Parameter decoding failed."
    case missingURL = "URL is nil."
}

public enum RequestError:Error{
    case invalidParameters
    case noHttpResponse
    
    case invalidDate(message:String)
    // Для ответов сервера
    case clientError(message:String)
    case badRequest(message:String)
    case serverError(message:String)
    case unauthorized(message:String)
    case notFound(message:String)
    
    public init?(_ response:HTTPURLResponse, data:Data?){
        let message = { (data:Data?) -> String in
            guard let data else{return ""}
            return String(data: data, encoding: .utf8) ?? ""
        }(data)
        switch response.statusCode{
        case 400:
            self = .badRequest(message: message)
        case 401:
            self = .unauthorized(message: message)
        case 404:
            self = .notFound(message: message)
        case 400...499:
            self = .clientError(message: message)
        case 500...599:
            self = .serverError(message: message)
        default:
            return nil
        }
    }
}


public enum ResponseError:Error{

}
