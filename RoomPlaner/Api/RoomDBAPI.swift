//
//  RoomDBAPI.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 11.01.21.
//

import Combine
import UIKit
import CoreData

enum APIError: Error {
    case invalidBody
    case invalidEndpoint
    case invalidURL
    case emptyData
    case invalidJSON
    case invalidResponse
    case statusCode(Int)
}

enum APIdb {
    static let baseUrl = URL(string: "https://raumplaner.tag24.dev/")!
    static let headers = [
        "Content-Type": "application/json",
        "cache-control": "no-cache"
    ]
}

enum APIPath: String {
    //GET
    case availableRooms = "api/v1/rooms"
    case appointmentsForRoom = "api/v1/room/"    // + {ID}/appointments"
    case detailsForRoom = "api/v1/appointment/{ID}"
   
    //DELETE
    case deleteAppointment = "api/v1/appointment/"
    case auth = "api/v1/authenticate"
}

enum APIPathPOST: String {
    
    case updateAppointment = "api/v1/appointment/" // + {ID}
    case createAppointment  = "api/v1/appointment"
    
}


extension APIdb {
  
    static func setAPIUrl()    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        var url = APIUrl(context:context)
        url.baseUrl = "https://raumplaner.tag24.dev/"
        do {
                    try context.save()
                    print("base url saved.")
                  
                } catch {
                    print(error.localizedDescription)
             }
        
    }
    
    
    static func autheticate(email: String, pssw : String)  ->  AnyPublisher<User, Error>  {
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(APIPath.auth.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        
        let js : [String: Any] = ["email": email, "password": pssw ]
        let jsonData = try? JSONSerialization.data(withJSONObject: js)
      
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
       
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> User in
               
                let value = try JSONDecoder().decode(User.self, from: result.data)
                return value
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func requestRooms(_ path: APIPath) -> AnyPublisher<[RoomObj], Error> {
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
      //  components.queryItems = [URLQueryItem(name: "api_key", value: "your_api_key_here")] // 4
        
        var request = URLRequest(url: components.url!)
        request.allHTTPHeaderFields = headers
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> [RoomObj] in
                let value = try JSONDecoder().decode([RoomObj].self, from: result.data)
                return value
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func requestEventsForRoom(id: Int) -> AnyPublisher<[EventObj], Error> {
        let path = "\(APIPath.appointmentsForRoom.rawValue)\(id)/appointments"
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
      //  components.queryItems = [URLQueryItem(name: "api_key", value: "your_api_key_here")] // 4
        
        var request = URLRequest(url: components.url!)
        request.allHTTPHeaderFields = headers
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> [EventObj] in
                
                let value = try JSONDecoder().decode([EventObj].self, from: result.data)
                return value
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
       
    }
    
    static func postEvent(event: [String: Any]) throws -> URLSession.DataTaskPublisher {
        guard let components = URLComponents(url: URL(string: (APIModel().api?.baseUrl!)!)!.appendingPathComponent(APIPathPOST.createAppointment.rawValue), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
       
        let jsonData = try? JSONSerialization.data(withJSONObject: event)
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
        
        return URLSession.shared.dataTaskPublisher(for: request)
        
    }
    
    static func updateEvent(event: [String: Any] , id : Int) throws -> URLSession.DataTaskPublisher {
        let path = "\(APIPathPOST.updateAppointment.rawValue)\(id)"
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
       
        let jsonData = try? JSONSerialization.data(withJSONObject: event)
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
        
        return URLSession.shared.dataTaskPublisher(for: request)
        
    }
    
    
    static func deleteEvent(cito_user_id: Int,  event : EventObj) throws -> URLSession.DataTaskPublisher {
        let path = "\(APIPath.deleteAppointment.rawValue)\(event.id)"
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)
            else { fatalError("Couldn't create URLComponents") }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        let parameters = ["cito_user_id": cito_user_id ,  "user_id": event.user_id] as [String : Any]
        let httpBody = try? JSONSerialization.data(withJSONObject:parameters)
        request.httpBody = httpBody
        let session = URLSession.shared
        return session.dataTaskPublisher(for: request)
       
    }
    
    
    
    
}

