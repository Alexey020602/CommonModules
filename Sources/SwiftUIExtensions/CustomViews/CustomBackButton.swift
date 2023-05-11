//
//  CustomBackButton.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 04.04.2023.
//

import SwiftUI

public struct CustomBackButton: View {
    public let action:()->Void
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    public var body: some View {
        Button(action:action){
            Image(systemName:"chevron.backward")
        }
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton{}
    }
}
