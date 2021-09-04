//
//  PopUp.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 05.01.21.
//

import SwiftUI

struct popUp: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @State var selectedRooms : [Bool] 
    @State  var title: String
    @State  var description: String
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @Environment(\.managedObjectContext) private var viewContext
    @State var showingAlert = false
    @State var activeAlert: ActiveAlert = .first
    @ObservedObject  var eventModel : EventModel
    @ObservedObject  var roomModel : RoomModel
    @ObservedObject var dpModel = DatePickerModel()
    var toUpdateStartTime : Date?
    var bis : Date
    @State  var toEditEventId : Int?
    @State  var showMenu  = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Abbrechen")
                    })
                    .frame(alignment: .leading)
                    .foregroundColor(.red)
                    
                    Spacer()
                    Text("Ereignis") .frame(alignment: .center).foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    
                    if eventModel.isAdmin == true {
                        Button(action: {
                            showMenu = true
                        }, label: {
                            Text("Menü")
                        })
                        .frame(alignment: .trailing)
                        .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                  if toEditEventId == nil {
                        
                    Button(action: {
                        checkRools(id: nil)
                        
                    }, label: {
                        Text("Reservieren")
                    })
                   
                    .frame(alignment: .trailing)
                    .foregroundColor(.red)
                    .alert(isPresented: $showingAlert) {
                        alert()
                    }
                        
                  }else {
                    Button(action: {
                        checkRools(id: toEditEventId)
                    }, label: {
                        Text("Änderungen speichern")
                    })
                    .frame(alignment: .trailing)
                    .foregroundColor(.red)
                    .alert(isPresented: $showingAlert) {
                       alert()
                    }
                    
                    }
                }
                .frame(alignment: .top)
                
                Spacer()
                VStack {
                Text("Reserviert von:") .foregroundColor(colorScheme == .dark ? .white : .black)
                TextField("Name", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? .white : .black)
               
                Text("Beschriebung:") .foregroundColor(colorScheme == .dark ? .white : .black)
             
                TextField("Text", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(height: 50)
                }
                Spacer()
                HStack{
                    Text("Raum auswählen") .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    ScrollView {
                    VStack{
                        ForEach(0..<roomModel.rooms.count,id: \.self) { i in
                            HStack{
                                Toggle(isOn: $selectedRooms[i]) {
                                            }.padding()
                                
                                Text(roomModel.rooms[i].name) .foregroundColor(colorScheme == .dark ? .white : .black)
                                   // .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                            }
                            
                        }
                        
                    }.font(.system(size: 23))
                  }.frame(height: 250)
                }
                Spacer()
               // datePickerFrom(eventModel: eventModel, dpModel: dpModel)
                datePicker_year_from(dpModel: dpModel, eventModel: eventModel)
                Spacer()
                datePicker_year_till(eventModel: eventModel, dpModel: dpModel)
               // datePickerTill(eventModel: eventModel, dpModel: dpModel, bis: bis)
                Spacer()
                
            }.padding()
            
         /*   if eventModel.showLogIn == true {
                logIn(eventModel: eventModel , action: .login )
            }*/
            if showMenu == true {
                menu(roomModel: roomModel, eventModel: eventModel)
            }
            
        }
        .cornerRadius(20).shadow(radius: 20)
        .offset(y: keyboardResponder.currentHeight*0.1)
        .onAppear {
            eventModel.userModel.user = nil
           // eventModel.showLogIn = true
        }
        .onDisappear {
            eventModel.userModel.user = nil
            eventModel.isAdmin = false
        }
        
        
    }
   
    

}

