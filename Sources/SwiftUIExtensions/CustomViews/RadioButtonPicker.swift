//
//  RadioButtonPicker.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 04.05.2023.
//

import SwiftUI

public struct RadioButtonPicker<Content:View,T, K:Hashable>: View {
    @Binding var selector:T?
    let list:[T]
    let id:KeyPath<T, K>
    let equal: (T, T?) -> Bool
    let content:(T) -> Content
    
    public init(
        selector: Binding<T?>,
        list:[T],
        id:KeyPath<T, K>,
        equal:@escaping (T, T?) -> Bool,
        content: @escaping (T) -> Content
    ) {
        self._selector = selector
        self.list = list
        self.id = id
        self.equal = equal
        self.content = content
    }
    
    public init(
        selector: Binding<T>,
        list:[T],
        id:KeyPath<T, K>,
        equal:@escaping (T, T?) -> Bool,
        content: @escaping (T) -> Content
    ) {
        self._selector = Binding(selector)
        self.list = list
        self.id = id
        self.equal = equal
        self.content = content
    }
    public var body: some View {
        List{
            ForEach(list, id:id) { element in
                HStack{
                    image(isSelected: equal(element,selector))
                        .foregroundColor(.appBlue)
                    content(element)
                }
                .button {
                    selector = element
                }
                .foregroundColor(.black)
            }
        }
    }
    
    @ViewBuilder func image(isSelected:Bool) -> some View{
        if isSelected{
            Image(systemName: "circle.inset.filled")
        } else {
            Image(systemName: "circle")
        }
    }
}



struct RadioButtonPicker_Previews: PreviewProvider {
    static let list = ["iugho", "lidhs", "lksjdgl", "hkjdhlsigd"]
    @State static var selected:String? = "lidhs"
    static var previews: some View {
        RadioButtonPicker(selector: $selected, list: list, id: \.self, equal: == ) { Text($0)}
    }
}
