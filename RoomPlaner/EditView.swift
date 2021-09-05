//
//  EditView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 03.09.21.
//

import Foundation
import SwiftUI

struct editView_view: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var eventModel: EventModel
    @Environment(\.colorScheme) var colorScheme
    @State  var title: String = ""
    @State  var dissabled = true
    @State  var new_objects: [String]
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
                
                ForEach(0..<new_objects.count,id: \.self) { i in
                 HStack {
                     Text(new_objects[i])
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .foregroundColor(colorScheme == .dark ? .white : .black)
                       .fixedSize()
                
                    Button("x") {
                        new_objects.remove(at: i)
                        dissabled = (new_objects.count > 0) ?  false  : true
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
                        dissabled = false
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
                eventModel.roomModel.deleteRooms()
                var idx = -1
                for name in  new_objects{
                    idx = idx + 1
                    eventModel.roomModel.saveRoomToLocalStorage(title: name, id: idx)
                }
                eventModel.updateEvents()
                self.presentationMode.wrappedValue.dismiss()
               
             }
            .buttonStyle(MyButtonStyle())
            .disabled(dissabled)
            .padding()
            .foregroundColor(.white)
            .background(style.lightRed)
            .cornerRadius(25)
            .font(.system(size: 20))
            .frame(width:300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .onAppear{dissabled = true }
        }

        
        
    }
}
