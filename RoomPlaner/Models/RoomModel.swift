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
    let id : Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}


class RoomModel: ObservableObject {
    @Published var rooms: [RoomObj] = []
    @Published var visibleRooms: [RoomObj] = []
    var cancellationToken: AnyCancellable?
    init(){
        getRooms()
        getVisibleRooms()
    }
    
}

extension RoomModel {
    
    // Subscriber implementation
    func getRooms() {
        
        cancellationToken = APIdb.requestRooms(.availableRooms)
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {rooms in
                    self.rooms = rooms
                  
        })
        
    }
    
    func getVisibleRooms(){
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        visibleRooms = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Room")
         do {
          let res = try context.fetch(fetchRequest) as! [Room]
            for room in res {
                visibleRooms.append(RoomObj(id: Int(room.id), name: room.name!))
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
                           print("Event saved.")
                         
                       } catch {
                           print(error.localizedDescription)
                    }
           }
        getVisibleRooms()
    }
    
}
