//
// Created by Alexey on 01.12.2022.
//

import Foundation
import Combine

///Обертка для свойства, позволяющая сохранять его в UserDefaults
///
///Более подробное описание работы класса
@propertyWrapper
public struct UserDefault<Value> {
    public var wrappedValue: Value{
        get {
            switch Value.self{
            case is NSData.Type,
                 is NSString.Type,
                 is NSNumber.Type,
                 is NSDate.Type,
                 is NSArray.Type,
                 is NSDictionary.Type:
                return container.object(forKey: key) as? Value ?? defaultValue
            default:
                guard let data = container.object(forKey: key) as? Data else{
                    return defaultValue
                }
                guard let valueFromData = NSKeyedUnarchiver.unarchiveObject(with: data) as? Value else{
                    return defaultValue
                }
                //print(authState.lastTokenResponse?.accessToken)
                return valueFromData
            }
        }
        set{
            //debugPrint("UserDefault: Set \(newValue)")
            publisher.send(newValue)
            //print("set UserDefaults of type \(Value.self)")
            if  let optional = newValue as? AnyOptional,
                optional.isNil {
                container.removeObject(forKey: key)
                return
            }
            switch Value.self{
            case is NSData.Type,
                 is NSString.Type,
                 is NSNumber.Type,
                 is NSDate.Type,
                 is NSArray.Type,
                 is NSDictionary.Type:
                container.set(newValue, forKey: key)
            default:
                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) else {
                    //print("Convert AuthState to Data failed")
                    return
                }
                //print(newValue)
                container.set(data, forKey: key)
            }
        }
    }
    private let key: String
    private let defaultValue: Value
    private var container:UserDefaults = .standard
    private var publisher: CurrentValueSubject<Value, Never>!
    public init(key:String, defaultValue:Value, container:UserDefaults = .standard){
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
        self.publisher = CurrentValueSubject<Value, Never>(self.wrappedValue)
    }
    public var projectedValue:AnyPublisher<Value, Never>{
        publisher
                .eraseToAnyPublisher()
    }
}

public extension UserDefault where Value: ExpressibleByNilLiteral{
    public init(key:String, _ container:UserDefaults = .standard){
        self.init(key:key, defaultValue:nil, container:container)
    }
}

