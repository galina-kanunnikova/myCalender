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
                        Text("reservieren")
                    }
        .sheet(isPresented: $showPopUp){
            popUp(selectedRooms: [false,false,false], title: "", description: "", eventModel: eventModel,roomModel: eventModel.roomModel,toUpdateStartTime: nil ,bis:Date())
                }
        .foregroundColor(.white)
        .frame(width: style.screenWidth/4, height: 40)
        .background(Color.green)
        .cornerRadius(10)
    }
}

struct editObjectsButton: View {
    @State private var showPopUp = false
    @ObservedObject var eventModel : EventModel
    var body: some View {
        Button(action: {
            showPopUp.toggle()
                    }) {
                        Text(" Ansicht bearbeiten ")
                    }
        .sheet(isPresented: $showPopUp){
            editView_view(eventModel: eventModel, new_objects: eventModel.roomModel.rooms)
                }
        .foregroundColor(.white)
        .frame(width: style.screenWidth/4, height: 40)
       // .frame( height: 40)
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
        .frame(width: 40, height: 40)
       // .frame( height: 40)
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
