//
//  LoadingView.swift
//  RabotaVsem
//
//  Created by Alexey on 10.03.2023.
//

import SwiftUI

public struct LoaderView:View{
    public var body: some View{
        HStack{
            Spacer()
            ProgressView()
                .padding(20)
                .animation(.easeInOut)
                .transition(.opacity)
                .onAppear{
                    let noti = UIImpactFeedbackGenerator(style: .light)
                    noti.prepare()
                    noti.impactOccurred()
                }
            Spacer()
        }
    }
}
/*
struct LoadingModifier: ViewModifier {
    @Binding var loadState:LoadDataState
    let action:()->Void
    let refreshAction:()->Void
    @State var startY:Double = .infinity
    init(_ loadState:Binding<LoadDataState>,
         onReload action:@escaping ()->Void,
         onRefresh refreshAction:@escaping ()->Void
    ) {
        self._loadState = loadState
        self.action = action
        self.refreshAction = refreshAction
    }
    func body(content:Content) -> some View {
        switch loadState{
        case .dataLoadSuccessful:
            ScrollView{
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
                content
            }
        case .noInternetConnection:
            NoInternetConnectionScreen(action: action)
        case .noConnectionToServer:
            NoServerConnectionScreen(action: action)
        case .loading:
            LoadScreen()
        case .start:
            EmptyView()
        case .refreshView:
            ScrollView{
                LoaderView()
                content
            }
        case .loadNextPage:
            ScrollView{
                content
                LoaderView()
            }
        @unknown default:
            Text("Неизвестное значение")
        }
    }
}

extension View{
     func loading(_ loadState:Binding<LoadDataState>,
                  onReload:@escaping ()->Void,
                  onRefresh:@escaping ()->Void
     )->some View {
         self.modifier(LoadingModifier(loadState, onReload: onReload, onRefresh: onRefresh))
     }
}

*/
