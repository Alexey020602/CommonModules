//
// Created by Alexey on 05.02.2023.
//

import Foundation
/**
 Обертка для свойства, позволяющая хранить ссылку на объект только если он храниться где-либо еще, и создающаяя новый когда если этот объект еще нигде не храниться.
 */
@propertyWrapper
public struct WeakContainer<Value:AnyObject> {
    private let valueSource:() -> Value
    private weak var storedValue:Value?
    public var wrappedValue:Value{
        mutating set {
            self.storedValue = newValue
        }
        mutating get {
            if storedValue != nil{
                return self.storedValue!
            }else{
                let newValue = valueSource()
                self.storedValue = newValue
                return newValue
            }
        }
    }
    public var projectedValue:Bool{
        get{
            return self.storedValue != nil
        }
    }
    public init(_ valueSource: @escaping ()->Value){
        self.valueSource = valueSource
    }
}
