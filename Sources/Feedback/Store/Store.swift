//
//  Store.swift
//  FeedbackStateMachine
//
//  Created by Alexey on 01.05.2023.
//

import Foundation
import Combine

open class LocalStore<RootState, RootEvent, LocalState, LocalEvent>:BaseStore<LocalState, LocalEvent>{
    private let rootStore: BaseStore<RootState, RootEvent>
    private let convertState:(RootState) -> LocalState
    private let convertEvent:(LocalEvent) -> RootEvent
    private var bag = Set<AnyCancellable>()
    
    init(
        rootStore: BaseStore<RootState, RootEvent>,
        convertState: @escaping (RootState) -> LocalState,
        convertEvent: @escaping (LocalEvent) -> RootEvent
    ) {
        self.rootStore = rootStore
        self.convertState = convertState
        self.convertEvent = convertEvent
        super.init(state: convertState(rootStore.state))
        rootStore.$state.map(convertState)
            .assign(to: &self.$state)
    }
    
    override open func send(_ event: LocalEvent) {
        rootStore.send(convertEvent(event))
    }
//    override func mutate(with mutation: Mutation<LocalState>) {
//        rootStore.mutate(with: Mutation<RootState>(mutate: <#T##(inout RootState) -> Void#>))
//    }
}

open class Store<State, Event>:BaseStore<State, Event>{
    //public private(set) override var state: State
    private let eventSubject = PassthroughSubject<Update, Never>()
    private var bag = Set<AnyCancellable>()
    
    public init(
        initial: State,
        reducer: @escaping Reducer<State, Event>
    ) {
        super.init(state: initial)
        Publishers.FeedbackPublisher(
            upstream: eventSubject,
            reducer: { state, update in
                switch update {
                case .event(let event):
                    reducer(&state, event)
                case .mutation(let mutation):
                    mutation.mutate(&state)
                }
            },
            initialState: initial
        )
        .receive(on: DispatchQueue.main)
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    open override func send(_ event: Event) {
        self.eventSubject.send(.event(event))
    }
    
    open override func mutate<V>(keyPath: WritableKeyPath<State, V>, value: V) {
        self.eventSubject.send(.mutation(Mutation(keyPath: keyPath, value: value)))
    }
    
    override func mutate(with mutation: Mutation<State>) {
        self.eventSubject.send(.mutation(mutation))
    }
    
    
}

open class BaseStore<State, Event>{
    @Published public fileprivate(set) var state:State
    
    init(state: State) {
        self.state = state
    }
    
    var context: Context<State, Event> {
        return Context(store: self)
    }
    
    open func send(_ event: Event) {fatalError("Не реализованно")}
    
    open func mutate<V>(keyPath: WritableKeyPath<State, V>, value: V) {fatalError("Не реализованно")}
    
    func mutate(with mutation: Mutation<State>) {fatalError("Не реализованно")}
    
    func scoped<S, E>(
        getValue:@escaping (State) -> S,
        event:@escaping (E) -> Event
    ) -> LocalStore<State, Event, S, E>{
        LocalStore(
            rootStore: self,
            convertState: getValue,
            convertEvent: event)
    }
    fileprivate enum Update {
        case event(Event)
        case mutation(Mutation<State>)
    }
}

public struct Mutation<State> {
    let mutate: (inout State) -> Void
    
    init<V>(keyPath: WritableKeyPath<State, V>, value: V) {
        self.mutate = { state in
            state[keyPath: keyPath] = value
        }
    }
    
    init(mutate: @escaping (inout State) -> Void) {
        self.mutate = mutate
    }
}
//extension Feedback {
//    func mapEvent<U>(_ f: @escaping (Event) -> U) -> Feedback<State, U> {
//        return Feedback<State, U>(events: { state -> AnyPublisher<U, Never> in
//            self.events(state).map(f).eraseToAnyPublisher()
//        })
//    }
//
//    static var input: (feedback: Feedback, observer: (Event) -> Void) {
//        let subject = PassthroughSubject<Event, Never>()
//        let feedback = Feedback(events: { _ in
//            return subject
//        })
//        return (feedback, subject.send)
//    }
//}

//open class ScopenStore<RootState, RootEvent, LocalState, LocalEvent>:Store<LocalState, LocalEvent>{
//    private let parentStore:Store<RootState, RootEvent>
//    private let getValue:(RootState) -> LocalState
//    private let eventTransform:(LocalEvent) -> RootEvent
//
//
//    override public init(initial: LocalState, reducer: @escaping Reducer<LocalState, LocalEvent>) {
//
//    }
//
//    init(
//        parentStore: Store<RootState, RootEvent>,
//        getValue: @escaping (RootState) -> LocalState,
//        eventTransform: @escaping (LocalEvent) -> RootEvent
//    ) {
//        self.parentStore = parentStore
//        self.getValue = getValue
//        self.eventTransform = eventTransform
//
//    }
//
//    convenience init(
//        parentStore: Store<RootState, RootEvent>,
//        path: WritableKeyPath<RootState, LocalState>,
//        eventTransform: @escaping (LocalEvent) -> RootEvent
//    ){
//        self.init(
//            parentStore: parentStore,
//            getValue: { rootState in
//                rootState[keyPath: path]
//            },
//            eventTransform: eventTransform
//        )
//    }
//
//    override open func send(_ event: LocalEvent) {
//
//    }
//}

extension Array {
    func appending(_ element: Element) -> [Element] {
        var copy = self

        copy.append(element)

        return copy
    }
}
