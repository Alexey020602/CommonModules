//
//  Service.swift
//  RabotaVsem
//
//  Created by Alexey on 12.02.2023.
//

import Foundation


public class ServiceCollection{
    typealias DependencyContainer = Set<DependencyInfo>
    public init(){}
    private static var set:DependencyContainer = .init()
    
    public func registerDependency<T:Injectable>(type:T.Type, as types:[Any.Type], name:String? = nil, dependencyType:DependencyType){
        registerDependency(as: types, name: name, dependencyType: dependencyType, initClouser:T.init)
    }
    
    public func registerDependency<T:AnyObject>(as types:Array<Any.Type>, name:String? = nil, dependencyType:DependencyType, initClouser:@escaping () -> T){
        var types = types
        types.append(T.self)
        let dependencyInfo = DependencyInfo(
            serviceType: T.self,
            baseTypes: types,
            name: name,
            type: dependencyType,
            initClouser: initClouser)
        
        guard !Self.set.contains(dependencyInfo) else{return}
        Self.set.insert(dependencyInfo)
    }
    
    public func registerDependency<T:AnyObject>(name:String? = nil, dependencyType:DependencyType, initClouser:@escaping () -> T){
        let dependencyInfo = DependencyInfo(
            serviceType: T.self,
            baseTypes: [T.self],
            name: name,
            type: dependencyType,
            initClouser:initClouser
        )
        guard !Self.set.contains(dependencyInfo) else{return}
        //let typpeName = String(describing: T.self)
        //print(typpeName)
        Self.set.insert(dependencyInfo)
    }
    public func addSingleton<T:AnyObject>(_ name:String? = nil, as types:Array<Any.Type>, initClouser:  @escaping () -> T){
        //self.addDependency(name: name, type: .singleton, initClouser: initClouser)
        
        self.registerDependency(as: types,name: name, dependencyType: .singleton, initClouser: initClouser)
    }
    public func addSingleton<T:AnyObject>(_ name:String? = nil, initClouser:  @escaping () -> T){
        //self.addDependency(name: name, type: .singleton, initClouser: initClouser)
        
        self.registerDependency(name: name, dependencyType: .singleton, initClouser: initClouser)
    }
    
    public func addTransient<T:AnyObject>(_ name:String? = nil, as types:Array<Any.Type>, initClouser: @escaping () -> T){
        //self.addDependency(name: name, type: .transient, initClouser: initClouser)
        self.registerDependency(as: types, name: name, dependencyType: .transient, initClouser: initClouser)
    }
    
    public func addTransient<T:AnyObject>(_ name:String? = nil, initClouser: @escaping () -> T){
        //self.addDependency(name: name, type: .transient, initClouser: initClouser)
        self.registerDependency(name: name, dependencyType: .transient, initClouser: initClouser)
    }
    
    public func addScope<T:AnyObject>(_ name:String? = nil,as types:Array<Any.Type>, initClouser: @escaping () -> T){
        //self.addDependency(name: name, type: .scope, initClouser: initClouser)
        self.registerDependency(as: types, name: name, dependencyType: .scope, initClouser: initClouser)
    }
    
    public func addScope<T:AnyObject>(_ name:String? = nil, initClouser: @escaping () -> T){
        //self.addDependency(name: name, type: .scope, initClouser: initClouser)
        self.registerDependency(name: name, dependencyType: .scope, initClouser: initClouser)
    }
    
    
    ///Получить зависимость, если тип ясен из контекста
    public subscript<T>(_ name:String? = nil) -> T{
        getDependency(T.self, name)
    }
    ///Получить зависимоть с указанием типа
    public subscript<T>(_ type:T.Type, _ name:String? = nil) -> T{
        getDependency(type, name)
    }
    
    public func getDependency<T>(_ name:String? = nil) -> T{
        getDependency(T.self, name)
    }
    public func getDependency<T>(_ type:T.Type, _ name:String? = nil) -> T{
        if let anyDependency = Self.set.first(where: { $0.fits(type, name: name)})?.value,
           let dependency = anyDependency as? T{
            return dependency
        }else{
            fatalError("Отсутствует зависмость")
        }
    }
    
    private func foundDependency<T>(_ type:T.Type,_ dependencyInfo:DependencyInfo, _ name:String?) -> Bool{
        print("Типы зависимостей: \(String(describing: dependencyInfo.serviceType)) \(String(describing: T.Type.self))")
        let correctType = (dependencyInfo.serviceType as? T.Type) != nil
        let correctName = dependencyInfo.name == name
        return correctType && correctName
    }
}






public enum DependencyType{
    case transient
    case singleton
    case scope
}
/*
 extension DependencyInfo:Hashable{
 
 }
 */

