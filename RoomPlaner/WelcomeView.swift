//
//  WelcomeView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 30.08.21.
//
import SwiftUI
import Foundation


struct WelcomeView: View {
    @ObservedObject var eventModel: EventModel
    @State  var title: String = ""
    @State  var objects: [String] = []
    @Binding var signInSuccess: Bool
    @State private var isShowingFirstView = true
    let my_timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{
          if isShowingFirstView{
            first_view()
                .background(Color(UIColor.systemBackground))
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
          }else {
            w_view(eventModel: eventModel, signInSuccess: $signInSuccess)
          }
        }.onReceive(my_timer) { input in
            isShowingFirstView = false
            my_timer.upstream.connect().cancel()
        }
  }
}


struct first_view: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Welcome to your Reservations Calendar !")
                .font(Font.system(size: 45, weight: .bold, design: .rounded))
                .frame(width: style.screenWidth/1.5)
                .modifier(FlowTextModifier(image:  Image("calender-100")))
            Spacer()
            Text("Made with ❤")
                .font(.title)
        }
    }
}

struct w_view: View {
    @ObservedObject var eventModel: EventModel
    @State  var title: String = ""
    @State  var objects: [String] = []
    @Binding var signInSuccess: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
              Spacer()
              Text("Please enter objects that you want to rent (at least 1) :")
              Spacer()
          
              TextField("Objekt Name", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize()
                
              ForEach(0..<objects.count,id: \.self) { i in

                 HStack {
                    Text(objects[i])
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .foregroundColor(colorScheme == .dark ? .white : .black)
                       .fixedSize()
                
                    Button("x") {
                        objects.remove(at: i)
                    }
                      .padding()
                      .foregroundColor(.red)
                      .font(.system(size: 30))
                   }
                 
             // Spacer()
             }
                if objects.count < 10 {
                    Button("+") {
                      objects.append(title)
                        title = ""
                     }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .buttonStyle(MyButtonStyle())
                    .clipShape(Circle())
                    .disabled(title == "")
                }
              
              Spacer()
            }.padding(.leading, 100).padding(.trailing, 100)
           
            Button("Weiter zum Kalender  >") {
                self.signInSuccess = true
                for i in 0 ..< objects.count{
                    eventModel.roomModel.saveRoomToLocalStorage(title: objects[i], id: i)
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                    eventModel.updateEvents()
                }
               
             }
            .buttonStyle(MyButtonStyle())
            .disabled(objects.count == 0)
            .padding()
            .foregroundColor(.white)
            .background(style.lightRed)
            .cornerRadius(25)
            .font(.system(size: 25))
            .frame(width:300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
        }
    }
}

public struct FlowTextModifier: ViewModifier {
    var image:Image
       @State var offset:CGPoint = .zero
       let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    ZStack(alignment: .center) {
                        self.image
                            .resizable()
                            .offset(x: self.offset.x - geo.size.width, y: self.offset.y)
                            .mask(content)
                        self.image
                            .resizable()
                            .offset(x: self.offset.x, y: self.offset.y)
                            .mask(content)
                            .onReceive(self.timer) { _ in
                                // Update Offset here
                                let newOffset = self.getNextOffset(size: geo.size, offset: self.offset)

                                if newOffset == .zero {
                                    self.offset = newOffset
                                    withAnimation(.linear(duration: 1)) {
                                        self.offset = self.getNextOffset(size: geo.size, offset: newOffset)
                                    }
                                } else {
                                    withAnimation(.linear(duration: 1)) {
                                        self.offset = newOffset
                                    }
                                }
                            }
                    }
                }
            )
    }
    func getNextOffset(size: CGSize, offset: CGPoint) -> CGPoint {
        var nextOffset = offset

        if nextOffset.x + (size.width / 10.0) > size.width {
            nextOffset.x = 0
        } else {
            nextOffset.x += size.width / 10.0
        }
        return nextOffset
    }
    
}
