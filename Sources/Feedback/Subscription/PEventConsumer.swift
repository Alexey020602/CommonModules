//
//  PEventConsumer.swift
//  FeedbackStateMachine
//
//  Created by Alexey on 16.04.2023.
//

import Foundation

public protocol PEventConsumer:AnyObject{
    associatedtype Event
    func addEventToQueue(_ event:Event)
    func unqueueEvents()
}
