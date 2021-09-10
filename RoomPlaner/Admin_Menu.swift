//
//  MenuView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 24.02.21.
//

import SwiftUI
import CoreData
/*
struct admin_menu: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject  var roomModel : RoomModel
    @ObservedObject  var eventModel : EventModel
    @ObservedObject  var apiModel = APIModel()
    @State private var url: String = ""
    @State private var disabled = true
    @State private var showSaveBtn = true
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
    ZStack{
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    
                    
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image("close")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
                Spacer()
            }
           
        Group {
            HStack{
                Spacer()
                Text("base Url") .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                TextField("url", text: $url).foregroundColor(colorScheme == .dark ? .white : .black).disabled(disabled)
               // Text("\((apiModel.api?.baseUrl)!)") .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .onAppear{
                        url = (apiModel.api?.baseUrl)!
                    }
                Button(action: {
                    disabled.toggle()
                }){
                    Image("pencil")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
                if disabled == false{
                    Button(action: {
                        disabled.toggle()
                        apiModel.save(key:"baseUrl", url: url)
                    }){
                        Text("Ok").background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.8)))
                    }
                }
            }
           
            Spacer()
            
            HStack{
                Spacer()
                Text("available Rooms") .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text("\(APIPath.availableRooms.rawValue)") .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                Button(action: {
                   
                }){
                    Image("pencil")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
            }
            Spacer()
            HStack{
                Spacer()
                Text("appointments for room") .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text("\(APIPath.appointmentsForRoom.rawValue)") .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                Button(action: {
                
                }){
                    Image("pencil")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
            }
            Spacer()
            HStack{
                Spacer()
                Text("details for room") .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text("\(APIPath.detailsForRoom.rawValue)") .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                Button(action: {
                   
                }){
                    Image("pencil")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
            }
            Spacer()
           
        }
        Group {
            HStack{
                Spacer()
                Text("delete appointment") .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text("\(APIPath.deleteAppointment.rawValue)") .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                Button(action: {
                   
                }){
                    Image("pencil")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
            }
            Spacer()
            HStack{
                Spacer()
                Text("authentication") .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text("\(APIPath.auth.rawValue)") .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                Button(action: {
                   
                }){
                    Image("pencil")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
            }
            Spacer()
            HStack{
                Spacer()
                Text("update appointment") .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text("\(APIPathPOST.updateAppointment.rawValue)") .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                Button(action: {
                   
                }){
                    Image("pencil")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
            }
            Spacer()
            HStack{
                Spacer()
                Text("create appointment") .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text("\(APIPathPOST.createAppointment.rawValue)") .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                Button(action: {
                   
                }){
                    Image("pencil")
                }
                .frame(alignment: .leading)
                .foregroundColor(.red)
            }
            Spacer()
            
            toShowRooms(roomModel: roomModel, eventModel: eventModel, isOn: selected(), selectedRooms: roomModel.rooms)
            Spacer()
         }
           
        }
        .background(Color.white)
        .frame(width: 690, height: 950,alignment: .center)
        .cornerRadius(20)
        .shadow(radius: 20)
        
    }
      
  }
    private func selected () -> [Bool]{
        var ar :[Bool] = []
        for i in 0...roomModel.rooms.count - 1 {
            if i <= roomModel.rooms.count - 1 {
            if roomModel.rooms[i].id == roomModel.rooms[i].id{
                ar.append(true)
            }else{ar.append(false)}
            }else {ar.append(false)}
        }
        return ar
    }
   
}

struct toShowRooms: View {
    @ObservedObject  var roomModel : RoomModel
    @ObservedObject  var eventModel : EventModel
    @State  var isOn : [Bool]
    @State  var selectedRooms : [RoomObj?]
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
       
    HStack{
        Text("Objects") .foregroundColor(colorScheme == .dark ? .white : .black)
        Spacer()
        VStack{
            ForEach(0..<roomModel.rooms.count,id: \.self) { i in
                HStack{
                    Toggle(roomModel.rooms[i].name!,isOn: $isOn[i]).padding()
                        .onReceive([self.isOn[i]].publisher.first()) { (value) in
                            if value == true {
                                selectedRooms[i] = roomModel.rooms[i]
                            }else {
                                selectedRooms[i] = nil
                            }
                           
                           }
                        
                    Text(roomModel.rooms[i].name!) .foregroundColor(colorScheme == .dark ? .white : .black)
                        .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                }
                
            }
            
        }.font(.system(size: 23))
        
     }
    .onDisappear{
        var rooms:[Room] = []
        for room in selectedRooms {
            if room != nil {
                rooms.append(room!)
            }
        }
        roomModel.saveRooms(rooms: rooms)
        eventModel.updateEvents()

    }
  }
    
}
*/
