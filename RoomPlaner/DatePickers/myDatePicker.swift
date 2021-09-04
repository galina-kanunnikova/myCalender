//
//  myDatePicker.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 20.01.21.
//

import SwiftUI

let minutes = [0,5,10,15,20,25,30,35,40,45,50,55]
struct myDatePickerFrom: View {
 
    @ObservedObject var dpModel : DatePickerModel
    @ObservedObject  var eventModel : EventModel
    var from : Date
    var to : Date
    var body: some View {
        HStack{
           
            DatePicker( "", selection: $dpModel.dateVon, in: from...to )
                .datePickerStyle(WheelDatePickerStyle())
                .frame(width: 240, height: 200,alignment: .leading)
                .clipped()
                .environment(\.locale, Locale.init(identifier: "de"))
            
            Picker("", selection: $dpModel.startMinute) {
                if  dpModel.dateVon.zeroMinutes == from.zeroMinutes && dpModel.dateVon.minute < 55{
                                ForEach(minutes, id: \.self) { minute in
                                    if minute >= dpModel.dateVon.minute {
                                    Text(minute == 0 ? " : 0\(minute)" : " : \(minute)")
                                    }
                                }
                }else {
                    ForEach(minutes, id: \.self) { minute in
                        Text(minute == 0 ? " : 0\(minute)" : " : \(minute)")
                    }
                    
                }
                if  dpModel.dateVon.zeroMinutes > from.zeroMinutes {
                                ForEach(minutes, id: \.self) { minute in
                                    Text(minute == 0 ? " : 0\(minute)" : " : \(minute)")
                                }
                }
                             
            }.frame(width: 45,height: 200).clipped()
        }
       
            
    }
}

struct myDatePickerTill: View {
   
    @ObservedObject var dpModel : DatePickerModel
    @ObservedObject  var eventModel : EventModel
    var from : Date
    var to : Date

    var body: some View {
        
        HStack{
                   
             if  dpModel.startMinute < 55 {
                    
                DatePicker( "", selection: $dpModel.dateBis, in: from...to )
                 .datePickerStyle(WheelDatePickerStyle())
                 .frame(width: 240, height: 200,alignment: .leading)
                 .clipped()
                 .environment(\.locale, Locale.init(identifier: "de"))
                  .onChange (of: from, perform: { (value) in
                    dpModel.dateBis =  value
                    })
            
                Picker("", selection: $dpModel.endMinute) {
                    if  dpModel.dateVon.zeroMinutes == dpModel.dateBis.zeroMinutes {
                                    ForEach(minutes, id: \.self) { minute in
                                    
                                        if minute > dpModel.startMinute {
                                        Text(minute == 0 ? " : 0\(minute)" : " : \(minute)")
                                        }
                       
                                    }
                    }else {
                        ForEach(minutes, id: \.self) { minute in
                        
                            Text(minute == 0 ? " : 0\(minute)" : " : \(minute)")
                           
                        }
                    }
                }.frame(width: 45,height: 200).clipped()
               
                
             }else {
                    DatePicker( "", selection: $dpModel.dateBis, in: from.nextHour...to )
                     .datePickerStyle(WheelDatePickerStyle())
                     .frame(width: 240, height: 200,alignment: .leading)
                     .clipped()
                     .environment(\.locale, Locale.init(identifier: "de"))
                     .onChange (of: from.nextHour, perform: { (value) in
                        dpModel.dateBis =  value
                          })
                     .onAppear{
                        dpModel.dateBis =  from.nextHour
                        }
                
                    Picker("", selection: $dpModel.endMinute) {
                                        ForEach(minutes, id: \.self) { minute in
                                            Text(minute == 0 ? " : 0\(minute)" : " : \(minute)")
                                        }
                                     
                    }.frame(width: 45,height: 200).clipped()
                    
                    
                }
        }
            
    }
}

