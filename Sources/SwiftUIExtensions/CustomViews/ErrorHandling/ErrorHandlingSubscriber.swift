//
//  ErrorHandlingSubscriber.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 18.04.2023.
//

import Foundation
import Combine
import SwiftUI

public extension Subscribers{
    class ErrorHandlingSubscriber<Input, Failure:Error>:Subscriber, Cancellable{
        public typealias Input = Input
        public typealias Failure = Failure
        
        private let receiveLoadState:(LoadDataState) -> Void
        private var subscription: (any Subscription)?
        private let receiver:(Input) -> Void
        public init(
            receiveLoadState:@escaping (LoadDataState) -> Void,
            receiver:@escaping (Input) -> Void
        ){
            self.receiveLoadState = receiveLoadState
            self.receiver = receiver
        }
        
        public func receive(subscription: Subscription) {
            subscription.request(.unlimited)
            self.subscription = subscription
        }
        
        public func receive(_ input: Input) -> Subscribers.Demand {
            self.receiveLoadState(.dataLoadSuccessful)
            self.receiver(input)
            return .unlimited
        }
        public func receive(completion: Subscribers.Completion<Failure>) {
            self.receiveLoadState(.init(completion: completion))
        }
        
        public func cancel() {
            self.subscription?.cancel()
            self.subscription = nil
        }
    }
}

public extension Publisher{
    func loadStateHandle(
        receiveLoadState:@escaping (LoadDataState) -> Void,
        receiver:@escaping (Output) -> Void
    ) -> AnyCancellable{
        let subscriber = Subscribers.ErrorHandlingSubscriber<Output, Failure>(
            receiveLoadState:receiveLoadState,
            receiver: receiver
        )
        self.subscribe(subscriber)
        return AnyCancellable(subscriber)
    }
}
