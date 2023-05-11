//
// Created by Alexey on 08.02.2023.
//

import Foundation


public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool {
        self == nil
    }
}

extension Optional: CustomStringConvertible {
    public var description: String {
        if self.isNil {
            return "nil"
        } else {
            return String(describing: self!)
        }
    }
}

/*
extension Optional<String>: CustomStringConvertible {
    public var description: String {
        if self != nil {
            return self!;
        } else {
            return "nil";
        }
    }
}*/
