//
//  Style.swift
//  nn
//
//  Created by Galina Kanunnikova on 10.12.20.
//

import Foundation
import Foundation
import UIKit
import SwiftUI

public struct Style {
  
    public let rowHeight : CGFloat = 100
    public let headerHeight : CGFloat = 50
    public let timeColumnWidth : CGFloat = UIScreen.screenWidth/15
    public var timeSystem: TimeHourSystem = .twentyFour
    public let lightRed: Color = Color(red: 232 / 255, green: 93 / 255, blue: 97 / 255)
    public init() {}
}



public enum TimeHourSystem: Int {
 
    @available(swift, deprecated: 0.3.6, obsoleted: 0.3.7, renamed: "twentyFour")
    case twentyFourHour = 1
    case twentyFour = 24
    
    var hours: [String] {
            let array = ["00:00"] + Array(1...24).map({ (i) -> String in
                let i = i % 24
                var string = i < 10 ? "0" + "\(i)" : "\(i)"
                string.append(":00")
                return string
            })
            return array
        
    }
    
    public static var currentSystemOnDevice: TimeHourSystem? {
            return .twentyFour
    }
    
    public var format: String {
            return "HH:mm"
    }
}

public extension Date {
    var isSunday: Bool {
        return weekday == 1
    }
    
    var minute: Int {
        let calendar = Calendar.current
        let componet = calendar.dateComponents([.minute], from: self)
        return componet.minute ?? 0
    }
    
    var hour: Int {
        let calendar = Calendar.current
        let componet = calendar.dateComponents([.hour], from: self)
        return componet.hour ?? 0
    }
    
    var day: Int {
        let calendar = Calendar.current
        let componet = calendar.dateComponents([.day], from: self)
        return componet.day ?? 0
    }
    
    var weekday: Int {
        let calendar = Calendar.current
        let componet = calendar.dateComponents([.weekday], from: self)
        return componet.weekday ?? 0
    }
    
    var month: Int {
        let calendar = Calendar.current
        let componet = calendar.dateComponents([.month], from: self)
        return componet.month ?? 0
    }
    
    var monthGerman: String {
        let calendar = Calendar.current
        let componet = calendar.dateComponents([.month], from: self)
        switch componet.month {
        case 1: return "Januar"
        case 2: return "Februar"
        case 3: return "März"
        case 4: return "April"
        case 5: return "Mai"
        case 6: return "Juni"
        case 7: return "Juli"
        case 8: return "August"
        case 9: return "September"
        case 10: return "Oktober"
        case 11: return "November"
        case 12: return "Dezember"
        case .none:
            return ""
        
        case .some(_):
            return ""
        }
         
    }
    
    var year: Int {
        let calendar = Calendar.current
        let componet = calendar.dateComponents([.year], from: self)
        return componet.year ?? 0
    }
    
    var startOfDay: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        return gregorian.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return gregorian.date(byAdding: components, to: startOfDay ?? self)
    }
    
    var startMondayOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = 2
        gregorian.timeZone = TimeZone.current
        var startDate = Date()
        var interval = TimeInterval()
        _ = gregorian.dateInterval(of: .weekOfMonth, start: &startDate, interval: &interval, for: self)
        return startDate
    }
    
    var startSundayOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return sunday
    }
    
    var endSundayOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        return gregorian.date(byAdding: .day, value: 6, to: startMondayOfWeek ?? self)
    }
    
    var endSaturdayOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        return gregorian.date(byAdding: .day, value: 6, to: startSundayOfWeek ?? self)
    }
    
    var startOfMonth: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        return gregorian.date(from: gregorian.dateComponents([.year, .month], from: self))
    }
    
    var endOfMonth: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return gregorian.date(byAdding: components, to: startOfMonth ?? self)
    }
    
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func convertTimeZone(_ initTimeZone: TimeZone, to timeZone: TimeZone) -> Date {
        let value = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        var components = DateComponents()
        components.second = Int(value)
        let date = Calendar.current.date(byAdding: components, to: self)
        return date ?? self
    }
}
