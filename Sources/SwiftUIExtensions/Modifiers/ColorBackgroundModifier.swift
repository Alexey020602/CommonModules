//
//  ColorForSVGImageModifier.swift
//  KatharsisFramework
//
//  Created by Alexey on 16.03.2023.
//

import SwiftUI

public struct ColorBackgroundModifier: ViewModifier{
    private var color:Color
    public init(color: Color) {
        self.color = color
    }
    public func body(content:Content) -> some View {
        ZStack{
            content
                .aspectRatio(contentMode: .fit)
            color.blendMode(.colorDodge)
        }
    }
}


