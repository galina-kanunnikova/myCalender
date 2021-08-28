//
//  UserModel.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 10.02.21.
//

import Foundation

class UserModel: ObservableObject {
    @Published var user : User?
    init(){}

}
struct User: Codable,Hashable {
    let success : Bool
    let data : userData
}

struct userData: Codable,Hashable {
    let id : Int
    let is_admin : Bool
}
