//
//  Token.swift
//  FeedbackStateMachine
//
//  Created by Alexey on 16.04.2023.
//

import Foundation

struct TokenizedEvent<Event>:Equatable{
    static func == (lhs: TokenizedEvent<Event>, rhs: TokenizedEvent<Event>) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let event:Event
}
