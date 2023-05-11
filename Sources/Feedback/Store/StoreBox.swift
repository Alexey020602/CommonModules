//
//  StoreBox.swift
//  FeedbackStateMachine
//
//  Created by Alexey on 01.05.2023.
//

import Foundation
import Combine

internal class RootStoreBox<State, Event>: BaseStoreBox<State, Event> {
    override var state: State{
        subject.value
    }
    
    typealias State = State
    typealias Event = Event
    
    let subject: CurrentValueSubject<State, Never>
    private let eventSubject = PassthroughSubject<Event, Never>()
    
    //private let inputObserver: (Event) -> Void
    private var bag = Set<AnyCancellable>()
    
//    var _current: State {
//        subject.value
//    }
    
//    var publisher: AnyPublisher<State, Never> {
//        subject.eraseToAnyPublisher()
//    }
    
    public init(
        initial: State,
        reducer: @escaping Reducer<State, Event>
    ) {
        self.subject = CurrentValueSubject(initial)
        Publishers.FeedbackPublisher(
            upstream: eventSubject,
            reducer: reducer,
            initialState: initial)
        .sink(receiveValue: { [subject] state in
            subject.send(state)
        })
        .store(in: &bag)
    }
    
    override func send(event: Event) {
        self.eventSubject.send(event)
    }
    
    override func scoped<S, E>(getValue: @escaping (State) -> S, event: @escaping (E) -> Event) -> ScopedStoreBox<State, Event, S, E> {
        ScopedStoreBox<State, Event, S, E>(
            parent: self,
            getValue: getValue,
            event: event
        )
    }
}

internal class ScopedStoreBox<RootState, RootEvent, ScopedState, ScopedEvent>: BaseStoreBox<ScopedState, ScopedEvent>{
    override var state: ScopedState{
        getValue(parent.state)
    }
    private let parent: BaseStoreBox<RootState, RootEvent>
    private let getValue: (RootState) -> ScopedState
    private let eventTransform: (ScopedEvent) -> RootEvent
    
    init(
        parent: BaseStoreBox<RootState, RootEvent>,
        getValue: @escaping (RootState) -> ScopedState,
        event: @escaping (ScopedEvent) -> RootEvent
    ) {
        self.parent = parent
        self.getValue = getValue
        self.eventTransform = event
    }
    
    override func send(event: ScopedEvent) {
        parent.send(event: eventTransform(event))
    }

    override func scoped<S, E>(
        getValue: @escaping (ScopedState) -> S,
        event: @escaping (E) -> ScopedEvent
    ) -> ScopedStoreBox<RootState, RootEvent, S, E> {
        ScopedStoreBox<RootState, RootEvent, S, E>(
            parent: self.parent) { rootState in
                getValue(self.getValue(rootState))
            } event: { e in
                self.eventTransform(event(e))
            }
    }
}

internal class BaseStoreBox<State, Event>:PStoreBox{
    func scoped<S, E>(getValue: @escaping (State) -> S, event: @escaping (E) -> Event) -> BaseStoreBox<S, E> {
        fatalError("Не реализованно")
    }
    
    var state: State{
        fatalError("Не реализованно")
    }
    
    func send(event: Event) {
        fatalError("Не реализованно")
    }
    
    
}


internal protocol PStoreBox {
    associatedtype Event
    associatedtype State
    /// Loop Internal SPI
    var state:State{get}
//    var _current: State { get }
    
//    var publisher: AnyPublisher<State, Never> {get}
    
    func send(event: Event)
    func scoped<S, E>(
        to scope: WritableKeyPath<State, S>,
        event: @escaping (E) -> Event
    ) -> BaseStoreBox<S, E>
    
    func scoped<S, E>(
        getValue: @escaping (State) -> S,
        event: @escaping (E) -> Event
    ) -> BaseStoreBox<S, E>
}

extension PStoreBox{
    func scoped<S, E>(
        to scope: WritableKeyPath<State, S>,
        event: @escaping (E) -> Event
    ) -> BaseStoreBox< S, E>{
        self.scoped(
            getValue: { state in
                return state[keyPath: scope]
            },
            event: event
        )
    }
}

//@inline(never)
//private func subclassMustImplement(function: StaticString = #function) -> Never {
//  fatalError("Subclass must implement `\(function)`.")
//}

