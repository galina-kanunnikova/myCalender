//
//  Helper.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 06.01.21.
//

import Foundation
import CoreData
import SwiftUI

let style = Style()
let hours: [String] = style.timeSystem.hours
var calendar : Calendar {
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "de_DE")
    return calendar
}

func roomColumnWidth(rooms: Int) -> CGFloat{
    return  (style.screenWidth - 5 - style.timeColumnWidth)/CGFloat(rooms) //- style.timeColumnWidth/2.5
}


func fullDate(date: Date,min :Int ) -> Date{
    return calendar.date(bySettingHour: date.hour, minute: min, second: 0, of: date)!
}


extension String {
    var stringToDate: Date{
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
       // dateFormatter.timeZone = NSTimeZone(name: timezone) as TimeZone?
        let date = dateFormatter.date(from: self)!
        return date
    }
    
}

extension Date {
    var zeroSeconds: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)!
    }
    var zeroMinutes: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        return calendar.date(from: dateComponents)!
    }

   
    var dayStart: Date {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: self) // eg. 2016-10-10 00:00:00
        return date
    }
    var dateTo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: 1, to: self)
        return (date?.startOfDay)!
    }
    var nextHour: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: 1, to: self)
        return date!
    }
    
    var dateTo30: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: 30, to: dayStart)
        return date!
    }
    var dayEnd: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: 1, to: self)!.dayStart
        let end =  Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)
        return end!
    }
    var lastDay: Date {
        let calendar = Calendar.current
        let last = calendar.date(byAdding: .day, value: -1, to: self)
        return last!
    }
    var dateToString: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    var toString: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
    var hhMM: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    var ddMMyy: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }

    var shortDate: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let someDateTime = formatter.string(from: self)
        return someDateTime
    }

    var ddMM: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM "
        let someDateTime = formatter.string(from: self)
        return someDateTime
    }

    var nextDay: Date {
        let calendar = Calendar.current
        let next = calendar.date(byAdding: .day, value: 1, to: self)
        return next!
    }
    
    
}
extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        
        var count = 0
        for el in other.sorted() {
            for elem in self.sorted() {
                if el == elem {
                    count = count + 1
                    return true
                }
            }
        }
        
        if count == 0 {
            return false
        }
        
        
    }
}
