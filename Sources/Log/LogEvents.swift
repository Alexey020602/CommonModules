//
//  LogEvents.swift
//  KatharsisFramework
//
//  Created by Alexey on 22.03.2023.
//

import Foundation

public typealias LogUserInfo = [String:Any]
public typealias LogServiceInfo = Any

fileprivate extension String{
    var filename:String{
        URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    var module:String{
        return firstIndex(of: "/").flatMap {String(self[self.startIndex ..< $0]) } ?? ""
    }
}
extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
public extension Log{
    class GenericEvent{
        public let id:UUID
        public let timestamp:Date
        public let message:String
        public let userInfo:LogUserInfo?
        public let serviceInfo:LogServiceInfo?
        public let level:LogLevel
        public let category:String?
        public let parentEvent:GenericEvent?
        public let source:Source
        init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: String,
            userInfo: LogUserInfo? = nil,
            serviceInfo: LogServiceInfo? = nil,
            level: LogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.id = id
            self.timestamp = timestamp
            self.message = message
            self.userInfo = userInfo
            self.serviceInfo = serviceInfo
            self.level = level
            self.category = category
            self.parentEvent = parentEvent
            self.source = source
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: String,
            userInfo: LogUserInfo? = nil,
            serviceInfo: LogServiceInfo? = nil,
            level: LogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileId:StaticString = #fileID,
            function:StaticString = #function,
            line:UInt = #line
        ){
            self.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileId: fileId,
                    function: function,
                    line: line
                )
            )
        }
        
        public static func == (lhs:Log.GenericEvent, rhs:Log.GenericEvent) -> Bool{
            lhs.id == rhs.id
        }
    }
    
    
}

public extension Log.GenericEvent{
    struct Source{
        public let fileId:StaticString
        public let module:String
        public let filename:String
        public let function:StaticString
        public let line:UInt
        
        public init(
            fileId: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.fileId = fileId
            self.module = fileId.description.module
            self.filename = fileId.description.filename
            self.function = function
            self.line = line
        }
    }
}

public extension Log{
    class ErrorEvent:GenericEvent{
        public let error: any Error
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            error:any Error,
            serviceInfo: LogServiceInfo? = nil,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: GenericEvent.Source
        ) {
            self.error = error
            func domainWithoutModuleName(_ module:String) -> String{
                let nsError = error as NSError
                return nsError.domain
                    .deletingPrefix(module)
                    .deletingPrefix(".")
            }
            func nameWithoutUserInfo() -> String{
                let name = String(describing: error)
                guard let split = name.split(separator: "(").first else{return name}
                return String(split)
            }
            let message = [
                domainWithoutModuleName(source.module),
                nameWithoutUserInfo()
            ].joined(separator: ".")
            
            super.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: (error as? CustomNSError)?.errorUserInfo,
                serviceInfo: serviceInfo,
                level: error.level,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            error: any Error,
            serviceInfo: LogServiceInfo? = nil,
            category: String? = nil,
            parentEvent: Log.GenericEvent? = nil,
            fileId:StaticString = #fileID,
            function:StaticString = #function,
            line:UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                error: error,
                serviceInfo: serviceInfo,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileId:fileId,
                    function:function,
                    line:line
                )
            )
        }
    }
}


public extension Log {
    class StartEvent: GenericEvent {
        public var rawMessage: StaticString
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: StaticString,
            userInfo: LogUserInfo? = nil,
            serviceInfo: LogServiceInfo? = nil,
            level: LogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.rawMessage = message
            super.init(
                id: id,
                timestamp: timestamp,
                "Start: \(message)",
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            _ message: StaticString,
            userInfo: LogUserInfo? = nil,
            serviceInfo: LogServiceInfo? = nil,
            level: LogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileId: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileId: fileId,
                    function: function,
                    line: line
                )
            )
        }
    }
}

public extension Log {
    class EndEvent: GenericEvent {
        public var rawMessage: StaticString
        
        public let startEvent: StartEvent
        
        public let duration: TimeInterval
        
        public let durationFormatted: String
        
        public init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            message: StaticString,
            startEvent: StartEvent,
            userInfo: LogUserInfo? = nil,
            serviceInfo: LogServiceInfo? = nil,
            level: LogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            source: Source
        ) {
            self.rawMessage = message
            self.startEvent = startEvent
            self.duration = timestamp.timeIntervalSince(startEvent.timestamp)
            
            func formatted(_ duration: TimeInterval) -> String {
                if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                    return Measurement(value: duration, unit: UnitDuration.seconds).formatted()
                } else {
                    return "\(duration) s"
                }
            }
            
            self.durationFormatted = formatted(duration)
            
            let message = "End: \(message), duration: \(durationFormatted)"
            super.init(
                id: id,
                timestamp: timestamp,
                message,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: source
            )
        }
        
        public convenience init(
            id: UUID = .init(),
            timestamp: Date = .init(),
            message: StaticString,
            startEvent: StartEvent,
            userInfo: LogUserInfo? = nil,
            serviceInfo: LogServiceInfo? = nil,
            level: LogLevel = .debug,
            category: String? = nil,
            parentEvent: GenericEvent? = nil,
            fileId: StaticString = #fileID,
            function: StaticString = #function,
            line: UInt = #line
        ) {
            self.init(
                id: id,
                timestamp: timestamp,
                message: message,
                startEvent: startEvent,
                userInfo: userInfo,
                serviceInfo: serviceInfo,
                level: level,
                category: category,
                parentEvent: parentEvent,
                source: .init(
                    fileId: fileId,
                    function: function,
                    line: line
                )
            )
        }
    }
}
