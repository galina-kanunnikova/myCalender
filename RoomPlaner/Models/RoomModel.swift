//
//  ViewModels.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 11.01.21.
//

import Combine
import CoreData
import UIKit
import SwiftUI



struct RoomObj: Codable,Hashable {
    let id : Int16
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}


class RoomModel: ObservableObject {
    @Published var rooms: [RoomObj] = []
 //   @Published var visibleRooms: [RoomObj] = []
    var cancellationToken: AnyCancellable?
    init(){
        getRoomsFromLokalStorage()
       // getVisibleRooms()
    }
    
}

extension RoomModel {
    
    // Subscriber implementation
  /*  func getVisibleRooms() {
        
        cancellationToken = APIdb.requestRooms(.availableRooms)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {rooms in
                    self.rooms = rooms
                  
        })
        
    }*/
    
    func getRoomsFromLokalStorage(){
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        rooms = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Room")
         do {
          let res = try context.fetch(fetchRequest) as! [Room]
            for room in res {
                rooms.append(RoomObj(id: room.id, name: room.name!))
            }
             
          } catch {
                    fatalError("Failed to fetch categories: \(error)")
         }
        
    }
    
    func deleteRooms(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Room")
         do {
          let res = try context.fetch(fetchRequest) as! [Room]
            for room in res {
                context.delete(room)
            }
             
          } catch {
                    fatalError("Failed to fetch categories: \(error)")
         }
    }
    
    func deleteRoom(id: Int){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Room")
         do {
          let res = try context.fetch(fetchRequest) as! [Room]
            for room in res {
                if room.id == id {
                    context.delete(room)
                    rooms.remove(at: id)
                }
            }
             
          } catch {
                    fatalError("Failed to fetch categories: \(error)")
         }
      
    }
    
    func saveRooms(rooms: [RoomObj]){
        deleteRooms()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        for room in rooms {
               var r = Room(context: context)
               r.name = room.name
               r.id = Int16(room.id)
               do {
                           try context.save()
                           print("Room saved.")
                         
                       } catch {
                           print(error.localizedDescription)
                    }
           }
        getRoomsFromLokalStorage()
    }
    
    func saveRoomsToLocalStorage(rooms: [RoomObj]){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        for room in rooms {
               var objToSave = Room(context: context)
               objToSave.name = room.name
               objToSave.id = room.id
               do {
                           try context.save()
                           print("Objekt with the name \(objToSave.name) saved.")
                         
                       } catch {
                           print(error.localizedDescription)
                    }
           }
        getRoomsFromLokalStorage()
    }
    
    func saveRoomToLocalStorage(room: RoomObj){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        var objToSave = Room(context: context)
        objToSave.name = room.name
        objToSave.id = room.id
        do {
                    try context.save()
                    print("Objekt with the name \(objToSave.name) saved.")
                  
                } catch {
                    print(error.localizedDescription)
             }
        getRoomsFromLokalStorage()
    }
    
}
