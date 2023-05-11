//
//  DependencyInfo.swift
//  Injector
//
//  Created by Alexey on 09.05.2023.
//

import Foundation

extension Array where Element == Any.Type{
    static func == (lhs:Self, rhs:Self) -> Bool{
        for type in lhs{
            if !rhs.contains(where: {type == $0}){return false}
        }
        
        for type in rhs{
            if !lhs.contains(where: {type == $0}){return false}
        }
        return true
    }
}

class DependencyInfo:Hashable{
    static func == (lhs: DependencyInfo, rhs: DependencyInfo) -> Bool {
        lhs.serviceType == rhs.serviceType &&
        lhs.baseTypes == rhs.baseTypes &&
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(String(describing:serviceType))
        for baseType in baseTypes{
            hasher.combine(String(describing: baseType))
        }
        hasher.combine(name)
    }
    init(
        serviceType:Any.Type,
        baseTypes:Array<Any.Type>,
        name:String?,
        type: DependencyType,
        initClouser:@escaping () -> AnyObject
    ){
        self.serviceType = serviceType
        self.baseTypes = baseTypes
        self.name = name
        self.initClouser = initClouser
        switch type{
        case .scope:
            reference = WeakReference()
        case .singleton:
            reference = StrongReference()
        case .transient:
            reference = TrasientReference()
        }
    }
    let serviceType:Any.Type
    let baseTypes:Array<Any.Type>
    let name:String?
    var reference:Reference
    let initClouser:() -> AnyObject
    var value:AnyObject{
        get{
            guard reference.value == nil else {
                return reference.value!
            }
            let value = initClouser()
            reference.value = value
            return value
        }
    }
    
    func fits<T>(_ type:T.Type, name:String?) -> Bool{
        print(String(describing: type))
        print(String(describing: serviceType))
        print(String(describing: baseTypes))
        return (serviceType == type ||
        baseTypes.contains(where: {$0 == type})) &&
        self.name == name
    }
    
}
