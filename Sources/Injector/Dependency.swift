//
//  Dependency.swift
//  Injector
//
//  Created by Alexey on 09.05.2023.
//

import Foundation
@propertyWrapper
public struct Dependency<Value>{
    private let collection:ServiceCollection = .init()
    private var currentValue:Value?
    private let name:String?
    public var wrappedValue:Value{
        mutating get{
            if currentValue == nil{
                currentValue = collection[Value.self, name]
            }
            //print(Value.self)
            //print(currentValue)
            return currentValue!
        }
    }
    public init(_ name:String? = nil){
        self.name = name
    }
}

public extension Dependency where Value:AnyObject{
    
}
