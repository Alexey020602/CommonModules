//
//  EndEditingView.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 07.04.2023.
//

import SwiftUI

public extension View{
    func endEditing(){
        UIApplication.shared.endEditing()
    }
}

extension UIApplication{
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
