//
//  APIModel.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 27.02.21.
//

import Combine
import CoreData
import UIKit
import SwiftUI

class APIModel: ObservableObject {
    @Published var api: APIUrl?
    init(){
        getAPI()
    }
    
}

extension APIModel {
    func getAPI(){
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "APIUrl")
             do {
              let res = try context.fetch(fetchRequest) as! [APIUrl]
                self.api = res.first!
              } catch {
                        fatalError("Failed to fetch categories: \(error)")
             }
        
    }
    func save(key: String, url: String){
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "APIUrl")
             do {
              let res = try context.fetch(fetchRequest) as! [APIUrl]
                self.api = res.first!
                res.first!.setValue(url, forKey: key)
                do {
                            try context.save()
                            print("base url saved.")
                          
                        } catch {
                            print(error.localizedDescription)
                     }
              } catch {
                        fatalError("Failed to fetch categories: \(error)")
             }
        
    }
}

