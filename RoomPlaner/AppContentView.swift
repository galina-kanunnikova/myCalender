//
//  AppContentView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 30.08.21.
//

import Foundation
import SwiftUI

struct AppContentView: View {
    
    @State var signInSuccess = false
    @ObservedObject var eventModel = EventModel()
    var body: some View {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        return Group {
            if signInSuccess || launchedBefore {
                DayView(eventModel: eventModel)
            }
            else {
                WelcomeView(eventModel: eventModel, signInSuccess: $signInSuccess)
            }
        }
    }
}
