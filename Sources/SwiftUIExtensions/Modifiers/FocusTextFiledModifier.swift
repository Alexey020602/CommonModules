//
//  FocusTextFiledModifier.swift
//  KatharsisFramework
//
//  Created by Alexey on 16.03.2023.
//

import SwiftUI


public protocol FocusStateComplianceProtocol:Hashable{
    static var last:Self{get}
    var next:Self?{get}
}

public extension View {
    func focusedLegacy<T: FocusStateComplianceProtocol>(_ focusedField: Binding<T?>, equals: T) -> some View {
        modifier(FocusModifier(focusedField: focusedField, equals: equals))
    }
}

@available(iOS 14.0, *)
public extension View {
    func focusEditor<T: FocusStateComplianceProtocol>(_ focusedField: Binding<T?>, equals: T) -> some View {
        modifier(FocusModifierTextEditor(focusedField: focusedField, equals: equals))
    }
}

public struct FocusModifierTextEditor<Value: FocusStateComplianceProtocol & Hashable>: ViewModifier {
    @Binding var focusedField: Value?
    var equals: Value
    @State var observer = TextFieldObserver()
    
    public func body(content: Content) -> some View {
        content
            .introspectTextView { tv in
                if focusedField == equals {
                    tv.becomeFirstResponder()
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
              focusedField = equals
            })
    }
}


@propertyWrapper public struct FocusStateLegacy<Value>: DynamicProperty where Value: Hashable {
    @State var form: Value?
    
    public var projectedValue: Binding<Value?> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    public var wrappedValue: Value? {
        get {
            return form
        }
        
        nonmutating set {
            form = newValue
        }
    }
    
    public init(wrappedValue: Value?) {
        self._form = State(initialValue: wrappedValue)
    }
}


class TextFieldObserver: NSObject, UITextFieldDelegate {
    var onReturnTap: () -> () = {}
    weak var forwardToDelegate: UITextFieldDelegate?
    
    @available(iOS 2.0, *)
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        forwardToDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        forwardToDelegate?.textFieldDidBeginEditing?(textField)
    }

    @available(iOS 2.0, *)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        forwardToDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    @available(iOS 2.0, *)
    func textFieldDidEndEditing(_ textField: UITextField) {
        forwardToDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        forwardToDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 2.0, *)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        forwardToDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    @available(iOS 13.0, *)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        forwardToDelegate?.textFieldDidChangeSelection?(textField)
    }

    @available(iOS 2.0, *)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        forwardToDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    @available(iOS 2.0, *)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturnTap()
        return forwardToDelegate?.textFieldShouldReturn?(textField) ?? true
    }
}

public struct FocusModifier<Value: FocusStateComplianceProtocol & Hashable>: ViewModifier {
    @Binding var focusedField: Value?
    var equals: Value
    @State var observer = TextFieldObserver()
    
    public func body(content: Content) -> some View {
        content
            .introspectTextField { tf in
                if !(tf.delegate is TextFieldObserver) {
                    observer.forwardToDelegate = tf.delegate
                    tf.delegate = observer
                }
                
                /// when user taps return we navigate to next responder
                observer.onReturnTap = {
                    focusedField = focusedField?.next ?? Value.last
                }

                /// to show kayboard with `next` or `return`
                if equals.hashValue == Value.last.hashValue {
                    tf.returnKeyType = .done
                } else {
                    tf.returnKeyType = .next
                }
                
                if focusedField == equals {
                    tf.becomeFirstResponder()
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
              focusedField = equals
            })
    }
}
