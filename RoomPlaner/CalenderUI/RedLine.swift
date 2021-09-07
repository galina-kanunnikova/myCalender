//
//  redLine.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 06.01.21.
//

import Foundation
import SwiftUI

struct redLine: View {
    @State private var scale: CGFloat = 1.0
    @State var currentTime =  Date()
    @State private var offset: CGFloat = 0
    @State private var min = 0
    @State private var hour = 0
    @ObservedObject var roomModel : RoomModel
    
    var body: some View {
        
          HStack(spacing: 0) {
            currentTimeView(currentTime)
                  .font(.system(size: 12))
                  .foregroundColor(.red)
                .frame(width: style.timeColumnWidth, height: 2)
              
            line()
                .frame(width: roomColumnWidth(rooms: roomModel.rooms.count)*CGFloat(roomModel.rooms.count), height: 2)
                .background(Color.red)
                      
          }
          .offset(x: 0.0, y: self.offset)
          .frame(width: 1000, height: 2, alignment:  .top)
          .onAppear {
            self.min =  currentTime.minute
            hour = self.currentTime.hour
                  
                      return  withAnimation{
                        let minHeight = oneMinHeight*CGFloat(min)
                    
                        if hour >= 12 {
                            self.offset = (CGFloat(hour-12)*style.rowHeight ) + minHeight
                        }else{
                            self.offset = -(CGFloat(12 - hour)*style.rowHeight ) + minHeight// - 9
                        }
                      }
                }
          .onReceive(timer) { input in
                  self.currentTime = input
                  self.offset =  self.offset + oneMinHeight
                  
          }
    }
    
}




struct line: View {
    var body: some View {
                Text(" ")
            
    }
}
