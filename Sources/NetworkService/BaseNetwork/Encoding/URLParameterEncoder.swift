//
// Created by Alexey on 21.12.2022.
//

import Foundation
import Log

public struct URLParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else {
            throw NetworkError.missingURL
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters{
                Log.log(String(describing: value)
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Ошибка при добавлении percentEncoding", category: "Сетевые запросы")
                let queryItem = URLQueryItem(
                        name: key,
                        value: String(describing: value)
                            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                )

                urlComponents.percentEncodedQueryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
            //print("URLComponents: \(urlComponents)")
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
