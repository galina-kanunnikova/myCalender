//
//  Calender.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 07.01.21.
//

import Foundation
import SwiftUI

struct calender: View{
    @ObservedObject var roomModel : RoomModel
    @ObservedObject var eventModel : EventModel
    
    var body: some View {
        HStack(spacing: 1) {
            
           TimeColumn()
            ZStack{
                HStack() {
                    ForEach(0..<roomModel.rooms.count,id: \.self) {roomIdx in
                    
                    VStack(spacing: 1) {
                        ForEach(0..<hours.count-1 ) {hour in
                            
                            calenderCell(roomModel: roomModel)
                        }
                    }
                }
              }
                eventsOverlay(roomModel: roomModel, eventModel: eventModel)
         }
      } .frame(width: UIScreen.screenWidth )
   }
    
}
