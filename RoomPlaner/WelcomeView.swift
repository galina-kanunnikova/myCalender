//
//  WelcomeView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 30.08.21.
//
import SwiftUI
import Foundation
import UIKit
import CoreData


struct WelcomeView: View {
    @ObservedObject var eventModel = EventModel()
    @State  var title: String = ""
    @State  var objects: [String] = []
    @Binding var signInSuccess: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                  Spacer()
                  Text("Geben Sie die Namen für Objekte die reserviert werden (mindestens 1)")
                  Spacer()
              
                  TextField("Objekt Name", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .fixedSize()
                    
                  ForEach(0..<objects.count,id: \.self) { i in
   
                     HStack {
                        Text(objects[i])
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .foregroundColor(colorScheme == .dark ? .white : .black)
                           .fixedSize()
                    
                        Button("x") {
                            objects.remove(at: 0)
                        }
                          .padding()
                          .foregroundColor(.red)
                          .font(.system(size: 30))
                       }
                     
                 // Spacer()
                 }
                    if objects.count < 10 {
                        Button("+") {
                          objects.append(title)
                            title = ""
                         }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .buttonStyle(MyButtonStyle())
                        .clipShape(Circle())
                        .disabled(title == "")
                    }
                  
                  Spacer()
                }.padding(.leading, 100).padding(.trailing, 100)
               
                Button("Weiter zum Kalender  >") {
                    self.signInSuccess = true
                    for i in 0 ..< objects.count{
                        let newObj = RoomObj(id: Int16(i), name: objects[i])
                        eventModel.roomModel.saveRoomToLocalStorage(room: newObj)
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                    }
                   
                 }
                .buttonStyle(MyButtonStyle())
                .disabled(objects.count == 0)
                .padding()
                .foregroundColor(.white)
                .background(style.lightRed)
                .cornerRadius(25)
                .font(.system(size: 25))
                .frame(width:300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
    }
   
}


