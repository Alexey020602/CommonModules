//
// Created by Alexey on 02.02.2023.
//

import SwiftUI
extension View {
    @ViewBuilder func hidden(_ isHidden: Bool) -> some View {
        if (isHidden) {
            self.hidden()
        } else {
            self
        }
    }

    @ViewBuilder func show(_ isShowen: Bool) -> some View {
        self.hidden(!isShowen)
    }

    func rectReader(_ binding: Binding<CGRect>, in space: CoordinateSpace) -> some View {
        self.background(GeometryReader { (geometry) -> AnyView in
            let rect = geometry.frame(in: space)
            DispatchQueue.main.async {
                binding.wrappedValue = rect
            }
            return AnyView(Rectangle().fill(Color.clear))
        })
    }
}