//
//  MyButton.swift
//  RabotaVsem
//
//  Created by Alexey on 24.02.2023.
//

import SwiftUI

public struct MyButtonStyle:ButtonStyle{
    public init(){}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.white)
            .padding([.horizontal],30)
            .padding([.vertical], 10)
            .background(Color(0, 227, 152))
            .cornerRadius(7)
    }
    
    
}

public struct MyButton: View {
    let title:String
    let background:Color
    let action:()->Void
    public init(_ title:String, background:Color = Color(0, 227, 152), action: @escaping () -> Void) {
        self.title = title
        self.background = background
        self.action = action
    }
    public var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .padding([.horizontal],30)
                .padding([.vertical], 10)
                .background(background)
                .cornerRadius(7)
        }
    }
}

public struct CustomEditButton:View{
    @Environment(\.editMode) var editMode
    let baseText:String
    let editText:String
    public init(baseText:String, editText:String){
        self.baseText = baseText
        self.editText = editText
    }
    public var body: some View{
        Button{
            editMode?.wrappedValue.toggle()
        } label: {
            Text(editMode?.wrappedValue.isEditing == true ? editText : baseText)
        }
    }
}

#if DEBUG
struct MyButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Button("Text"){
                
            }
        }
        .buttonStyle(MyButtonStyle())
    }
}
#endif
