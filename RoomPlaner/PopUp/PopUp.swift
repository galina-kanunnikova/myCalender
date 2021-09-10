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
                        Text("cancel")
                    })
                    .frame(alignment: .leading)
                    .foregroundColor(.red)
                    
                    Spacer()
                    Text("Placement") .frame(alignment: .center).foregroundColor(colorScheme == .dark ? .white : .black)
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
                        checkRools(idToEdit: nil)
                        
                    }, label: {
                        Text("reserve")
                    })
                   
                    .frame(alignment: .trailing)
                    .foregroundColor(.red)
                    .alert(isPresented: $showingAlert) {
                        alert()
                    }
                        
                  }else {
                    Button(action: {
                        checkRools(idToEdit: toEditEventId)
                    }, label: {
                        Text("save changes")
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
                Text("reserved by:") .foregroundColor(colorScheme == .dark ? .white : .black)
                TextField("Name", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? .white : .black)
               
                Text("note:") .foregroundColor(colorScheme == .dark ? .white : .black)
             
                TextEditor( text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(height: 100)
                    .lineLimit(5) //.textFieldStyle(MyTextFieldStyle())
                    .border(Color.blue)
                }
                Spacer()
                HStack{
                    Text("select object") .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    ScrollView {
                    VStack{
                        ForEach(0..<roomModel.rooms.count,id: \.self) { i in
                            HStack{
                                Toggle(isOn: $selectedRooms[i]) {
                                            }.padding()
                                
                                Text(roomModel.rooms[i].name!) .foregroundColor(colorScheme == .dark ? .white : .black)
                                   // .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .frame(width: 150,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .lineLimit(2)
                                    .allowsTightening(true)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                            }
                        }
                    }.font(.system(size: 23))
                  }.frame(height: 250)
                }
                Spacer()
               // datePickerFrom(eventModel: eventModel, dpModel: dpModel)
                (toEditEventId == nil) ?  datePicker_year_from(dpModel: dpModel, eventModel: eventModel, start: Date()) :  datePicker_year_from(dpModel: dpModel, eventModel: eventModel,start: start() )
                Spacer()
                (toEditEventId == nil) ?  datePicker_year_till(eventModel: eventModel, dpModel: dpModel, to: dpModel.dateVon) :  datePicker_year_till(eventModel: eventModel, dpModel: dpModel,to: to() )
               // datePickerTill(eventModel: eventModel, dpModel: dpModel, bis: bis)
                Spacer()
                
            }.padding()
            
         /*   if eventModel.showLogIn == true {
                logIn(eventModel: eventModel , action: .login )
            }*/
          /*  if showMenu == true {
                admin_menu(roomModel: roomModel, eventModel: eventModel)
            }*/
            
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
   
    private func start() -> Date{
        for event in eventModel.events {
            if event.id == toEditEventId! {
                return  event.date_start!
            }
        }
     return Date()
    }
    
    private func to() -> Date{
        for event in eventModel.events {
            if event.id == toEditEventId! {
                return  event.date_end!
            }
        }
     return Date()
    }

}

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.blue, lineWidth: 3)
        ).padding()
    }
}
