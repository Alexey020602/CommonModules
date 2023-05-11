//
//  DictionaryExtension.swift
//  KatharsisFramework
//
//  Created by Alexey on 23.03.2023.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    var logDescription: String {
        guard JSONSerialization.isValidJSONObject(self),
            let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                       options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .utf8)
            else { return String(describing: self) }
        
        return jsonString
    }
}
