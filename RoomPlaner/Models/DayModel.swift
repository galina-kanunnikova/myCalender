//
//  DayModel.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 12.01.21.
//

import Foundation
import Combine
import CoreData
import UIKit


class DayModel: ObservableObject {
    @Published var day : Date = Date()
    var cancellationToken: AnyCancellable?
    
    init() {
        getDate()
    }
    
}

extension DayModel {
    
    // Subscriber implementation
    func getDate() {
        self.day = Date()
    }
    
}

