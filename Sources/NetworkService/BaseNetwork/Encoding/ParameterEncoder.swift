//
// Created by Alexey on 21.12.2022.
//

import Foundation

public protocol ParameterEncoder{
    static func encode(urlRequest: inout URLRequest, with parameters:Parameters) throws
}