//
//  PopUpModifier.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 19.04.2023.
//

import SwiftUI

struct PopUpModifier<PopUpContent:View>:ViewModifier{
    @Binding var showed:Bool
    var popUpContent:PopUpContent
    init(isAppear:Binding<Bool>,popUpContent: () -> PopUpContent) {
        self._showed = isAppear
        self.popUpContent = popUpContent()
    }
    func body(content: Content) -> some View {
        ZStack{
            content
            if showed{
                popUpContent
            }
        }
    }
}

public extension View{
    func popUp<PopUpContent:View>(isAppear:Binding<Bool>, popUp:() -> PopUpContent) -> some View{
        self
            .modifier(PopUpModifier(isAppear: isAppear, popUpContent: popUp))
    }
}
