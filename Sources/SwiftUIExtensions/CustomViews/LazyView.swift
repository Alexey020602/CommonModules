//
//  LazyView.swift
//  RabotaVsem
//
//  Created by Alexey on 01.03.2023.
//

import SwiftUI

public struct LazyView<Content:View>: View {
    let build:() -> Content
    public init(@ViewBuilder build:@escaping () -> Content) {
        self.build = build
    }
    /*
    public init(_ build:@autoclosure @escaping () -> Content) {
        self.build = build
    }
    */
     
    public var body: some View {
        build()
    }
}

#if DEBUG
struct LazyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyView{Text("Превью")}
    }
}
#endif
/*
struct LazyModifier:ViewModifier{
    func body(content: Content) -> some View {
        LazyView{
            content
        }
    }
}
*/
