//
//  DatePicker_year.swift
//  DatePicker_year
//
//  Created by Galina Kanunnikova on 04.09.21.
//

import Foundation
import SwiftUI

struct datePicker_year_from: View{
    @ObservedObject var dpModel : DatePickerModel
    @ObservedObject  var eventModel : EventModel
    var start : Date
   
    var body: some View {
        DatePicker(
            "Start Date",
            selection: $dpModel.dateVon,
            in: start...dateToYear(add_years: 3, start_date: dpModel.dateVon),
            displayedComponents: [.date,.hourAndMinute]
        )//.environment(\.locale, Locale.init(identifier: "de"))
            .onAppear{
                dpModel.dateVon = start
            }
    }
}

struct datePicker_year_till: View{
    @ObservedObject  var eventModel : EventModel
    @ObservedObject var dpModel : DatePickerModel
    var to : Date
    var body: some View {
        DatePicker(
            "End Date",
            selection: $dpModel.dateBis,
            in : to...dateToYear(add_years: 3, start_date: dpModel.dateVon),
            displayedComponents: [.date,.hourAndMinute]
        ).onAppear{
            dpModel.dateBis = to
        }
    }
    
}
