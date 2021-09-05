//
//  EventModel.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 11.01.21.
//

import Foundation
import Combine
import CoreData
import UIKit
import SwiftUI

class EventModel: ObservableObject {
    @Published var displayDetailView = view(event: nil, display: false)
    @Published var eventsAfterRooms: [[Event]] = []
    @Published var events: [Event] = []
    @Published var cellsForOverlay: [[cellForOverlay]] = []
    @Published var showLogIn = true
    @Published var isAdmin = false
    @ObservedObject var roomModel = RoomModel()
    @ObservedObject var dayModel = DayModel()
    @ObservedObject var userModel = UserModel()
    
    var cancellationToken: AnyCancellable?
    
    init() {
        getEvents()
    }
    
}

struct DateObj: Codable,Hashable {
    let date : String
    let timezone_type : Int
    let timezone: String
}

struct EventObj: Codable,Hashable {
    let id : Int16
    let title: String
    let user_id : Int16
    let date_start: DateObj
    let date_end: DateObj
    let created_at : DateObj?
    let updated_at : DateObj?
    let is_admin: Bool?
    let rooms : [RoomObj]
  
}

struct cellForOverlay: Hashable {
    let event : Event?
    let height: CGFloat
}

struct view: Hashable {
    var event : Event?
    var display: Bool
}


extension EventModel {
    
    
    // Subscriber implementation
    private func getEvents() {
        
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            DispatchQueue.main.async {
              //  self.cellsForOverlay = []
              //  self.eventsAfterRooms = []
                
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appdelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
                do {
                 let events = try context.fetch(fetchRequest) as! [Event]
                    self.events =  events
                
                 } catch {
                           fatalError("Failed to fetch categories: \(error)")
                }
                self.eventsAfterRooms = []
                self.divideAfterRooms()
          
                /*     for i in 0...self.roomModel.rooms.count - 1 {
                    let room = self.roomModel.rooms[i]
                    self.cellsForOverlay.append([])
                    self.eventsAfterRooms.append([])
                    
                     
                    
                   self.eventsRequest(id: room.id, completion:{
                        events in
                        DispatchQueue.main.async {
                            
                       let eventsByStartDate =  events.sorted(by: {$0.date_start.date.stringToDate < $1.date_start.date.stringToDate})
                         var eventsForADay : [Event] = []
                       for event in eventsByStartDate {
                        
                          if event.date_start.date.stringToDate >= self.dayModel.startDay.dayStart &&  event.date_start.date.stringToDate < self.dayModel.startDay.dateTo {
                                  eventsForADay.append(event)
                              }
                       }
                            self.eventsAfterRooms[i].append(contentsOf: eventsForADay)
                            if eventsForADay.count > 0 { self.makeCellsForOverlay( roomIdx: i, events: eventsForADay)}
                        }
                    })
                }*/
              
            }
        } else {
            print("First launch.")
          
           // APIdb.setAPIUrl()
          //  firstLaunch()
        }
  
    }
   /*
    func firstLaunch () {
        
        self.roomModel.cancellationToken = APIdb.requestRooms(.availableRooms)
                 .mapError({ (error) -> Error in
                     print(error)
                     return error
                 })
                 .sink(receiveCompletion: { _ in },
                       receiveValue: {rooms in
                     
                         self.roomModel.rooms = rooms
                         self.roomModel.saveRooms(rooms: rooms)
                         self.cellsForOverlay = []
                         self.eventsAfterRooms = []
                        
                         for room in rooms {
                             
                             self.cellsForOverlay.append([])
                             self.eventsAfterRooms.append([])
                             
                            self.eventsRequest(id: Int(room.id), completion:{
                                 events in
                                 DispatchQueue.main.async {
                                     
                                let eventsByStartDate =  events.sorted(by: {$0.date_start.date.stringToDate < $1.date_start.date.stringToDate})
                                  var eventsForADay : [Event] = []
                                for event in eventsByStartDate {
                                 
                                   if event.date_start.date.stringToDate >= self.dayModel.startDay.dayStart &&  event.date_start.date.stringToDate < self.dayModel.startDay.dateTo {
                                           eventsForADay.append(event)
                                       }
                                }
                                    self.eventsAfterRooms[Int(room.id) - 1].append(contentsOf: eventsForADay)
                                    if eventsForADay.count > 0 { self.makeCellsForOverlay( roomIdx: Int(room.id) - 1, events: eventsForADay)}
                                 }
                             })
                             
                         }
                        
             })
    }*/
    
    func updateEvents() {
        getEvents()
    }
    
    func eventsRequest(id: Int, completion: @escaping ([EventObj]) -> ()) {
        let path =  "\(APIPath.appointmentsForRoom.rawValue)\(id)/appointments"
        guard let components = URLComponents(url: APIdb.baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        var request = URLRequest(url: components.url!)
        request.allHTTPHeaderFields = APIdb.headers
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let events = try? JSONDecoder().decode([EventObj].self, from: data!) {
                completion(events)
            }
        }).resume()
    }

    func deleteEvent(event : EventObj) {
        showLogIn = false
        if (userModel.user?.data.id)! == event.user_id {
        self.cancellationToken =  try? APIdb.deleteEvent(cito_user_id:(userModel.user?.data.id)!, event: event)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [self] response in
                    print(response)
                    userModel.user = nil
                    updateEvents()
        })
        }
        /*
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        do {
         let events = try context.fetch(fetchRequest) as! [Event]
            for event in events {
                if event.id == id {context.delete(event)
                    getEvents()
                }
            }
        
         } catch {
                   fatalError("Failed to fetch categories: \(error)")
        }
       */
    }
    
    func deleteEvent_local(event : Event) {
       
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        do {
         let events = try context.fetch(fetchRequest) as! [Event]
            for ev in events {
                if event.id == ev.id {context.delete(event)
                    updateEvents()
                }
            }
         } catch {
                   fatalError("Failed to fetch categories: \(error)")
        }
    }
    func deleteEvents_for_room(index : Int) {
           
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
            do {
             let events = try context.fetch(fetchRequest) as! [Event]
                for ev in events {
                    if ev.rooms?.contains(index) == true{
                        if ev.rooms!.count > 1 {
                            let i = ev.rooms!.firstIndex(where: { $0 == index })
                            ev.rooms?.remove(at: i!)
                            try context.save()
                        }else {
                            context.delete(ev)
                        }
                    }
                }
                updateEvents()
             } catch {
                       fatalError("Failed to fetch categories: \(error)")
            }
    }
    
func divideAfterRooms( ) {
        self.cellsForOverlay = []
        let day = dayModel.selectedDay
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        for roomIdx in 0..<roomModel.rooms.count {
            var eventsForRoom : [Event] = []
            
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
            let fromPredicate = NSPredicate(format: "date_start >= %@", day.dayStart as CVarArg )
            let toPredicate = NSPredicate(format: "date_start < %@",  day.dateTo as CVarArg)
            let sort = NSSortDescriptor(key: "date_start", ascending: true)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            fetchRequest.predicate = datePredicate
            fetchRequest.sortDescriptors = [sort]

            do {
               let fetchResult = try context.fetch(fetchRequest) as! [Event]
                  if fetchResult.count > 0 {
                
                      for result in fetchResult {
                           let reservedRooms = result.rooms as! [Int]
                           if reservedRooms.containsSameElements(as: [roomIdx]) {
                              eventsForRoom.append(result as Event)
                           }
                     }
                }
                
            } catch {
                       fatalError("Failed to fetch categories: \(error)")
                   }
            eventsAfterRooms.append(eventsForRoom)
            cellsForOverlay.append([])
            if eventsForRoom.count > 0 { makeCellsForOverlay( roomIdx: roomIdx, events: eventsAfterRooms[roomIdx])}
        }
    }
    
    func makeCellsForOverlay(roomIdx: Int,events: [Event] ){
        let count = events.count + (events.count - 1 ) + 2
            for i in 0..<count{
    
                if i%2 != 0 { //event
                    let event = events[realEventIdx(fakeIdx: i)]
                    let durationInMin = eventDuration(event:  event)
                    cellsForOverlay[roomIdx].append(cellForOverlay(event: event, height:CGFloat(durationInMin)*oneMinHeight))
                   
                }else{ //gap
                    
                    let height = gapHeight(i: i, events: events, countCells: count)
                    cellsForOverlay[roomIdx].append(cellForOverlay( event: nil, height:height))
                        
                }
            }
        
    }
    
    func realEventIdx(fakeIdx: Int) -> Int {
        var gaps = 0
       
         for i in 0..<fakeIdx+1 {
             //find gap idx
             if i%2 == 0 && i < fakeIdx { //start bei Idx 0
                 gaps = gaps + 1
             }
             // event
             if i == fakeIdx  { //start bei Idx 1
                 return i - gaps
             }
         }
        
        return 0
    }
    func eventDuration( event: Event) -> Int{
        return  Int((event.date_end!.timeIntervalSince(event.date_start!))*0.016666666666667)
    }
    
    private func gapHeight(i: Int, events: [Event],countCells: Int  ) -> CGFloat {
        var height: CGFloat = 0
        if i == 0 {
            let start = events[i].date_start!.dayStart
            let gapMin = CGFloat((events[i].date_start!.timeIntervalSince(start))*0.016666666666667)
            height = gapMin*oneMinHeight 
            
        }else if i == countCells - 1{ //last gap
            let fakeEventIdx = i-1
            let eventIdx = realEventIdx(fakeIdx: fakeEventIdx)
            let start =   events[eventIdx].date_end!
            let end =   events[eventIdx].date_start!.dayEnd
            let gapMin = CGFloat(((end.timeIntervalSince(start))*0.016666666666667))
            height = gapMin*oneMinHeight
        }else {
            let fakeEventIdx = i-1
            let eventIdx = realEventIdx(fakeIdx: fakeEventIdx)
            let start =  events[eventIdx].date_end!
            let end = events[eventIdx+1].date_start!
            let gapMin = CGFloat(((end.timeIntervalSince(start))*0.016666666666667))
            height = gapMin*oneMinHeight
        }
        
        return height
    }
    
    
}

