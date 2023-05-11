//
//  Reference.swift
//  Injector
//
//  Created by Alexey on 09.05.2023.
//

import Foundation

protocol Reference{
    var value:AnyObject?{set get}
}
struct WeakReference:Reference{
    weak var value:AnyObject?
    init(_ value:AnyObject? = nil){
        self.value = value
    }
}

struct StrongReference:Reference{
    var value:AnyObject?
    init(_ value:AnyObject? = nil){
        self.value = value
    }
}

struct TrasientReference:Reference{
    var value:AnyObject?{
        get{nil}
        set{}
    }
}
