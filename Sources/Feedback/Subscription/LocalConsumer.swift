//
//  LocalConsumer.swift
//  FeedbackStateMachine
//
//  Created by Alexey on 16.04.2023.
//

import Foundation
/*
final class LocalConsumer<LocalEvent, Event>:PEventConsumer{
    private let upstream: any PEventConsumer
    private let pull:(LocalEvent) -> Event
    
    init(
        upstream: any PEventConsumer,
        pull: @escaping (LocalEvent) -> Event
    ) {
        self.upstream = upstream
        self.pull = pull
    }
    
    func addEventToQueue(_ event: LocalEvent) {
        self.upstream.addEventToQueue(pull(event))
    }
    
    func unqueueEvents() {
        self.upstream.unqueueEvents()
    }
}
*/
