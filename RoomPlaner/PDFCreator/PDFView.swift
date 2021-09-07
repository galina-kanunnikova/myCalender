//
//  PDFView.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 06.09.21.
//

import Foundation
import SwiftUI
import PDFKit


struct pdf_view: View {
    @State private var showShareSheet = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var eventModel: EventModel
    @Environment(\.colorScheme) var colorScheme
    @State  var title: String = ""
  //  let  documentData: Data

       var body: some View {
        /*   VStack(alignment: .leading) {
               Text("PSPDFKit SwiftUI")
                   .font(.largeTitle)
               HStack(alignment: .top) {
                   Text("Made with ❤ at WWDC19")
                       .font(.title)
                Button(action: {
                               self.showShareSheet = true
                           }) {
                               Text("Share Me").bold()
                           }
                }
             }
             //  PSPDFKitView(url: documentURL, configuration: configuration)
           .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: ["Hello World"])
           }*/
        
        PDFKitRepresentedView(PDFCreator(eventModel: eventModel).createFlyer())
           
       }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let  documentData: Data
    init(_ documentData: Data) {
        self.documentData = documentData
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: documentData)
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}


struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

