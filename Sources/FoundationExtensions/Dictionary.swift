//
// Created by Alexey on 05.02.2023.
//

import Foundation

public extension Dictionary {
    mutating func add(_ items: [Key: Value]) {
        for (key, value) in items{
            self[key] = value
        }
    }
}