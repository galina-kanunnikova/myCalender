//
//  DatePickerFrom.swift
//  DatePickerFrom
//
//  Created by Galina Kanunnikova on 04.09.21.
//

import Foundation
import SwiftUI

struct datePickerFrom: View {
    @ObservedObject  var eventModel : EventModel
    @ObservedObject var dpModel : DatePickerModel
    @State private var start = Date()
    var toUpdateStartTime : Date?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        HStack{
            Text(" from ").foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
                myDatePickerFrom ( dpModel: dpModel, eventModel: eventModel ,from:  start, to: dpModel.dateVon.dateTo30)
        }
        .onAppear{
            var d = Date()
            if Date().minute >= 55 {
                d = d.nextHour
                dpModel.dateVon = d
            }
            if toUpdateStartTime != nil {
                dpModel.dateVon = toUpdateStartTime!
                dpModel.startMinute = toUpdateStartTime!.minute
              
            }else{
                dpModel.dateVon = d
            }
            start = d
        }
  }
}
