//
// Created by Alexey on 21.12.2022.
//

import Foundation
import Combine

public typealias  NetworkRouterCompletion = (_ data:Data?, _ response:URLResponse?, _ error:Error?) -> ()

public protocol PNetworkRouter: AnyObject{
    associatedtype EndPoint:PService
    func request( _ route:EndPoint, completion: @escaping  NetworkRouterCompletion)
    func requestPublisher(_ route: EndPoint) ->AnyPublisher<(data:Data, response: URLResponse), URLError>
    func download(_ route:EndPoint, delegate:URLSessionDownloadDelegate?) -> AnyPublisher<(url:URL?, response:URLResponse?), Error>
    func cancel()
}
