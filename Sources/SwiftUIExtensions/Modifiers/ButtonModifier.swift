//
//  ButtonModifier.swift
//  RabotaVsem
//
//  Created by Alexey on 01.03.2023.
//

import SwiftUI

///Создает вокруг элемента, к котому применен, Button
///
/// `action` - Действие, выполняемое при нажатии
struct ButtonModifier:ViewModifier{
    let action: () -> Void
    init(
        action: @escaping () -> Void
    ) {
        self.action = action
    }
    func body(content: Content) -> some View {
        Button (action:action, label: {content})
    }
}

public extension View{
    ///Создает вокруг элемента, к котому применен, Button
    ///
    /// `action` - Действие, выполняемое при нажатии
    func button(action:@escaping()->Void) -> some View{
        self.modifier(ButtonModifier(action:action))
    }
}
