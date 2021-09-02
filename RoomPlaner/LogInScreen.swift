//
//  LogInScreen.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 02.02.21.
//

import SwiftUI
import Combine

enum Action {
    case delete,login,update
}

struct logIn: View {
    @ObservedObject  var eventModel : EventModel
    @State private var email = ""
    @State private var password = ""
    @State private var error = false
    @State var action : Action
    @State var event : EventObj?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack() {
            Spacer()
            Text("Anmeldung") .foregroundColor(.red).font(.system(size: 30))
            Spacer()
            HStack {
                Spacer()
                TextField("Email", text: self.$email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .frame(width : 400)
                Spacer()
            }
            
            SecureField("Password", text: self.$password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(width : 400)
            Spacer()
            if error == true {
                Text("Fehler").foregroundColor(.red).font(.system(size: 30))
            }
            Spacer()
            Button("Einloggen") {
                //"galina.kannunikova@tag24.de" "Tag12345!"
                    eventModel.cancellationToken =  APIdb.autheticate(email: "galina.kannunikova@tag24.de", pssw: "Tag12345!")
                        .mapError({ (er) -> Error in
                          error = true
                        return er
                    })
                    .sink(receiveCompletion: { _ in },
                          receiveValue: { (user) in
                                eventModel.showLogIn = false
                                error = false
                                eventModel.userModel.user = user
                                if user.data.is_admin == true {
                                    eventModel.isAdmin = true
                                }
                          
                            switch action {
                            case .delete :  eventModel.deleteEvent(event: event!)
                                eventModel.displayDetailView.display.toggle() ;
                            case .update : break
                            case .login: break
                            }
                           
                          })
                       
            }
                .frame(width: 230, height: 40)
                .background(Color.red)
                .cornerRadius(10)
            Spacer()
          }
        .background(Color.white)
        .frame(width: 500, height: 500,alignment: .center)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}
