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
    @Published var selectedDay : Date = Date()
    @Published var startDay : Date = Date()
    @Published var pdfDate : Date = Date()
    var cancellationToken: AnyCancellable?
    
    init() {
        getDate()
    }
    
}

extension DayModel {
    
    // Subscriber implementation
    func getDate() {
        self.startDay = Date()
        self.selectedDay = Date()
    }
    
}

