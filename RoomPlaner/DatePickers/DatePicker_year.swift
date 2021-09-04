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
    var date = Date()

    var body: some View {
        DatePicker(
            "Start Date",
            selection: $dpModel.dateVon,
            in: date...dateToYear(add_years: 3, start_date: dpModel.dateVon),
            displayedComponents: [.date,.hourAndMinute]
        )//.environment(\.locale, Locale.init(identifier: "de"))
    }
}

struct datePicker_year_till: View{
    @ObservedObject  var eventModel : EventModel
    @ObservedObject var dpModel : DatePickerModel

    var body: some View {
        DatePicker(
            "End Date",
            selection: $dpModel.dateBis,
            in : dpModel.dateVon...dateToYear(add_years: 3, start_date: dpModel.dateVon),
            displayedComponents: [.date,.hourAndMinute]
        )
    }
    
}
