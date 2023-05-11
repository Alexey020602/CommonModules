//
//  RefrashableView.swift
//  RabotaVsem
//
//  Created by Alexey on 10.03.2023.
//

import SwiftUI
import Combine

public enum RefreshState{
    case loaded
    case refreshing
    case loadingNextPage
}
/*
struct RefreshableView<Content:View>: View {
    init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.refreshAction = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .anchorPreference(key: OffsetPreferenceKey.self, value: .top) {
                        geometry[$0].y
                    }
            }
            .onPreferenceChange(OffsetPreferenceKey.self) { offset in
                if offset > threshold {
                    refreshAction()
                }
            }
        }
    }
    
    
    private var content: () -> Content
    private var refreshAction: () -> Void
    private let threshold:CGFloat = 50.0
}

fileprivate struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
*/
/*
struct RefreshableModifier:ViewModifier{
    private let refreshAction:()->Void
    private let threshold:CGFloat = 50.0
    @Binding var state:RefreshState
    @State var startY:Double = .infinity
    init(_ refreshState:Binding<RefreshState>, action refreshAction: @escaping () -> Void) {
        self._state = refreshState
        self.refreshAction = refreshAction
    }
    func body(content: Content) -> some View {
        ScrollView{
            if state == .loaded{
                GeometryReader{ geometry in
                    HStack {
                        Spacer()
                        if geometry.frame(in: .global) .minY - startY > 30{
                            ProgressView()
                                .padding(.top, -30)
                                .animation(.easeInOut)
                                .transition(.opacity)
                                .onAppear{
                                    let noti = UIImpactFeedbackGenerator(style: .light)
                                    noti.prepare()
                                    noti.impactOccurred()
                                    refreshAction()
                                }
                        }
                        Spacer()
                    }
                    .onAppear {
                        startY = geometry.frame(in:.global).minY
                    }
                }
            }
            if state == .refreshing{
                LoaderView()
            }
            content
            if state == .loadingNextPage{
                LoaderView()
            }
        }
    }
}

public extension View{
    func refreshable(_  refreshState:Binding<RefreshState>,action: @escaping () -> Void) -> some View{
        self.modifier(RefreshableModifier(refreshState, action: action))
    }
}
*/
