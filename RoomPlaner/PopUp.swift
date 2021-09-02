//
//  PopUp.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 05.01.21.
//

import SwiftUI
import CoreData

enum ActiveAlert {
    case first, second,  third
}


struct datePickerFrom: View {
    @ObservedObject  var eventModel : EventModel
    @ObservedObject var dpModel : DatePickerModel
    @State private var start = Date()
    var toUpdateStartTime : Date?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        HStack{
            Text("Von").foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
                myDatePickerFrom ( dpModel: dpModel, eventModel: eventModel ,from:  start, to: dpModel.dateVon.dateTo30)
        }
        .onAppear{
            var d = Date()
            if Date().minute >= 55 {
                d = d.nextHour
                dpModel.dateVon = d
            }
            if toUpdateStartTime != nil {
                dpModel.dateVon = toUpdateStartTime!
                dpModel.startMinute = toUpdateStartTime!.minute
              
            }else{
                dpModel.dateVon = d
            }
            start = d
        }
  }
}

struct datePickerTill: View {
    @ObservedObject  var eventModel : EventModel
    @ObservedObject var dpModel : DatePickerModel
    @Environment(\.colorScheme) var colorScheme
    var bis : Date
    var toUpdateStartTime : Date?
    
    var body: some View {
        HStack{
            Text("Bis") .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            myDatePickerTill( dpModel: dpModel, eventModel: eventModel ,from:  dpModel.dateVon, to:dpModel.dateVon.dayEnd)
            
        }
        .onAppear{
           
            if toUpdateStartTime != nil {
                
                dpModel.dateBis = bis
                dpModel.endMinute = bis.minute
                
            }else {
               dpModel.dateBis = dpModel.dateVon
            }
        }
       
  }
}

struct popUp: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @State var selectedRooms : [Bool] 
    @State  var title: String
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAlert = false
    @State private var activeAlert: ActiveAlert = .first
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
                TextField("title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            
                Spacer()
                HStack{
                    Text("Räume") .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    VStack{
                        ForEach(0..<roomModel.visibleRooms.count,id: \.self) { i in
                            HStack{
                                Toggle(isOn: $selectedRooms[i]) {
                                            }.padding()
                                
                                Text(roomModel.visibleRooms[i].name) .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .frame(width: 250, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                            }
                            
                        }
                        
                    }.font(.system(size: 23))
                 }
                Spacer()
                datePickerFrom(eventModel: eventModel, dpModel: dpModel)
                Spacer()
                datePickerTill(eventModel: eventModel, dpModel: dpModel, bis: bis)
                Spacer()
                
            }.padding()
            
            if eventModel.showLogIn == true {
                logIn(eventModel: eventModel , action: .login )
            }
            if showMenu == true {
                menu(roomModel: roomModel, eventModel: eventModel)
            }
            
        }
        .cornerRadius(20).shadow(radius: 20)
        .offset(y: keyboardResponder.currentHeight*0.1)
        .onAppear {
            eventModel.userModel.user = nil
            eventModel.showLogIn = true
        }
        .onDisappear {
            eventModel.userModel.user = nil
            eventModel.isAdmin = false
        }
        
        
    }
    private func checkRools(id: Int?){
        var selectedRoomsIds : [Int] = []
       
        for i in 0..<selectedRooms.count {
            if selectedRooms[i] == true {
                selectedRoomsIds.append(Int(eventModel.roomModel.visibleRooms[i].id))
            }
        }
        
        if title == "" {
            showingAlert.toggle()
            activeAlert = .first
        }
        else if selectedRoomsIds.count == 0 {
            showingAlert.toggle()
            activeAlert = .second
        }else{//(x < y) ? func() : anotherFunc()
            if makeFetchRequest(rooms: selectedRoomsIds, id: (id != nil) ? id : nil) != 0 {
                   showingAlert.toggle()
                activeAlert = .third
               }
               else{
                eventModel.showLogIn.toggle()
                (id == nil) ? save(rooms: selectedRoomsIds) : updateEvent(id: id!, rooms: selectedRoomsIds)
               }
        }
    }
    
    private func alert() -> Alert{
        switch activeAlert {
            case .first:
               return Alert(title: Text("title leer"), message: Text("Bitte wählen Sie einen title"), dismissButton: .default(Text("OK")))
            case .second:
              return Alert(title: Text("Kein Raum ausgewählt"), message: Text("Bitte wählen Sie mindestens einen Raum aus"), dismissButton: .default(Text("OK")))
                    
             case .third:
                return Alert(title: Text("Bitte überprüfen Sie Ihre Eingaben"), message: Text("Die von Ihnen ausgewählten Räume sind im diesem Zeitfenster leider besetzt"), dismissButton: .default(Text("OK")))
        }
    }
    
   private func save (rooms: [Int]){
    if fullDate(date: dpModel.dateVon.zeroSeconds, min:dpModel.startMinute) >= fullDate(date: dpModel.dateBis.zeroSeconds, min:dpModel.endMinute) {
        
    }
    let js : [String: Any] = ["is_admin": eventModel.userModel.user!.data.is_admin,
                              "rooms": rooms,
                              "user_id":eventModel.userModel.user!.data.id,
                              "title": title,
                              "date_start": fullDate(date: dpModel.dateVon.zeroSeconds, min:dpModel.startMinute).dateToString
                              ,"date_end":fullDate(date: dpModel.dateBis.zeroSeconds, min:dpModel.endMinute).dateToString]
    eventModel.cancellationToken = try? APIdb.postEvent(event: js)
         .mapError({ (error) -> Error in
             print(error)
             return error
         })
         .sink(receiveCompletion: { (completion) in
             print(completion)
         switch completion {
         case .failure(let error):
             print(error)
         case .finished:
             print("DONE - postUserPublisher")
            eventModel.updateEvents()
         }
     }, receiveValue: { (data, response) in
         if let string = String(data: data, encoding: .utf8) {
             print(string)
         }
     })
     
    eventModel.userModel.user = nil
    eventModel.showLogIn = false
    self.presentationMode.wrappedValue.dismiss()
    /*let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let newEvent = Event(context: viewContext)
        newEvent.startDate = fullDate(date: dpModel.dateVon.zeroSeconds, min:dpModel.startMinute )
        newEvent.endDate = fullDate(date: dpModel.dateBis.zeroSeconds, min:dpModel.endMinute )
  
        newEvent.rooms = rooms as NSObject
        newEvent.id = Int64(Int(UInt.random(in: 0 ... 1000)))
        newEvent.title = title
        newEvent.cito_user_id = Int64(Int(UInt.random(in: 0 ... 1000)))
        
        do {
                    try viewContext.save()
                    print("Event saved.")
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    print(error.localizedDescription)
             }*/
    }
    
    private func updateEvent (id: Int, rooms: [Int]){
        if fullDate(date: dpModel.dateVon.zeroSeconds, min:dpModel.startMinute) >= fullDate(date: dpModel.dateBis.zeroSeconds, min:dpModel.endMinute) {
            
        }
        
        let js : [String: Any] = ["is_admin": eventModel.userModel.user!.data.is_admin,
                                  "rooms": rooms,
                                  "user_id":eventModel.userModel.user!.data.id,
                                  "title": title,
                                  "date_start": fullDate(date: dpModel.dateVon.zeroSeconds, min:dpModel.startMinute).dateToString
                                  ,"date_end":fullDate(date: dpModel.dateBis.zeroSeconds, min:dpModel.endMinute).dateToString]
        eventModel.cancellationToken = try? APIdb.updateEvent(event: js , id : id)
             .mapError({ (error) -> Error in
                 print(error)
                 return error
             })
             .sink(receiveCompletion: { (completion) in
                 print(completion)
             switch completion {
             case .failure(let error):
                 print(error)
             case .finished:
                 print("DONE - postUserPublisher")
                eventModel.updateEvents()
             }
         }, receiveValue: { (data, response) in
             if let string = String(data: data, encoding: .utf8) {
                 print(string)
             }
         })
         
        eventModel.userModel.user = nil
        eventModel.showLogIn = false
        self.presentationMode.wrappedValue.dismiss()
        /*let formatter = DateFormatter()
         formatter.timeStyle = .short
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
         fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        do {
         let result = try moc.fetch(fetchRequest) as! [Event]
         let event = result.first
            event?.title = title
            event?.startDate = fullDate(date: dpModel.dateVon.zeroSeconds, min: dpModel.startMinute)
            event?.endDate = fullDate(date: dpModel.dateBis.zeroSeconds, min: dpModel.endMinute)
           
            event?.rooms = rooms as NSObject
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
            
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }*/
        
     }
    
    ///if return 0 --> the rooms are free for a selected period
    /// return > 0 --> reserved
    private func makeFetchRequest(rooms: [Int],id: Int?)  -> Int  {
        
       
        for room in eventModel.roomModel.visibleRooms {
            
            //events for a room
            for event in eventModel.eventsAfterRooms[Int(room.id) - 1] {
             
                let start_date =  event.date_start.date.stringToDate
               
                //events for a day
                if (start_date >= dpModel.dateVon.dayStart) && (start_date < dpModel.dateVon.dateTo) {
                   
                    // check  rooms
                    if hasSameRooms(event: event, selectedRoomsIdx: rooms) {
                        
                       //check if already reserved
                        let start = fullDate(date: dpModel.dateVon, min: dpModel.startMinute)
                        let end = fullDate(date: dpModel.dateBis, min: dpModel.endMinute)
                        let startDate = event.date_start.date.stringToDate
                        let endDate = event.date_end.date.stringToDate
                        print(start)
                        print(end)
                        print(startDate)
                        print(endDate)
                        if (start < endDate ) && ((end > startDate)){
                            //already reserved
                            if id != nil {
                                if (id! != event.id)
                                {
                                   
                                    return  1
                                }
                            
                            }else {
                               
                                return  1
                            }
                          
                            
                        }else{
                            //free
                           
                        }
                    }
                }
            }
        }
        
        
       /*
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        //all events for a day dateVon
        let fromPredicate = NSPredicate(format: "startDate >= %@", dpModel.dateVon.dayStart as CVarArg )
        let toPredicate = NSPredicate(format: "startDate < %@",  dpModel.dateVon.dateTo as CVarArg)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        fetchRequest.predicate = datePredicate
           do {
            let eventsForADay = try moc.fetch(fetchRequest) as! [Event]
           
            if eventsForADay.count > 0 {
                var alreadyReservedCount = 0
                for event in eventsForADay {
                    // check  rooms
                    if hasSameRooms(event: event, selectedRoomsIdx: rooms) {
                        //check if already reserved
                        let start = fullDate(date: dpModel.dateVon, min: dpModel.startMinute)
                        let end = fullDate(date: dpModel.dateBis, min: dpModel.endMinute)
                      
                        if (start < event.endDate! ) && ((end > event.startDate!)){
                            //already reserved
                            if id != nil {
                                if (id! != event.id)
                                {
                                    alreadyReservedCount = alreadyReservedCount + 1
                                    return  alreadyReservedCount
                                }
                            
                            }else {
                                alreadyReservedCount = alreadyReservedCount + 1
                                return  alreadyReservedCount
                            }
                          
                            
                        }else{
                            //free
                           
                        }
                    }
                    
                }
                
                return  alreadyReservedCount
                
            }else {return 0}
                  } catch {
                      fatalError("Failed to fetch categories: \(error)")
                  }*/
        return 0
        }
    
    
    private func hasSameRooms(event: EventObj, selectedRoomsIdx: [Int]) -> Bool{
        var reservedRooms : [Int] = []
        for room in event.rooms {
            reservedRooms.append(Int(room.id))
        }
        if reservedRooms.containsSameElements(as: selectedRoomsIdx) {
            return true
        }else{return false }
    }
    
    

}

