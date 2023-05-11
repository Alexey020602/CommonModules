//
//  LoggerProtocol.swift
//  KatharsisFramework
//
//  Created by Alexey on 22.03.2023.
//

import Foundation

public protocol LoggerProtocol{
    func log(_ event:Log.GenericEvent)
    func log(_ event:Log.ErrorEvent)
    func logStart(_ event:Log.StartEvent)
    func logEnd(_ event: Log.EndEvent)
}
