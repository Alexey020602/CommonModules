//
//  File.swift
//  
//
//  Created by Alexey on 11.05.2023.
//

import SwiftUI

public extension TextField where Label == Text {
    init(_ title:some StringProtocol, text:Binding<String?>) {
        self.init(title, text:Binding<String>(get: {
            text.wrappedValue ?? ""
        }, set: { value in
            if value == ""{
                text.wrappedValue = nil
            } else{
                text.wrappedValue = value
            }
        }))
    }
}
