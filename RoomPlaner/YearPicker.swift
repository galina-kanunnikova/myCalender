//
//  YearPicker.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 02.09.21.
//

import Foundation
import SwiftUI

class PassYear: ObservableObject {
    @Published var year = 0
    @Published var passed = false
}

struct yearPicker: View {
    @StateObject var passYear = PassYear()
    @EnvironmentObject var passyear :  PassYear
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
                HStack(spacing: 20){
                    if !passYear.passed {
                        year_view(passyear: passYear)
                    }else {
                        months_view(passyear: passYear)
                    }
                }
        }
    }
}


struct year_view: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var passyear: PassYear
    var body: some View {
        
      VStack(spacing: 20) {
      
        Text("Wähle ein Jahr ")
             .font(Font.headline.weight(.light))
             .foregroundColor(colorScheme == .dark ? .white : .black)
      
        let  yearsRange = calculateYearsRange()
        ForEach(yearsRange, id: \.self) { year in
        
           Button(action: {
            passyear.passed = true
            passyear.year = year
            // dayModel.day = day
           //  eventModel.updateEvents()
           }){
             Text(String(year)).foregroundColor(.white)
           }
                 .foregroundColor(.black)
                 .frame(width: 50, height: 50)
               //  .background(Color.white)
                 .background(Color.blue)
                 .cornerRadius(23)
                 .font(.system(size: 15))
       }
     }
      .frame(width: style.screenWidth,height: style.screenWidth)
    }
    
    func calculateYearsRange() -> [Int]{
        var yearsRange : [Int] = []
        let year = Date().year
        for i in 0..<4 {
            yearsRange.append(year + i)
        }
        return yearsRange
    }
}

struct months_view: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var passyear: PassYear
    var body: some View {
        
      VStack(spacing: 50){
        
        HStack{
            Button(action: {
             passyear.passed = false
             
            }){
              Image("back-48-green")
            }
                  .foregroundColor(.black)
                  .frame(width: 50, height: 50)
            Spacer()
            Text("Wähle einen Monat ")
             .font(Font.headline.weight(.light))
             .foregroundColor(colorScheme == .dark ? .white : .black)
                
            
        }
        HStack(spacing: 20) {
         ForEach(0..<4 ,id: \.self) { row in
            
            VStack(spacing: 20){
             ForEach(0..<3, id: \.self) { column in
        
                Button(action: {
            // dayModel.day = day
           //  eventModel.updateEvents()
                }){
                  Text(style.months[row + column*4])
                    .foregroundColor(.white)
                }
                 .foregroundColor(.black)
                 .frame(width: 50, height: 50)
                 .background(Color.blue)
                 .cornerRadius(23)
                 .font(.system(size: 15))
             }
           }
          }
        }.padding(.bottom, 50)
    }.frame(width: style.screenWidth,height: style.screenWidth)
  }
   
}
