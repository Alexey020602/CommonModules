//
// Created by Alexey on 21.12.2022.
//

import Foundation
import Combine
import Log

//class MyUrlProtocol:URLProtocol{
//    override class func property(forKey key: String, in request: URLRequest) -> Any? {
//        <#code#>
//    }
//}

public class Router<EndPoint: PService>: PNetworkRouter {
    private var task: URLSessionTask?
    
    private let configuration:URLSessionConfiguration = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 150
        return configuration
    }()
    
    public init(){
    }
    @available(iOS 15.0, *)
    public func download(_ route: EndPoint, delegate:URLSessionDownloadDelegate? = nil) async throws -> (URL,URLResponse) {
        let session = URLSession(configuration: self.configuration)
        let request = try self.buildRequest(from: route)
        return try await session.download(for: request)
    }
    
    public func download(_ route:EndPoint, delegate:URLSessionDownloadDelegate? = nil) -> AnyPublisher<(url:URL?, response:URLResponse?), Error> {
        let session = URLSession(configuration: self.configuration)
        return Future{ promise in
            do {
                let request = try self.buildRequest(from: route)
            
                self.task = session.downloadTask(with: request) { url, response, error in
                    if let error{
                        promise(.failure(error))
                        return
                    }
                    promise(.success((url:url, response:response)))
                }
            } catch{
                promise(.failure(error))
            }
            self.task?.resume()
        }.eraseToAnyPublisher()
    }
    
    public func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession(configuration: self.configuration)
        //session.configuration.timeoutIntervalForRequest = 100
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: completion)
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    public func request(_ route:EndPoint) async throws -> (Data, URLResponse){
        let session = URLSession(configuration: self.configuration)
        let request = try self.buildRequest(from: route)
        return try await session.data(for: request)
    }

    public func requestPublisher(_ route: EndPoint) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        let session = URLSession(configuration: self.configuration)
        do {
            let request = try self.buildRequest(from: route)
            return session.dataTaskPublisher(for: request)
                    .eraseToAnyPublisher()
        } catch {
            return Fail(outputType: (data: Data, response: URLResponse).self, failure: URLError(URLError.cannotDecodeContentData))
                    .eraseToAnyPublisher()
        }
    }


    /*public func downloadPublisher(_ route:EndPoint) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)

            session.
        } catch{
            return
        }
    }*/

    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(
                url: route.baseURL.appendingPathComponent(route.path),
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: 10.0
        )
        request.httpMethod = route.method
        self.additionalHeaders(route.headers, request: &request)
        do{
//            switch route.task{
//            case .request:
                try self.configureParameters(
                    bodyParameters: route.bodyParameters,
                    urlParameters: route.queryParameters,
                    request: &request
                )
//            case .requestParameters(let bodyParameters, let urlParameters):
//                try self.configureParameters(
//                        bodyParameters: bodyParameters,
//                        urlParameters: urlParameters,
//                        request: &request
//                )
            /*case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionHeaders):
                self.additionalHeaders(additionHeaders, request:&request)
                try self.configureParameters(
                        bodyParameters: bodyParameters,
                        urlParameters: urlParameters,
                        request: &request
                )*/
//            }
            Log.log(request: request, category: "Сетевые запросы")
            return request
        } catch{
            throw error
        }
    }

    fileprivate func configureParameters(
            bodyParameters: Parameters?,
            urlParameters: Parameters?,
            request: inout URLRequest
    ) throws{
        Log.log(String(describing: bodyParameters) + "\n" + String(describing: urlParameters), category: "Сетевые запросы")
        do{
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }

    fileprivate func additionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest){
        guard let headers = additionalHeaders else {return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

    public func cancel() {
        self.task?.cancel()
    }

}
