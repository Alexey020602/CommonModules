//
//  LogLevel.swift
//  KatharsisFramework
//
//  Created by Alexey on 22.03.2023.
//

import Foundation

public enum LogLevel:String, CaseIterable{
    case debug,
    info,
    warning,
    error
}

extension Array where Element == LogLevel{
    public static var allCases:[Element]{LogLevel.allCases}
}

extension LogLevel {
    public var icon: String {
        switch self {
        case .debug:
            return "🛠"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        }
    }
}

public protocol LogLevelProvider where Self: Swift.Error {
    var level: LogLevel { get }
}

public extension Swift.Error {
    var level: LogLevel {
        if let levelProvider = self as? LogLevelProvider {
            return levelProvider.level
        } else {
            return .error
        }
    }
}
