//
//  OptionalBindingOperator.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 06.05.2023.
//

import SwiftUI

public func ??<T>(lhs: Binding<T?>, rhs: T) -> Binding<T>{
    Binding{lhs.wrappedValue ?? rhs
    } set: { lhs.wrappedValue = $0}
}
