//
//  Reducer.swift
//  Feedback
//
//  Created by Alexey on 13.04.2023.
//

///Преобразователь состояния на основе события
public typealias Reducer<State, Event> = (inout State, Event) -> Void
/// Объединяет несколько Reducer
public func combine<State, Event>(
    _ reducers: Reducer<State, Event>...
) -> Reducer<State, Event> {
    return { state, event in
        for reducer in reducers {
            reducer(&state, event)
        }
    }
}
/// Преобразовывает Reducer<LocalState, LocalEvent> в Reducer<GlobalState, GlobalEvent>
public func pullback<LocalState, GlobalState, LocalEvent, GlobalEvent>(
    _ reducer: @escaping Reducer<LocalState, LocalEvent>,
    value: WritableKeyPath<GlobalState, LocalState>,
    event extract: @escaping (GlobalEvent) -> LocalEvent?
) -> Reducer<GlobalState, GlobalEvent> {
    return { globalState, globalEvent in
        guard let localAction = extract(globalEvent) else {
            return
        }
        reducer(&globalState[keyPath: value], localAction)
    }
}
