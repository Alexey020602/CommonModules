//
//  NSAttributedStringExtension.swift
//  FoundationExtensions
//
//  Created by Alexey on 30.03.2023.
//

import Foundation

public extension NSAttributedString{
    var stringWithAttributes:[StringWithAttributes]{
        var stringsWithAttributes = [StringWithAttributes]()
        self.enumerateAttributes(in: NSRange(location: 0, length: self.length)) { attributes, range, _ in
            let string = self.attributedSubstring(from: range).string
            stringsWithAttributes.append(StringWithAttributes(string: string, attributes: attributes))
        }
        return stringsWithAttributes
    }
}
