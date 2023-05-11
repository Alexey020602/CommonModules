//
//  NavigationModifier.swift
//  RabotaVsem
//
//  Created by Alexey on 01.03.2023.
//

import SwiftUI

struct NavigationDefaultModifier<Destination:View>:ViewModifier{
    let inBackground:Bool
    let destination:Destination
    init(
        inBackground:Bool,
        @ViewBuilder destination: () -> Destination
    ) {
        self.inBackground = inBackground
        self.destination = destination()
    }
    func body(content: Content) -> some View {
        if inBackground{
            ZStack{
                content
                NavigationLink {
                    destination
                } label: {
                    EmptyView()
                }.buttonStyle(PlainButtonStyle())
            }
        } else{
            NavigationLink{
                destination
            } label: {
                content
            }
        }
    }
}

struct NavigationBoolModifier<Destination:View>:ViewModifier{
    let inBackground:Bool
    @Binding var isActive:Bool
    let destination:Destination
    init(
        inBackground:Bool,
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) {
        self.inBackground = inBackground
        self._isActive = isActive
        self.destination = destination()
    }
    func body(content:Content) -> some View{
        if inBackground{
            ZStack{
                content
                NavigationLink(isActive: $isActive) {
                    destination
                } label: {
                    EmptyView()
                }.buttonStyle(PlainButtonStyle())
            }
        } else {
            NavigationLink(isActive: $isActive) {
                destination
            } label: {
                content
            }

        }
    }
}

struct NavigationTagModifier<Tag:Hashable, Destination:View>: ViewModifier {
    let inBackground:Bool
    let destination:Destination
    let tag:Tag
    let selection:Binding<Tag?>
    init(
        inBackground:Bool,
        tag:Tag,
        selection:Binding<Tag?>,
        @ViewBuilder destination:() -> Destination
    ){
        self.inBackground = inBackground
        self.tag = tag
        self.selection = selection
        self.destination = destination()
    }
    
    func body(content:Content) -> some View {
        if inBackground{
            ZStack{
                content
                NavigationLink(tag:tag, selection: selection) {
                    destination
                } label: {
                    EmptyView()
                }.opacity(0.0)
            }
        } else {
            NavigationLink(tag: tag, selection: selection) {
                destination
            } label: {
                content
            }

        }

    }
    
    
    
}

public extension View{
    func navigation<Tag:Hashable,Destination:View>(inBackground:Bool = false,tag:Tag, selection:Binding<Tag?>, @ViewBuilder destination:() -> Destination) -> some View{
        self
            .modifier(NavigationTagModifier(inBackground:inBackground, tag: tag, selection: selection, destination: destination))
    }
    func navigation<Destination:View>(inBackground:Bool = false,isActive:Binding<Bool>, @ViewBuilder  destination: () -> Destination) -> some View{
        self
            .modifier(NavigationBoolModifier(inBackground: inBackground, isActive: isActive, destination: destination))
    }
    func navigation<Destination:View>(inBackground:Bool = false, @ViewBuilder destination:() -> Destination) -> some View{
        self.modifier(NavigationDefaultModifier(inBackground:inBackground, destination: destination))
    }
}

