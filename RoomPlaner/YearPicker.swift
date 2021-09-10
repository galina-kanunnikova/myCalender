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
    @ObservedObject var eventModel : EventModel
    var toPDF : Bool
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
                HStack(spacing: 20){
                    if !passYear.passed {
                        year_view(passyear: passYear, toPDF: toPDF)
                    }else {
                        months_view(passyear: passYear, eventModel: eventModel, toPDF: toPDF)
                    }
                }
        }
    }
}


struct year_view: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var passyear: PassYear
    @State var width : CGFloat = 0
    var toPDF : Bool
    var body: some View {
        
      VStack(spacing: 20) {
      
        Text("Select a year")
             .font(Font.headline.weight(.light))
             .foregroundColor(colorScheme == .dark ? .white : .black)
      
        let  yearsRange = calculateYearsRange()
        ForEach(yearsRange, id: \.self) { year in
        
           Button(action: {
            passyear.passed = true
            passyear.year = year
            // dayModel.startDay = day
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
      .frame(width: width,height: style.screenWidth)
      .onAppear{
        if UIDevice.current.userInterfaceIdiom == .pad  {
            width = style.screenWidth/1.2
        }else {width = style.screenWidth}
       
      }
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
    @Environment(\.presentationMode) var presentationMode
    @StateObject var passyear: PassYear
    @ObservedObject var eventModel : EventModel
    @State var width : CGFloat = 0
    var toPDF : Bool
    @State var show_pdf_preview : Bool = false
    var body: some View {
        
      VStack(spacing: 50){
        
        HStack{
            Spacer()
            Button(action: {
             passyear.passed = false
             
            }){
              Image("back-48-green")
            }
                  .foregroundColor(.black)
                  .frame(width: 50, height: 50)
            Spacer()
            Text("Select a month")
             .font(Font.headline.weight(.light))
             .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            Spacer()
            
        }
        HStack(spacing: 20) {
         ForEach(0..<4 ,id: \.self) { row in
            
            VStack(spacing: 20){
             ForEach(0..<3, id: \.self) { column in
        
                Button(action: {
                    let month = row + column*4 + 1
                    if !toPDF {
                       eventModel.dayModel.startDay = Date.from(year: passyear.year, month: month, day: 1)
                       eventModel.dayModel.selectedDay = eventModel.dayModel.startDay
                       self.presentationMode.wrappedValue.dismiss()
                        eventModel.updateEvents()
                   }else {
                       eventModel.dayModel.pdfDate =  Date.from(year: passyear.year, month: month, day: 1)
                    show_pdf_preview = true
                   }
                }){
                  Text(style.months[row + column*4])
                    .foregroundColor(.white)
                }
                 .foregroundColor(.black)
                 .frame(width: 50, height: 50)
                 .background(Color.blue)
                 .cornerRadius(23)
                 .font(.system(size: 15))
                 .sheet(isPresented: $show_pdf_preview) {
                   pdf_view(eventModel: eventModel)
                 }
             }
           }
          }
        }.padding(.bottom, 50)
      }.frame(width: width,height: style.screenWidth)
      .onAppear{
        if UIDevice.current.userInterfaceIdiom == .pad  {
            width = style.screenWidth/1.2
        }else {width = style.screenWidth}
       
      }
  }
   
}
