//
//  CalenderCell.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 06.01.21.
//

import Foundation
import SwiftUI

struct calenderCell: View {
    @ObservedObject var roomModel : RoomModel
  
    var body: some View {
        VStack() {
        }
        .foregroundColor(.white)
        .font(.largeTitle)
        .frame(width: roomColumnWidth(rooms: roomModel.rooms.count), height: style.rowHeight)
        .background(Color(UIColor.systemBackground))
       // .border(Color.gray)
    }
    
}

