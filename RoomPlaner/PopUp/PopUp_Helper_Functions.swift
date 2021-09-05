//
//  PopUp_Helper_Functions.swift
//  PopUp_Helper_Functions
//
//  Created by Galina Kanunnikova on 04.09.21.
//

import Foundation
import CoreData
import SwiftUI

enum ActiveAlert {
    case first, second,  third
}


extension popUp{
    
     func checkRools(idToEdit: Int?){
        var selectedRoomsIds : [Int] = []
       
        for i in 0..<selectedRooms.count {
            if selectedRooms[i] == true {
                selectedRoomsIds.append(Int(eventModel.roomModel.rooms[i].id))
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
            if makeFetchRequest(roomsIds: selectedRoomsIds, idToEdit: (idToEdit != nil) ? idToEdit : nil) != 0 {
                showingAlert.toggle()
                activeAlert = .third
               }
            else{
                eventModel.showLogIn.toggle()
                (idToEdit == nil) ? saveEvent_local(roomsIds: selectedRoomsIds) : updateEventInLocalStorage(id: idToEdit!, roomsIds: selectedRoomsIds)
                
                   // (id == nil) ? saveEvent(rooms: selectedRoomsIds) : updateEvent(id: id!, rooms: selectedRoomsIds)
               }
        }
    }
    
     func alert() -> Alert{
        switch activeAlert {
            case .first:
               return Alert(title: Text("Name leer"), message: Text("Bitte den Name des Reservierenden eingeben"), dismissButton: .default(Text("OK")))
            case .second:
              return Alert(title: Text("Kein Raum ausgewählt"), message: Text("Bitte wählen Sie mindestens einen Raum aus"), dismissButton: .default(Text("OK")))
                    
             case .third:
                return Alert(title: Text("Bitte überprüfen Sie Ihre Eingaben"), message: Text("Die von Ihnen ausgewählten Räume sind im diesem Zeitfenster leider besetzt"), dismissButton: .default(Text("OK")))
        }
    }
    
   private func saveEvent (rooms: [Int]){
    if fullDate(date: dpModel.dateVon.zeroSeconds, min:dpModel.startMinute) >= fullDate(date: dpModel.dateBis.zeroSeconds, min:dpModel.endMinute) {
        
    }
    let js : [String: Any?] = ["is_admin": nil ,//eventModel.userModel.user!.data.is_admin,
                              "rooms": rooms,
                              "user_id": nil, //eventModel.userModel.user!.data.id,
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
    
    private func saveEvent_local (roomsIds: [Int]){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
     let formatter = DateFormatter()
         formatter.timeStyle = .short
         
         let newEvent = Event(context: context)
       //  newEvent.date_start = fullDate(date: dpModel.dateVon.zeroSeconds, min:dpModel.startMinute )
         newEvent.date_start = dpModel.dateVon
         newEvent.date_end = dpModel.dateBis
       // newEvent.date_end = fullDate(date: dpModel.dateBis.zeroSeconds, min:dpModel.endMinute )
         newEvent.rooms = roomsIds
         newEvent.id = Int16(Int(UInt.random(in: 0 ... 1000)))
         newEvent.title = title
       //  newEvent.cito_user_id = Int64(Int(UInt.random(in: 0 ... 1000)))
         
         do {
                     try context.save()
                     print("Event saved.")
                     eventModel.updateEvents()
                     presentationMode.wrappedValue.dismiss()
                 } catch {
                     print(error.localizedDescription)
              }
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
    
    private func updateEventInLocalStorage (id: Int, roomsIds: [Int]){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let formatter = DateFormatter()
         formatter.timeStyle = .short
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
         fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        do {
         let result = try moc.fetch(fetchRequest) as! [Event]
         let event = result.first
            event?.title = title
          //  event?.date_start = fullDate(date: dpModel.dateVon.zeroSeconds, min: dpModel.startMinute)
             event?.date_start = dpModel.dateVon
          //  event?.date_end = fullDate(date: dpModel.dateBis.zeroSeconds, min: dpModel.endMinute)
            event?.date_end = dpModel.dateBis
           
            event?.rooms = roomsIds
            try context.save()
            eventModel.updateEvents()
            eventModel.showLogIn = false
            presentationMode.wrappedValue.dismiss()
            
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }
        
     }
    
    private func collectRooms(idx: [Int]) -> [Room]{
        var rooms : [Room] = []
        for room in roomModel.rooms{
            for id in idx {
                if room.id == id {rooms.append(room)}
            }
        }
        return rooms
    }
    
    ///if return 0 --> the rooms are free for a selected period
    /// return > 0 --> reserved
    private func makeFetchRequest(roomsIds: [Int],idToEdit: Int?)  -> Int  {
        for room in eventModel.roomModel.rooms {
            
            //events for a room
            for event in eventModel.eventsAfterRooms[Int(room.id)] {
             
                let start_date =  event.date_start//.date.stringToDate
               
                //events for a day
                if (start_date! >= dpModel.dateVon.dayStart) && (start_date! < dpModel.dateVon.dateTo) {
                   
                    // check  rooms
                    if hasSameRooms(event: event, selectedRoomsIdx: roomsIds) {
                        
                       //check if already reserved
                     //   let start = fullDate(date: dpModel.dateVon, min: dpModel.startMinute)
                    //    let end = fullDate(date: dpModel.dateBis, min: dpModel.endMinute)
                        let start = dpModel.dateVon
                        let end = dpModel.dateBis
                        let startDate = event.date_start!//.date.stringToDate
                        let endDate = event.date_end!//.date.stringToDate
                       
                        if (start < endDate ) && ((end > startDate)){
                            //already reserved
                            if idToEdit != nil {
                                if (idToEdit! != event.id)
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
    
    
    private func hasSameRooms(event: Event, selectedRoomsIdx: [Int]) -> Bool{
        var reservedRooms : [Int] = []
        for room in event.rooms! {
            reservedRooms.append(room)
        }
        if reservedRooms.containsSameElements(as: selectedRoomsIdx) {
            return true
        }else{return false }
    }
    
    
}
