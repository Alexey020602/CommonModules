//
//  Atomic.swift
//  FeedbackStateMachine
//
//  Created by Alexey on 16.04.2023.
//

import Foundation

import Foundation

///Вполнение операций потокобезопасно
public final class Atomic<Value> {
    private let lock = NSLock()
    private var _value: Value

    /// Потокобезопасный доступ в значению
    public var value: Value {
        get {
            return withValue { $0 }
        }

        set(newValue) {
            swap(newValue)
        }
    }

    
    public init(_ value: Value) {
        _value = value
    }

    /// Потокобезопасно модифицирует переменную
    @discardableResult
    public func modify<Result>(_ action: (inout Value) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }

        return try action(&_value)
    }

    ///Потокобезопасно выполняет действие
    @discardableResult
    public func withValue<Result>(_ action: (Value) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }

        return try action(_value)
    }

    ///Потокобезопасно модифицирует переменную и возвражает старое значение
    @discardableResult
    public func swap(_ newValue: Value) -> Value {
        return modify { (value: inout Value) in
            let oldValue = value
            value = newValue
            return oldValue
        }
    }
}

extension NSLock {
    ///Выполняет действие потокобезопасно
    internal func perform<Result>(_ action: () -> Result) -> Result {
        lock()
        defer { unlock() }

        return action()
    }
}
