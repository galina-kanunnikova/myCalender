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
    @State  var title: String = "Objekt Titel"
    @State  var objects: [String] = []
    @Binding var signInSuccess: Bool
    
    var body: some View {
        
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                  Spacer()
                  Text("Geben Sie die Namen für Objekte die reserviert werden (mindestens 1)")
                  Spacer()
              
                  TextField("title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .fixedSize()
               // .padding(.leading, 100).padding(.trailing, 100)
                //ForEach(objects, id: \.self) { obj in
                     
                  ForEach(0..<objects.count,id: \.self) { i in
   
                     HStack {
                        
                        Text(objects[i])
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .foregroundColor(.black)
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
                            title = "Objekt Titel"
                           
                         }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        //.cornerRadius(25)
                        .clipShape(Circle())
                        
                       /* Button("-") {
                          objects.removeLast()
                            
                         }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        //.cornerRadius(25)
                        .clipShape(Circle())*/
                    }
                  
                  Spacer()
                }.padding(.leading, 100).padding(.trailing, 100)
                
                Button("Weiter zum Kalender  >") {
                    self.signInSuccess = true
                   
                 }
                .padding()
                .foregroundColor(.white)
                .background(style.lightRed)
                .cornerRadius(25)
                .font(.system(size: 25))
                .frame(width:300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            }
    }
   
}


