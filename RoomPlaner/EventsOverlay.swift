//
//  EventsOverlay.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 07.01.21.
//

import Foundation
import SwiftUI
import CoreData
import Combine



struct cellEvent: View {
    
    @Environment(\.managedObjectContext) var moc
    @State private var paddingBottom: CGFloat = 0
    @State private var paddingTop: CGFloat = 0
    @State private var color: Color =  style.lightRed
    @ObservedObject var roomModel : RoomModel
    @ObservedObject var eventModel : EventModel
    @State var showTrash = false
    @State var cell : cellForOverlay
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        //let durationInMin = eventModel.eventDuration(event:  cell.event!)
        let from =  cell.event!.date_start.date.stringToDate.hhMM
        let till = cell.event!.date_end.date.stringToDate.hhMM
        VStack{
                HStack{
                    if showTrash == true {
                    Button(action: {
                        eventModel.deleteEvent(event: cell.event!)
                    }){
                        Image("garbage")
                    }
                    Spacer()
                   
                        Text(cell.event!.title)
                       .font(.title)
                        Spacer()
                    }else {
                        Text(cell.event!.title)
                           .font(.title)
                    }
           }
            
            Text(from + " - " + till)
        }.frame(width: roomColumnWidth(rooms: roomModel.visibleRooms.count), height: cell.height)
           .background(color)
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .gesture(
            TapGesture()
                .onEnded { _ in
                    eventModel.displayDetailView.event = cell.event
                    eventModel.displayDetailView.display.toggle()
                }
        )
        .onLongPressGesture {
            showTrash.toggle()
            }
    }
    
}
struct eventsOverlay: View {
    
    @Environment(\.managedObjectContext) var moc
    @State private var paddingBottom: CGFloat = 0
    @State private var paddingTop: CGFloat = 0
    @State private var color: Color =  style.lightRed
    @ObservedObject var roomModel : RoomModel
    @ObservedObject var eventModel : EventModel
    @State var showTrash = false
    
    var body: some View {
       
       return  HStack(spacing: 2) {
        ForEach(roomModel.visibleRooms.indices, id: \.self) { idx in
            if eventModel.eventsAfterRooms.count != 0 {
                 let events = eventModel.eventsAfterRooms[idx]
                 VStack() { // Column
                     
                            if events.count > 0{
                                  ForEach(eventModel.cellsForOverlay[idx],id: \.self) {cell in
                                    
                                    if cell.event != nil {
                                        cellEvent(roomModel: roomModel, eventModel: eventModel, cell: cell)
                                    }else{ //gap
                                       
                                        Text("").frame(width: roomColumnWidth(rooms: roomModel.visibleRooms.count), height: cell.height)
                                            .font(.title)
                                       
                                        }
                                }
                            
                                 
                             }else{
                                calenderCell(roomModel: roomModel).frame(height: 0)
                             }
                   
                    }.padding(.bottom, paddingBottom)
            }
             }
             
       }
    }
    
    
}


