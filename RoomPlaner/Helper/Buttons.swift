//
//  Buttons.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 03.09.21.
//

import Foundation
import  SwiftUI

struct newEventBtn: View {
    @State private var showPopUp = false
    @ObservedObject var eventModel : EventModel
    var body: some View {
        Button(action: {
            showPopUp.toggle()
                    }) {
                        Text("reserve")
                    }
        .sheet(isPresented: $showPopUp){
            popUp(selectedRooms: selectedRooms(), title: "", description: "", eventModel: eventModel,roomModel: eventModel.roomModel,toUpdateStartTime: nil ,bis:Date())
                }
        .foregroundColor(.white)
        .frame(width: style.screenWidth/4, height: 40)
        .background(Color.green)
        .cornerRadius(10)
    }
    
    func selectedRooms() -> [Bool] {
        var selectedRooms: [Bool] = []
        for _ in eventModel.roomModel.rooms{
            selectedRooms.append(false)
        }
        return selectedRooms
    }
}

struct editObjectsButton: View {
    @State private var showPopUp = false
    @ObservedObject var eventModel : EventModel
    var body: some View {
        Button(action: {
            showPopUp.toggle()
                    }) {
                        Text( "edit view" )
                    }
        .sheet(isPresented: $showPopUp){
            editView_view(eventModel: eventModel, new_objects: eventModel.roomModel.rooms)
                }
        .foregroundColor(.white)
      //  .frame(width: style.screenWidth/4, height: 40)
        .frame( height: 40)
        .background(Color.green)
        .cornerRadius(10)
    }
    
    private func roomNames(rooms: [Room]) -> [String]{
        var names: [String] = []
        for room in rooms {
            names.append(room.name!)
        }
        return names
    }
}

struct pdfButton: View {
    @State private var showPopUp = false
    @ObservedObject var eventModel : EventModel
    var body: some View {
        Button(action: {
            showPopUp.toggle()
                    }) {
                        Text(" PDF ")
                    }
        .sheet(isPresented: $showPopUp){
            yearPicker(eventModel: eventModel, toPDF: true)
                }
        .foregroundColor(.white)
       // .frame(width: 40, height: 40)
        .frame( height: 40)
        .background(Color.green)
        .cornerRadius(10)
    }
    
    private func roomNames(rooms: [Room]) -> [String]{
        var names: [String] = []
        for room in rooms {
            names.append(room.name!)
        }
        return names
    }
}
