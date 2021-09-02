//
//  DetailedView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 12.01.21.
//

import SwiftUI

struct detailedView: View {
    @ObservedObject var eventModel : EventModel
    var event : EventObj
    @State private var showPopUp = false
    @State private var action : Action = .delete
    
    var body: some View {
        let event =  eventModel.displayDetailView.event
        ZStack {
        
        VStack{
            dV(eventModel: eventModel, event: event!)
            HStack {
                Button(action: {
                    eventModel.showLogIn = true
                    action = .delete
                            }) {
                                Text("Löschen")
                } .foregroundColor(.white)
                .frame(width: 230, height: 40)
                .background(Color.red)
                .cornerRadius(10)
                
                Button(action: {
                     showPopUp.toggle()
                  
                            }) {
                                Text("Bearbeiten")
                } .foregroundColor(.white)
                .frame(width: 230, height: 40)
                .background(Color.green)
                .cornerRadius(10)
                .sheet(isPresented: $showPopUp){
                    popUp(selectedRooms: selectedRooms(r: event!.rooms ), title: event!.title, eventModel: eventModel ,roomModel: eventModel.roomModel, toUpdateStartTime:  event!.date_start.date.stringToDate ,bis: event!.date_end.date.stringToDate, toEditEventId: event!.id)
                        }
                
            }
            Spacer()
        }
            if eventModel.showLogIn  {
                if action  == .delete {  logIn(eventModel: eventModel, action: .delete, event: event!)}
                if action == .update { logIn(eventModel: eventModel, action: .update, event: event!)}
               
            }
            
        }
        .background(Color.white)
        .frame(width: 500, height: 700,alignment: .center)
        .cornerRadius(20)
        .shadow(radius: 20)
        
    }
        
    private func selectedRooms(r: [RoomObj]) -> [Bool] {
        var array : [Bool] = []
        for i in 0...eventModel.roomModel.visibleRooms.count - 1{
            array.append(false)
            for x in 0...r.count - 1{
                if eventModel.roomModel.visibleRooms[i].id == r[x].id {
                    array[i] = true
                }
            }
        }
       
        return array
    }
}

struct dV : View{
    @ObservedObject var eventModel : EventModel
    var event : EventObj
    @Environment(\.colorScheme) var colorScheme
 var body: some View {
    VStack {
    Group{
        HStack{
            Button(action: {
                eventModel.displayDetailView.display.toggle()
            }){
                Image("close")
            }
            .frame(alignment: .leading)
            .foregroundColor(.red)
            
            Spacer()
            
            Text((event.title))
                .frame(alignment: .center)
                .font(.title)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Spacer()
            
            
        }
        .frame(alignment: .top)
        
        Spacer()
        
        Text( eventModel.dayModel.day.ddMMyy)
            .frame(alignment: .center)
            .font(.title)
            .foregroundColor(colorScheme == .dark ? .white : .black)
        Spacer()
    }
        Group {
        HStack{
            Text("Räume") .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            VStack{
                let srooms = event.rooms
                let rooms = eventModel.roomModel.visibleRooms
                ForEach(srooms, id: \.self) { sroom in
                    
                    ForEach(rooms, id: \.self) { room in
                        if room.id == sroom.id {
                            Text(room.name) .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                                    .padding(.bottom,1)
                        }
                    }
                   
                }
            
            }.font(.system(size: 23))
          
        }
        Spacer()
        HStack{
            Text("Von") .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            Text(event.date_start.date.stringToDate.toString) .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
           
        }.frame( height: 40)
        Spacer()
        HStack{
            Text("Bis") .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            Text((event.date_end.date.stringToDate.toString)) .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
             
            
        }.frame( height: 40)
        Spacer()
        HStack{
            Text("gebucht von") .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            Text("\(event.user_id)") .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
           
        }.frame( height: 40)
        }
        
        Spacer()
        
        
    }.padding()
    .onAppear{
        eventModel.showLogIn = false
    }
    
  }
    
}
