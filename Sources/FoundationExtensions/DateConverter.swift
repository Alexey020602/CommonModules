//
//  DateConverter.swift
//  SocUslugi
//
//  Created by Alexey on 07.12.2022.
//

import Foundation


public extension Date{
    init?(
        string:String,
        options:ISO8601DateFormatter.Options = [
            .withFullDate,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withTime
        ]
    ){
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        guard let date = formatter.date(from: string) else{return nil}
        self = date
    }
    
    func string(dateStyle:DateFormatter.Style, timeStyle:DateFormatter.Style) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    func stringOnlyDate(dateStyle:DateFormatter.Style) -> String{
        return self.string(dateStyle: dateStyle, timeStyle: .none)
    }
    
}

public extension Date{
    func iso86ForRequest() -> String{
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        formatter.formatOptions = [
            .withDay,
            .withMonth,
            .withYear,
            .withDashSeparatorInDate,
            .withTime,
            .withColonSeparatorInTime
        ]
        return formatter.string(from: self)
    }
}

