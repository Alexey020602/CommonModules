//
//  LogPublisherExtension.swift
//  Log
//
//  Created by Alexey on 17.04.2023.
//

import Combine
public extension Publisher{
    func log(
        _ addMessage:String? = nil,
        userInfo:LogUserInfo? = nil,
        serviceInfo:LogServiceInfo? = nil,
        level:LogLevel = .debug,
        category:String? = nil,
        parentEvent:Log.GenericEvent? = nil,
        fileId:StaticString = #fileID,
        function:StaticString = #function,
        line:UInt = #line
    ) -> AnyPublisher<Output, Failure>{
        self
            .handleEvents{
                Log.log(
                    addMessage ?? "" + "\($0)",
                    userInfo: userInfo,
                    serviceInfo: serviceInfo,
                    level: level,
                    category: category,
                    parentEvent: parentEvent,
                    fileId:fileId,
                    function:function,
                    line:line
                )
            }receiveCompletion:{ completion in
                switch completion{
                case .failure(let error):
                    Log.log(
                        error: error,
                        serviceInfo:serviceInfo,
                        category:category,
                        parentEvent:parentEvent,
                        fileId:fileId,
                        function:function,
                        line:line
                    )
                case .finished:
                    Log.log(
                        addMessage ?? "" + "Успешно завершена подписка",
                        userInfo: userInfo,
                        serviceInfo: serviceInfo,
                        level: level,
                        category: category,
                        parentEvent: parentEvent,
                        fileId:fileId,
                        function:function,
                        line:line
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}

