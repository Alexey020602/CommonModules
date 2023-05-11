//
// Created by Alexey on 09.02.2023.
//

import SwiftUI

struct PaddingTextModifier:ViewModifier{
    func body(content:Content) -> some View{
        content
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
    }
}
public extension View{
    func cellView() -> some View{
        modifier(PaddingTextModifier())
    }
}
