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
    @State var new_objects: [Room]
    @State private var deleted_objects: [Int16] = []
    @ObservedObject var keyboardResponder = KeyboardResponder()
    var body: some View {
        
        VStack(spacing: 0) {
            VStack(spacing: 0) {
              Spacer()
              Text("add new object").font(.system(size: 20))
                .foregroundColor(colorScheme == .dark ? .white : .black)
              Spacer()
          
              TextField("Objekt Name", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
           ScrollView {
                ForEach(0..<new_objects.count,id: \.self) { i in
                 HStack {
                     Text(new_objects[i].name ?? "" )
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .foregroundColor(colorScheme == .dark ? .white : .black)
                       .fixedSize()
                       .frame(width: 150, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                    Button("x") {
                       
                        for room in eventModel.roomModel.rooms {
                            if room == new_objects[i] {
                                deleted_objects.append(room.id)
                            }
                        }
                        new_objects.remove(at: i)
                        dissabled = (new_objects.count > 0) ?  false  : true
                    }
                      .padding()
                      .foregroundColor(.red)
                      .font(.system(size: 30))
                   }
                 
             // Spacer()
             }
            
           }.padding([], 10).frame(height : style.screenHeight/2.5)
                if new_objects.count < 10 {
                    Button("+") {
                        let new_obj = eventModel.roomModel.create_Room_core_data(title: title, id: new_objects.count)
                        new_objects.append(new_obj)
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
            }
            Button("save") {
                var idx = -1
                for idx in deleted_objects {
                    eventModel.deleteEvents_for_room(index : Int(idx) )
                }
                var names :[String] = []
                for obj in new_objects {
                    names.append(obj.name ?? "")
                }
                eventModel.roomModel.deleteRooms()
                for name in  names{
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
        }.offset(y: keyboardResponder.currentHeight*0.5)

        
        
    }
}
