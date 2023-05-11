//
//  FeedbackPublisher.swift
//  FeedbackStateMachine
//
//  Created by Alexey on 16.04.2023.
//
import Combine
public extension Publishers{
    class FeedbackPublisher<State, Event, Upstream:Publisher>:Publisher where Upstream.Output == Event, Upstream.Failure == Never{
        public typealias Output = State
        public typealias Failure = Never
        let upstream:Upstream
        var state:State
        let reducer:Reducer<State, Event>
        
        init(upstream: Upstream, reducer: @escaping Reducer<State, Event>,initialState: State) {
            self.upstream = upstream
            self.reducer = reducer
            self.state = initialState
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, State == S.Input {
            upstream
                .print("FeedbackPublisher")
                .map { event in
                    //debugPrint("\(self.state) \(event)")
                    self.reducer(&self.state, event)
                    //debugPrint("\(self.state) \(event)")
                    return self.state
                }
                .receive(subscriber: subscriber)
        }
    }
}


public extension Publisher where Failure == Never{
    func eventPublisher<State>(
        initialState:State,
        reducer:@escaping Reducer<State, Output>
    ) -> Publishers.FeedbackPublisher<State, Output, Self>{
        .init(upstream: self, reducer: reducer, initialState: initialState)
    }
}


