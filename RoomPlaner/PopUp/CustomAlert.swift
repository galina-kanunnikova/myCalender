//
//  CustomAlert.swift
//  CustomAlert
//
//  Created by Galina Kanunnikova on 05.09.21.
//

import Foundation
import SwiftUI

struct custom_alert: View {
    @ObservedObject  var eventModel : EventModel
    @State var event : Event
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            Spacer()
            Text("Wollen Sie den Termin wirklich löschen ?")
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    eventModel.deleteEvent_local(event: event)
                   // eventModel.showLogIn = false
                    eventModel.displayDetailView.display.toggle()
                
                }, label: {
                    Text("Ja")
                })
                    .foregroundColor(.white)
                    .frame(width: 130, height: 40)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.bottom,5)
                Spacer()
                Button(action: {
                    eventModel.showLogIn = false
                }, label: {
                    Text("Nein")
                })
                    .foregroundColor(.white)
                    .frame(width: 130, height: 40)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.bottom,5)
                Spacer()
            }
           
        } .frame(width: 300, height: 200)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
    }
}
