//
//  EditView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 03.09.21.
//

import Foundation
import SwiftUI

struct editView_view: View {
    @ObservedObject var eventModel = EventModel()
    @Environment(\.colorScheme) var colorScheme
    @State  var title: String = ""
    @State  var new_objects: [String] = []
    var body: some View {
       
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
              Spacer()
              Text("Neues Objekt erstellen").font(.system(size: 20))
                .foregroundColor(colorScheme == .dark ? .white : .black)
              Spacer()
          
              TextField("Objekt Name", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize()
                
                ForEach(0..<eventModel.roomModel.rooms.count,id: \.self) { i in

                 HStack {
                    Text(eventModel.roomModel.rooms[i].name)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .foregroundColor(colorScheme == .dark ? .white : .black)
                       .fixedSize()
                
                    Button("x") {
                        eventModel.roomModel.deleteRoom(id: i)
                    }
                      .padding()
                      .foregroundColor(.red)
                      .font(.system(size: 30))
                   }
                 
             // Spacer()
             }
                if eventModel.roomModel.rooms.count < 10 {
                    Button("+") {
                        new_objects.append(title)
                        title = ""
                     }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .buttonStyle(MyButtonStyle())
                    .clipShape(Circle())
                    .disabled(title == "")
                }
              
              Spacer()
            }.padding(.leading, 100).padding(.trailing, 100)
           
            Button("Speichern") {
                var start_idx = eventModel.roomModel.rooms.count - 2
                for i in 0 ..< new_objects.count{
                    start_idx = start_idx + 1
                    let newObj = RoomObj(id: Int16(start_idx), name: new_objects[i])
                    eventModel.roomModel.saveRoomToLocalStorage(room: newObj)
                  
                }
               
             }
            .buttonStyle(MyButtonStyle())
            .disabled(eventModel.roomModel.rooms.count == 0)
            .padding()
            .foregroundColor(.white)
            .background(style.lightRed)
            .cornerRadius(25)
            .font(.system(size: 20))
            .frame(width:300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
        }

        
        
    }
}
