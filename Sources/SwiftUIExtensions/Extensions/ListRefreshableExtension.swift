//
//  ListRefrashableExtension.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 30.03.2023.
//

import SwiftUI
import Log
/*
public struct RefreshableList<Content:View>:View{
    public let style:any ListStyle
    public let content:Content
    public let onRefresh:()->Void
    public init(_ style:any ListStyle = .plain,@ViewBuilder content: () -> Content, onRefresh: @escaping () -> Void) {
        self.style = style
        self.content = content()
        self.onRefresh = onRefresh
    }
    public var body:some View{
        List{
            RefreshView(action: onRefresh)
            content
        }
    }
}

public struct RefreshableScrollView<Content:View>:View{
    let content:Content
    let onRefresh:()->Void
    public init(@ViewBuilder content: () -> Content, onRefresh: @escaping () -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }
    public var body:some View{
        ScrollView{
            RefreshView(action: onRefresh)
                //.background(Color.yellow)
            content
        }
    }
}
*/
struct RefreshView:View{
    let action:()->Void
    private let threshold:CGFloat = 50.0
    @State private var startY:Double = .infinity
    var body: some View{
        GeometryReader{ geometry in
                HStack{
                    Spacer()
                    if geometry.frame(in: .global) .minY - startY > 30{
                        ProgressView()
                            //.padding(.top, -30)
                            .animation(.easeInOut)
                            .transition(.opacity)
                            .onAppear{
                                Log.log("AppearProgressView \(startY)", category: "Представление")
                                let noti = UIImpactFeedbackGenerator(style: .light)
                                noti.prepare()
                                noti.impactOccurred()
                                action()
                            }
                    }
                    Spacer()
            
                }
            
            .onAppear {
                Log.log("AppearHStack \(startY)",category: "Представление")
                startY = geometry.frame(in:.global).minY
            }
            
        }
    }
}

#if DEBUG
struct Sect{
    let list = [
        "Первый",
        "Второй",
        "Третий",
        "Четвертый",
        "Пятый"
        ]
    let title:String
    let footer:String
}
struct Cringe_Preview:PreviewProvider{
    
    static let list:[Sect] = [
        .init(title: "Один", footer: "ОдИн"),
        .init(title: "Два", footer: "ДВА"),
        .init(title: "Три", footer: "ТРИ"),
        .init(title: "Четыре", footer: "ЧЕТЫРЕ")
    ]
    static var previews:some View{
        List{
            ForEach(list, id: \.title){ section in
                Section {
                    ForEach(section.list, id: \.self){
                        Text($0)
                    }
                } header: {
                    Text(section.title)
                } footer: {
                    Text(section.footer)
                }

            }
        }
    }
}
#endif
