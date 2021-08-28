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
        .frame(width: roomColumnWidth(rooms: roomModel.visibleRooms.count), height: style.rowHeight)
        .background(Color.white)
        .border(Color.gray)
    }
    
}
