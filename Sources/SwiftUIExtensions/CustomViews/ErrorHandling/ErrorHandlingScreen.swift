//
//  ErrorHandlingScreen.swift
//  RabotaVsem
//
//  Created by Alexey on 15.02.2023.
//

import SwiftUI
import Feedback

struct NoServerConnectionScreen:View{
    let message:String
    @State var showAlert:Bool = false
    let action:()->Void
    let sendMailAction:(() -> Void)?
    var body: some View{
        VStack{
            Spacer()
            Spacer()
            Group{
                Image("NoServerConnectionImage")
                Spacer()
                Text("Нет связи с сервером")
                Text("Повторите попытку позднее")
                    .foregroundColor(Color.appDarkGray)
                    .padding(5)
                Image("ReloadImage")
                    .padding(5)
                    .button(action: action)
            }
            Spacer()
            Spacer()
            #if DEBUG
            Text("Посмотреть информацию об ошибке")
                .button {
                    showAlert = true
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Ошибка"),
                          message: Text(message),
                          primaryButton: .default(Text("Сообщить об ошибке")){
                        sendMailAction?()
                    },
                          secondaryButton: .destructive(Text("Назад"))
                    )
                }
             
            Spacer()
            #endif
        }
    }
}

struct NoInternetConnectionScreen:View{
    let action:()->Void
    var body: some View{
        VStack{
            Spacer()
            Spacer()
            Image("NoInternetConnectionImage")
            Spacer()
            Text("Нет соединения с интернетом")
            Text("Проверьте подключение")
                .foregroundColor(Color.appDarkGray)
                .padding(5)
            Image("ReloadImage")
                .padding(5)
                .button(action: action)
            Spacer()
            Spacer()
            Spacer()
        }
    }
}

struct LoadScreen:View{
    var body: some View{
        VStack{
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

#if DEBUG
struct ErrorScreen_Preview:PreviewProvider{
    
    static var previews: some View{
        LoadScreen()
        NoServerConnectionScreen(message: "Сообщение",action: {}, sendMailAction:nil)
        NoInternetConnectionScreen(action: {})
    }
}

#endif
/*
struct ErrorHandlingFeedbackModifier:ViewModifier{
    @ObservedObject var context:Context<LoadDataState, LoadDataEvent>
    
    func body(content: Content) -> some View {
        screen(loadState: loadState, content: content)
            .onAppear{
                context.send(event: .load)
            }
    }
    @ViewBuilder func screen<Content:View>(
        loadState:LoadDataState,
        content:Content
    ) -> some View{
        switch loadState{
        case .dataLoadSuccessful:
            content
        case .noInternetConnection:
            NoInternetConnectionScreen{
                context.send
            }
        case .noConnectionToServer(message: let message):
            NoServerConnectionScreen(message:message,action: action, sendMailAction:sendMailAction)
        case .loading:
            LoadScreen()
        case .start:
            //EmptyView()
            Text("")
        @unknown default:
            Text("Неизвестное значение")
        }
    }
}
*/
struct ErrorHandlingModifier:ViewModifier{
    var loadState:LoadDataState
    let action:()->Void
    let sendMailAction:(()->Void)? = nil
//    init<Input>(_ viewModel:LoadStateViewModel<Input>){
//        self.init(viewModel.bindingLoadState, onReload: viewModel.loadAction)
//    }
    
    init(_ loadState:Binding<LoadDataState>, onReload action:@escaping () -> Void){
        self.init(loadState.wrappedValue, onReload: action)
    }
    
    init(_ loadState:LoadDataState, onReload action:@escaping ()->Void) {
        self.loadState = loadState
        self.action = action
    }
    func body(content: Content) -> some View {
        screen(loadState: loadState, content: content)
            .onAppear(perform: action)
    }
    @ViewBuilder func screen<Content:View>(
        loadState:LoadDataState,
        content:Content
    ) -> some View{
        switch loadState{
        case .dataLoadSuccessful:
            content
        case .noInternetConnection:
            NoInternetConnectionScreen(action: action)
        case .noConnectionToServer(message: let message):
            NoServerConnectionScreen(message:message,action: action, sendMailAction:sendMailAction)
        case .loading:
            LoadScreen()
        case .start:
            //EmptyView()
            Text("")
        @unknown default:
            Text("Неизвестное значение")
        }
    }
}

public extension View{
    func errorHandling(_ loadState:Binding<LoadDataState>, onReload:@escaping ()->Void) -> some View{
        self
            .modifier(ErrorHandlingModifier(loadState, onReload: onReload))
    }
    func errorHandling(_ loadState:LoadDataState, onReload:@escaping ()->Void) -> some View{
        self
            .modifier(ErrorHandlingModifier(loadState, onReload: onReload))
    }
//    func errorHandling<Input>(_ viewModel:LoadStateViewModel<Input>) -> some View{
//        self
//            .modifier(ErrorHandlingModifier(viewModel))
//    }
}
