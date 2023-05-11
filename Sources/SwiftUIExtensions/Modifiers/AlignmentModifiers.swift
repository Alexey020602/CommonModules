//
//  AlignmentModifiers.swift
//  RabotaVsem
//
//  Created by Alexey on 02.03.2023.
//

import SwiftUI
///Выравнивает View в зависимости от указанного стиля выравнивания
public struct AlignmentModifier:ViewModifier{
    ///Перечисление стилей горизонатльного выравнивания элемента
    public enum Alignment{
        ///Выравнивание по левому краю
        case leading
        ///Выравнивание по центру
        case center
        ///Выравнивание по правому кураю
        case trailing
    }
    ///Выравнивание View
    let alignment:Alignment
    public func body(content: Content) -> some View {
        HStack{
            self.addLeadingSpacer(alignment)
            content
            self.addTrailingSpacer(alignment)
        }
    }
    
    ///Создается Spacer слева от View, при подходящем выравнивании
    ///
    /// - Parameters:
    ///  - _ alignment - выравнивание View
    @ViewBuilder private func addLeadingSpacer(_ alignment:Alignment) -> some View{
        if alignment == .trailing || alignment == .center{
            Spacer()
        }
    }
    
    ///Создается Spacer слева от View, при подходящем выравнивании
    ///
    /// - Parameters:
    ///  - _ alignment - выравнивание View
    @ViewBuilder private func addTrailingSpacer(_ alignment:Alignment) -> some View{
        if alignment == .center || alignment == .leading{
            Spacer()
        }
    }
}

public extension View{
    ///Выравнивает View в зависимости от указанного стиля выравнивания
    ///
    /// - Parameters:
    ///  - _ alignment - выравнивание View
    func alignment(_  alignment:AlignmentModifier.Alignment) -> some View{
        self.modifier(AlignmentModifier(alignment: alignment))
    }
}
