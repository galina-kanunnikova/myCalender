//
//  DatePickerModel.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 20.01.21.
//

import Foundation
import Combine
import CoreData
import UIKit


class DatePickerModel: ObservableObject {

    @Published  var dateVon : Date = Date()
    @Published  var dateBis : Date = Date()
    @Published  var startMinute = 0
    @Published  var endMinute = 0
    @Published var minutes : [Int] = []
    let range = [0,5,10,15,20,25,30,35,40,45,50,55]
    
    init(){
        for i in range{
            if i >= Date().minute{
                minutes.append(i)
            }
        }
        if minutes.count == 0 {
            minutes = range
        }
        
        for i in range{
            if i > Date().minute{
                startMinute = i
                endMinute = startMinute + 5
                return
            }
        }
        
    }
    
}
