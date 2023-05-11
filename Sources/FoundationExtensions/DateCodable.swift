//
//  DateCodable.swift
//  KatharsisFramework
//
//  Created by Alexey on 24.03.2023.
//

import Foundation


/*
public protocol DateCodable{
    func dateTimeNum(_ path:KeyPath<Self, Date?>, prefix:String) -> String?
    func dateTimeString(_ path:KeyPath<Self, Date?>, prefix:String) -> String?
    func dateNum(_ path:KeyPath<Self, Date?>, prefix:String) -> String?
    func dateString(_ path:KeyPath<Self, Date?>, prefix:String) -> String?
}
public extension DateCodable{
    func dateTimeNum(
        _ path:KeyPath<Self, Date?>,
        prefix:String = ""
    ) -> String?{
        guard let date = self[keyPath:path] else {return nil}
        return DateConverter.dateWithNumericMonthWithTime(date, prefix: prefix)
    }
    func dateTimeString(
        _ path:KeyPath<Self, Date?>,
        prefix:String = ""
    ) -> String?{
        guard let date = self[keyPath:path] else {return nil}
        return DateConverter.dateWithNameOfMonthWithTime(date, prefix: prefix)
    }
    func dateNum(
        _ path:KeyPath<Self, Date?>,
        prefix:String = ""
    ) -> String?{
        guard let date = self[keyPath:path] else {return nil}
        return DateConverter.dateWithNumericMonth(date, prefix: prefix)
    }
    func dateString(
        _ path:KeyPath<Self, Date?>,
        prefix:String = ""
    ) -> String?{
        guard let date = self[keyPath:path] else {return nil}
        return DateConverter.dateWithNameOfMonth(date, prefix: prefix)
    }
}
*/
