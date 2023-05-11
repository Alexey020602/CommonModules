//
//  NullVisibilityModifier.swift
//  RabotaVsem
//
//  Created by Alexey on 02.03.2023.
//

import SwiftUI

public struct NullVisibilityView<Input, Content:View>:View{
    public let input:Input?
    public let content:(Input) -> Content
    public init(input:Input?, content: @escaping (Input) -> Content) {
        self.input = input
        self.content = content
    }
    public var body: some View {
        if let input = input{
            content(input)
        }
    }
}
public struct NullableView<T,Content:View>:View{
    let content:Content?
    public init(
        _ object:T?,
        @ViewBuilder content:(T) -> Content
    ){
        if let object = object{
            self.content = content(object)
        } else {
            self.content = nil
        }
    }
    public var body: some View{
        if let content = content{
            content
        }
    }
}

public struct NullableText:View{
    let text:String?
    public init(_ text: String?) {
        self.text = text
    }
    public var body: some View{
        if let text = text {
            Text(text)
        }
    }
}


