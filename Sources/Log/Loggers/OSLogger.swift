//
//  OSLogger.swift
//  KatharsisFramework
//
//  Created by Alexey on 23.03.2023.
//

import Foundation
import os

public class OSLoger:LoggerProtocol{
    
    let levels:[LogLevel]
    
    public init(levels: [LogLevel]) {
        self.levels = levels
    }
    
    
    public func log(_ event: Log.GenericEvent) {
        osLog(event: event)
    }
    
    public func log(_ event: Log.ErrorEvent) {
        osLog(event: event)
    }
    
    public func logStart(_ event: Log.StartEvent) {
        osLog(event: event)
    }
    
    public func logEnd(_ event: Log.EndEvent) {
        osLog(event: event)
    }
    
    private func osLog(event:Log.GenericEvent){
        guard levels.contains(event.level) else{return}
        
        let data = LogData(from:event)
        
        osLog(data)
    }
    
    func osLog(_ data:LogData){
        let logger = Logger(
            subsystem: data.subsystem,
            category: data.category
        )
        
        logger.log(
            level:data.logType,
            "\(data.message, privacy: .public)"
        )
    }
}


extension OSLoger{
    struct LogData{
        let logType:OSLogType
        let subsystem:String
        let category:String
        let message:String
        
        init(
            logType: OSLogType,
            subsystem: String,
            category: String,
            message: String
        ) {
            self.logType = logType
            self.subsystem = subsystem
            self.category = category
            self.message = message
        }
        
        init(from event:Log.GenericEvent){
            let subsystem = event.source.module
            let category = event.category ?? ""
            
            self.init(
                logType: OSLogType(event.level),
                subsystem: subsystem,
                category: category,
                message: Self.message(from:event)
            )
        }
        
        private static func message(from event:Log.GenericEvent) -> String{
            func source(from event:Log.GenericEvent) -> String{
                let fileWithLine = [event.source.filename, String(event.source.line)].joined(separator: ":")
                
                return [
                "[Source]",
                fileWithLine,
                event.source.function.description
                ].joined(separator: "\n")
            }
            
            func userInfo(from event:Log.GenericEvent) -> String?{
                guard let userInfo = event.userInfo else{return nil}
                
                return [
                "[UserInfo]",
                userInfo.logDescription
                ].joined(separator: "\n")
            }
            
            let message = "\n" + event.message
            
            return [
                message,
                source(from: event),
                userInfo(from: event)
            ]
                .compactMap{$0}
                .joined(separator:"\n\n")
        }
    }
}

extension OSLogType{
    init(_ level:LogLevel){
        switch level {
        case .debug:
            self = .default
        case .info:
            self = .info
        case .warning:
            self = .error
        case .error:
            self = .fault
        }
    }
}
