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
    
    var body: some View {
        return Group {
            if signInSuccess {
                DayView()
            }
            else {
                WelcomeView(signInSuccess: $signInSuccess)
            }
        }
    }
}
