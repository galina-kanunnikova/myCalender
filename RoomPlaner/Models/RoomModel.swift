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
    @Published var rooms: [Room] = []
 //   @Published var visibleRooms: [Room] = []
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
         do {
          let res = try context.fetch(fetchRequest) as! [Room]
             print(res)
          rooms = res
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
    
    func saveRooms(rooms: [Room]){
        deleteRooms()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        for room in rooms {
            let r = create_Room_core_data(title : room.name! , id :Int(room.id))
               do {
                           try context.save()
                           print("Room saved.")
                         
                       } catch {
                           print(error.localizedDescription)
                    }
           }
        getRoomsFromLokalStorage()
    }
    
    func create_Room_core_data(title : String , id : Int) -> Room{
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let new_obj = Room(context: context)
        new_obj.name = title
        new_obj.id = Int16(id)
        return new_obj
    }
    
    func saveRoomsToLocalStorage(rooms: [Room]){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        for room in rooms {
            let objToSave = create_Room_core_data(title : room.name! , id :Int(room.id))
               do {
                           try context.save()
                           print("Objekt with the name \(objToSave.name) saved.")
                         
                       } catch {
                           print(error.localizedDescription)
                    }
           }
        getRoomsFromLokalStorage()
    }
    
    func saveRoomToLocalStorage(title : String , id : Int ){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let objToSave = create_Room_core_data(title : title , id : id)
        do {
                    try context.save()
                    print("Objekt with the name \(title) saved.")
                  
                } catch {
                    print(error.localizedDescription)
             }
        getRoomsFromLokalStorage()
    }
    
}
