//
//  DatePickerTill.swift
//  DatePickerTill
//
//  Created by Galina Kanunnikova on 04.09.21.
//

import Foundation
import SwiftUI

struct datePickerTill: View {
    @ObservedObject  var eventModel : EventModel
    @ObservedObject var dpModel : DatePickerModel
    @Environment(\.colorScheme) var colorScheme
    var bis : Date
    var toUpdateStartTime : Date?
    
    var body: some View {
        HStack{
            Text("Bis") .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            myDatePickerTill( dpModel: dpModel, eventModel: eventModel ,from:  dpModel.dateVon, to:dpModel.dateVon.dayEnd)
            
        }
        .onAppear{
           
            if toUpdateStartTime != nil {
                
                dpModel.dateBis = bis
                dpModel.endMinute = bis.minute
                
            }else {
               dpModel.dateBis = dpModel.dateVon
            }
        }
       
  }
}
