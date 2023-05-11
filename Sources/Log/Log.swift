//
//  Log.swift
//  KatharsisFramework
//
//  Created by Alexey on 22.03.2023.
//

import Foundation

public class Log{
    
    private let loggers:[any LoggerProtocol]
    private let queue:DispatchQueue
    public init(
        loggers: [any LoggerProtocol],
        queue: DispatchQueue = .init(label:String(describing: Log.self))
    ){
        self.loggers = loggers
        self.queue = queue
    }
    public static var instance = Log.default
    static let `default` = Log(loggers: defaultLoggers)
    static let defaultLoggers:[any LoggerProtocol] = [
        OSLoger(levels: .allCases)
    ]
    
    public static func log(
        request:URLRequest,
        userInfo: LogUserInfo? = nil,
        serviceInfo:LogServiceInfo? = nil,
        level:LogLevel = .debug,
        category:String? = nil,
        parentEvent:GenericEvent? = nil,
        fileId:StaticString = #fileID,
        function:StaticString = #function,
        line:UInt = #line
    ){
        Log.instance.log(
            request: request,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            fileId: fileId,
            function: function,
            line: line
        )
    }
    
    public static func log(
       _ message:String,
       userInfo: LogUserInfo? = nil,
       serviceInfo:LogServiceInfo? = nil,
       level:LogLevel = .debug,
       category:String? = nil,
       parentEvent:GenericEvent? = nil,
       fileId:StaticString = #fileID,
       function:StaticString = #function,
       line:UInt = #line
    ){
        Log.instance.log(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            fileId: fileId,
            function: function,
            line: line
        )
    }
    
    public static func log(
        error: any Error,
        serviceInfo:LogServiceInfo? = nil,
        category:String? = nil,
        parentEvent:GenericEvent? = nil,
        fileId:StaticString = #fileID,
        function:StaticString = #function,
        line:UInt = #line
    ){
        Log.instance.log(
            error: error,
            serviceInfo: serviceInfo,
            category: category,
            parentEvent: parentEvent,
            fileId: fileId,
            function: function,
            line: line
        )
    }
    
    public static func logStart(
        _ message:StaticString,
        userInfo: LogUserInfo? = nil,
        serviceInfo:LogServiceInfo? = nil,
        level:LogLevel = .debug,
        category:String? = nil,
        parentEvent:GenericEvent? = nil,
        fileId:StaticString = #fileID,
        function:StaticString = #function,
        line:UInt = #line
    ) -> Log.StartEvent{
        Log.instance.logStart(
            message,
            userInfo: userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            fileId: fileId,
            function: function,
            line: line
        )
    }
    
    public static func logStart(
        _ event:StartEvent
    ){
        Log.instance.logStart(event)
    }
    
    public static func logEnd(
        _ startEvent:Log.StartEvent,
        message:StaticString?,
        userInfo: LogUserInfo? = nil,
        serviceInfo:LogServiceInfo? = nil,
        level:LogLevel = .debug,
        category:String? = nil,
        parentEvent:GenericEvent? = nil,
        fileId:StaticString = #fileID,
        function:StaticString = #function,
        line:UInt = #line
    ){
        Log.instance.logEnd(
            startEvent, 
            message: message, 
            userInfo: userInfo, 
            serviceInfo: serviceInfo, 
            category: category, 
            parentEvent: parentEvent, 
            fileId: fileId, 
            function: function, 
            line: line
        )
    }
    
    public func log(
        _ message:String,
        userInfo:LogUserInfo?,
        serviceInfo:LogServiceInfo?,
        level:LogLevel,
        category:String?,
        parentEvent:GenericEvent?,
        fileId:StaticString,
        function:StaticString,
        line:UInt
    ){
        queue.async {
            let source = GenericEvent.Source(
                fileId:fileId,
                function:function,
                line:line
            )
            let event = Log.GenericEvent(
                message.description,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
            
            self.loggers.forEach { logger in
                logger.log(event)
            }
        }
    }
    
    public func log(
        request:URLRequest,
        userInfo:LogUserInfo?,
        serviceInfo:LogServiceInfo?,
        level:LogLevel,
        category:String?,
        parentEvent:GenericEvent?,
        fileId:StaticString,
        function:StaticString,
        line:UInt
    ){
        func messageFromRequest(_ request:URLRequest) -> String{
            var message = ""
            if let method = request.httpMethod{
                message += "\n" + method
            }
            if let url = request.url{
                message += "\n" + url.absoluteString
            }
            if let headers = request.allHTTPHeaderFields{
                for (key, value) in headers {
                    message += "\nHeaders:"
                    message += "\n\(key):\(value)"
                }
            }
            if let data = request.httpBody,
                let bodyString = String(data: data, encoding: .utf8){
                message += "\nBody:"
                message += "\n\(bodyString)"
            }
            return message
        }
        let message = messageFromRequest(request)
        queue.async {
            let source = GenericEvent.Source(
                fileId:fileId,
                function:function,
                line:line
            )
            let event = Log.GenericEvent(
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
            
            self.loggers.forEach { logger in
                logger.log(event)
            }
        }
    }
    
    public func log(
        error: any Error,
        serviceInfo:LogServiceInfo?,
        category:String?,
        parentEvent:GenericEvent?,
        fileId:StaticString,
        function:StaticString,
        line:UInt
    ){
        queue.async {
            let source = GenericEvent.Source(
                fileId:fileId,
                function: function,
                line:line
            )
            
            let event = Log.ErrorEvent(
                error: error,
                serviceInfo: serviceInfo,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
            
            
            self.loggers.forEach { logger in
                logger.log(event)
            }
        }
    }
    
    public func logStart(
        _ message:StaticString,
        userInfo:LogUserInfo?,
        serviceInfo:LogServiceInfo?,
        level:LogLevel,
        category:String?,
        parentEvent:GenericEvent?,
        fileId:StaticString,
        function:StaticString,
        line:UInt
    ) -> Log.StartEvent{
        let source = GenericEvent.Source(
            fileId:fileId,
            function:function,
            line: line
        )
        
        let event = StartEvent(
            message,
            userInfo:userInfo,
            serviceInfo: serviceInfo,
            level: level,
            category: category,
            parentEvent: parentEvent,
            source: source
        )
        
        logStart(event)
        
        return event
    }
    
    public func logStart(
        _ event:Log.StartEvent
    ){
        queue.async {
            self.loggers.forEach{logger in
                logger.logStart(event)
            }
        }
    }
    
    public func logEnd(
        _ startEvent:Log.StartEvent,
        message:StaticString?,
        userInfo:LogUserInfo?,
        serviceInfo:LogServiceInfo?,
        category:String?,
        parentEvent:GenericEvent?,
        fileId:StaticString,
        function:StaticString,
        line:UInt
    ){
        queue.async {
            let source = GenericEvent.Source(
                fileId:fileId,
                function:function,
                line:line
            )
            
            let event = Log.EndEvent(
                message: message ?? startEvent.rawMessage,
                startEvent: startEvent,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level:startEvent.level,
                category: category,
                parentEvent: parentEvent ?? startEvent.parentEvent,
                source: source
            )
            
            self.loggers.forEach { logger in
                logger.logEnd(event)
            }
        }
    }
}

