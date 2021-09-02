
//  Created by Galina Kanunnikova on 10.12.20.
//

import SwiftUI
import Foundation
import UIKit
import CoreData



let oneMinHeight : CGFloat = style.rowHeight/60

struct currentTimeView: View {
    var currentTime: Date

        init(_ currentTime: Date) {
            self.currentTime = currentTime
        }
    
    var body: some View {
        Text("\(currentTime.hhMM)")
    }
    
}


struct TimeColumn: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<hours.count-1 ,id: \.self) { idx in
                    HStack() {
                            Text("\(hours[idx])")
                                .font(.system(size: 12))
                               // .foregroundColor(colorScheme == .dark ? .white : .black)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .frame(width: style.timeColumnWidth, height: style.rowHeight - 2, alignment: .top)
                   // .background(Color.white)
                    .background(Color(UIColor.systemBackground))
                    .offset(x: 0, y: 0)
                    
                    Text("")
                    .frame(width: style.timeColumnWidth, height: 2)
                    .background(Color(UIColor.systemBackground))
            }
        }
    }
    
}


struct Header: View {
    @ObservedObject var roomModel : RoomModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showPopUp = false
    var body: some View {
        HStack(spacing: 2) {
            Button(action: {
                showPopUp = true 
            }) {
                Image("calender-50")
            }
            .frame(width: style.timeColumnWidth, height: style.headerHeight)
            .sheet(isPresented: $showPopUp){
                yearPicker()
                    }
           
            
          /*  Text("")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .font(.largeTitle)
                .frame(width: style.timeColumnWidth, height: style.headerHeight)
                .background(Color.white)
               
            */
            ForEach(roomModel.visibleRooms, id: \.self) { room in
                Text("\(room.name)")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.largeTitle)
                    .frame(width: roomColumnWidth(rooms: roomModel.visibleRooms.count)-1 , height: style.headerHeight)
                   // .background(Color.white)
                    .background(Color(UIColor.systemBackground))
                    .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                               print("taped")
                            }
                    )
            }
            
        }.frame(width: style.screenWidth, height: 80)
    }
    
}

struct daysView: View {
    @ObservedObject var dayModel : DayModel
    @ObservedObject var eventModel : EventModel
    @Environment(\.colorScheme) var colorScheme
   
    var body: some View {
       
        VStack{
            HStack{
                Text( dayModel.day.shortDate)
                     .frame(alignment: .leading)
                     .font(.system(size: 20))
                     .font(.largeTitle)
                     .foregroundColor(colorScheme == .dark ? .white : .black)
                     .padding(.leading, 20)
                    
                Spacer()
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack(spacing: 20) {
                    let ar = calculateDayArray(start: Date())
                    ForEach(ar, id: \.self) { day in
                       
                        Button(action: {
                            dayModel.day = day
                            eventModel.updateEvents()
                        }){
                            Text(day.ddMM)
                        }
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                              //  .background(Color.white)
                        .background(day.ddMM == dayModel.day.ddMM ? Color.red : Color.white)
                                .cornerRadius(23)
                                .font(.system(size: 15))
                     
                        
                    }
                 
               }
            } .padding([.leading,.bottom], 10)
        
        }  .background(RoundedRectangle(cornerRadius: 0).fill(Color.gray.opacity(0.2)))
    }
}
private func calculateDayArray(start: Date) -> [Date]{
    var ar : [Date] = []
    var day = start
    ar.append(start)
    for i in 0...29{
        ar.append(day.nextDay)
        day = day.nextDay
    }
    return ar
    
}

let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

struct newEventBtn: View {
    @State private var showPopUp = false
    @ObservedObject var eventModel : EventModel
    var body: some View {
        Button(action: {
            showPopUp.toggle()
                    }) {
                        Text("Raum reservieren")
                    }
        .sheet(isPresented: $showPopUp){
            popUp(selectedRooms: [false,false,false], title: "", eventModel: eventModel,roomModel: eventModel.roomModel,toUpdateStartTime: nil ,bis:Date())
                }
        .foregroundColor(.white)
        .frame(width: 300, height: 40)
        .background(Color.green)
        .cornerRadius(10)
    }
}


struct DayView: View {
    @ObservedObject var eventModel = EventModel()
   
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Header(roomModel: eventModel.roomModel)
                daysView(dayModel: eventModel.dayModel, eventModel: eventModel)
                scrollView(roomModel: eventModel.roomModel, eventModel: eventModel)
                Spacer()
                newEventBtn(eventModel: eventModel)
                Spacer()
            }
           
            if eventModel.displayDetailView.display == true {
                detailedView(eventModel: eventModel, event: eventModel.displayDetailView.event!)
            }
              
        }
        
    }
   
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
       
            DayView()
                .previewLayout(.fixed(width: 1024, height: 768))
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

