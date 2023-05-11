//
//  EditModeExtension.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 05.05.2023.
//

import SwiftUI

public extension EditMode{
    mutating func toggle(){
        self =
        self == .active ?
            .inactive :
            .active
    }
}
