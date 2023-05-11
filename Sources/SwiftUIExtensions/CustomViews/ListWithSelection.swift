//
//  ListWithSelection.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 04.05.2023.
//

import SwiftUI

public struct ListWithSelection<Selection,  T, K:Hashable, Content:View>: View {
    
    @Binding var selection:Selection
    let list:[T]
    let id:KeyPath<T, K>
    let equal:(T, Selection) -> Bool
    let select:(T) -> Selection
    let content:(T) -> Content
    
    public init(
        selection:Binding<Selection>,
        list: [T],
        id: KeyPath<T, K>,
        equal:@escaping (T, Selection) -> Bool,
        select:@escaping (T) -> Selection,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self._selection = selection
        self.list = list
        self.id = id
        self.equal = equal
        self.select = select
        self.content = content
    }
    
    public var body: some View {
        List{
            ForEach(list, id:id) { element in
                    HStack{
                        content(element)
                        Spacer()
                        if equal(element, selection){
                            Image(systemName: "checkmark")
                                .foregroundColor(.appBlue)
                        }
                    }.button{
                        selection = select(element)
                    }.listRowBackground(equal(element, selection) ? Color.lightBlue : nil)
            }
        }
    }
}

