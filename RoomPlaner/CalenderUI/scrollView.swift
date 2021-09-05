//
//  scrollView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 06.01.21.
//

import SwiftUI

struct scrollView: View {
    @State var currentTime =  Date()
    @ObservedObject var roomModel : RoomModel
    @ObservedObject var eventModel : EventModel
    
    var body: some View {
    ScrollViewReader { scrollView in
          
        ScrollView {
            ZStack{
                calender(roomModel: roomModel, eventModel: eventModel)
                redLine(roomModel: roomModel)
                .frame(alignment: .top)
                
            }
            
        } .background(Color.gray)
        .frame(width: UIScreen.screenWidth)
       .onAppear {
        let h = self.currentTime.hour
        scrollView.scrollTo(h, anchor: updatePosition(h : h))
                }
        .onReceive(timer) { input in
            let h = self.currentTime.hour
            scrollView.scrollTo(h, anchor: updatePosition(h : h))
                
        }
        .gesture( DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                    
                        if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                            eventModel.dayModel.selectedDay = eventModel.dayModel.selectedDay.nextDay
                            eventModel.updateEvents()
                        }
                        else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                            
                            if  eventModel.dayModel.selectedDay.dayStart.lastDay >=  Date().dayStart{
                                eventModel.dayModel.selectedDay =  eventModel.dayModel.selectedDay.lastDay
                                eventModel.updateEvents()
                            }
                        }
        })

    }
}
    
    private func updatePosition(h: Int) -> UnitPoint{
       
        if  h >= 4 && h <= 19 {
            return .center
        }
        if  h < 4  {
           return .top
        }
        if  h > 19  {
           return .bottom
        }
        return .bottom
    }
    
    
}


