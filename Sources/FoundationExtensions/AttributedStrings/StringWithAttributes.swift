//
//  StringWithAttributes.swift
//  FoundationExtensions
//
//  Created by Alexey on 30.03.2023.
//

import Foundation

public struct StringWithAttributes:Hashable, Identifiable{
    public let id = UUID()
    public let string:String
    public let attributes:[NSAttributedString.Key:Any]
    
    public static func == (lhs:StringWithAttributes, rhs:StringWithAttributes)->Bool{
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
