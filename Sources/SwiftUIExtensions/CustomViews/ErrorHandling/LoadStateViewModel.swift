//
//  LoadStateViewModel.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 18.04.2023.
//

import Combine
import SwiftUI
//import FeedbackStateMachine

public protocol PLoadStateViewModel:AnyObject{
    associatedtype Failure:Error
    var loadState:LoadDataState{get set}
}
/*
open class LoadStateViewModel<Input>{
    @Published var loadState:LoadDataState = .start
    var bindingLoadState:Binding<LoadDataState>{
        Binding<LoadDataState> {
            self.loadState
        } set: { state in
            self.loadState = state
        }
    }
    private var canellable = Set<AnyCancellable>()
    
    open func loadData<InputPublisher:Publisher>(_ publisher:InputPublisher)
    where InputPublisher.Output == Input, InputPublisher.Failure == Error{
        publisher
//            .errorHandling(loadState: &self.loadState, receiver: self.receiveLoadState)
            .sink(receiveCompletion: { completion in
                self.loadState = .init(completion: completion)
            }, receiveValue: { input in
                self.loadState = .dataLoadSuccessful
                self.receiveInput(input)
            })
            .store(in: &canellable)
    }
    
    let receiveInput:(Input) -> Void
    
    let loadAction:() -> Void
    
    init(
        receiveInput: @escaping (Input) -> Void,
        loadAction:@escaping () -> Void
    ) {
        self.receiveInput = receiveInput
        self.loadAction = loadAction
    }
}
*/
