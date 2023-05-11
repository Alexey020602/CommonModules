//
//  Injectable.swift
//  Injector
//
//  Created by Alexey on 09.05.2023.
//

import Foundation

public protocol Injectable:AnyObject{
    init(_ serviceCollection:ServiceCollection)
}
public extension Injectable{
    init(){
        self.init(ServiceCollection())
    }
}
