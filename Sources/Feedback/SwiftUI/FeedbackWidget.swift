//
//  Widget.swift
//  FeedbackStateMachine
//
//  Created by Alexey on 01.05.2023.
//

import SwiftUI

public struct FeedbackWidget<State, Event, Content:View>: View {
    @ObservedObject var context:Context<State, Event>
    let content:(Context<State, Event>) -> Content
    public init(
        store: Store<State, Event>,
        @ViewBuilder content: @escaping (Context<State, Event>) -> Content
    ) {
        self.init(context: store.context, content:content)
    }
    public init(
        context:Context<State, Event>,
        @ViewBuilder content:@escaping (Context<State, Event>) -> Content
    ){
        self.context = context
        self.content = content
    }
    
    public var body: some View {
        content(context)
    }
}
