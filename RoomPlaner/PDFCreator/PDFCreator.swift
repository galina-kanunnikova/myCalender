//
//  PDFCreator.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 06.09.21.
//

import Foundation
import PDFKit

class PDFCreator{
    
    let eventModel: EventModel
    init(eventModel: EventModel) {
      self.eventModel = eventModel
    }
    
    let defaultOffset: CGFloat = 20
   //   let tableDataHeaderTitles: [String]
  //    let tableDataItems: [TableDataItem]
    
    func addTitle(pageRect: CGRect) -> CGFloat {
     
      let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
      let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
      let attributedTitle = NSAttributedString(
        string: eventModel.dayModel.pdfDate.ddMMyy,
        attributes: titleAttributes
      )
      let titleStringSize = attributedTitle.size()
      // 5
      let titleStringRect = CGRect(
        x: (pageRect.width - titleStringSize.width) / 2.0,
        y: 36,
        width: titleStringSize.width,
        height: titleStringSize.height
      )
      // 6
      attributedTitle.draw(in: titleStringRect)
      // 7
      return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    
func createFlyer() -> Data {
/*  let pdfMetaData = [
    kCGPDFContextCreator: "Flyer Builder",
    kCGPDFContextAuthor: "raywenderlich.com"
  ]*/
  //  let format = UIGraphicsPDFRendererFormat()
  //format.documentInfo = pdfMetaData as [String: Any]
    
    let pageWidth = UIScreen.screenWidth
    let pageHeight = UIScreen.screenHeight - 100
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: UIGraphicsPDFRendererFormat())
    let tableDataHeaderTitles =  header(eventModel: eventModel)
    let tableDataItems = events_for_rooms()
    let numberOfElementsPerPage = calculateNumberOfElementsPerPage(with: pageRect)
    let tableDataChunked: [[[Any?]]] = tableDataItems.chunkedElements(into: numberOfElementsPerPage)
    let data = renderer.pdfData { context in
        context.beginPage()
        let titleBottom = addTitle(pageRect: pageRect)
        for tableDataChunk in tableDataChunked {
            context.beginPage()
            let cgContext = context.cgContext
            drawTableHeaderRect(drawContext: cgContext, pageRect: pageRect)
            drawTableHeaderTitles(titles: tableDataHeaderTitles, drawContext: cgContext, pageRect: pageRect)
            drawTableContentInnerBordersAndText(drawContext: cgContext, pageRect: pageRect, tableDataItems: tableDataChunk)
        }
     }
     return data
}

    func calculateNumberOfElementsPerPage(with pageRect: CGRect) -> Int {
            let rowHeight = (defaultOffset * 3)
            let number = Int((pageRect.height - rowHeight) / rowHeight)
            return number
        }

}

extension Array {
    func chunkedElements(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
// Drawings
extension PDFCreator {
    func header(eventModel: EventModel) -> [String]{
        var names : [String] = []
        names.append("Tag")
        for room in eventModel.roomModel.rooms{
            names.append(room.name!)
        }
        return names
    }
    func events_for_rooms() -> [[Any?]]{
        var events_for_table : [[Any?]] = []
        var events : [[Event]] = []
        var idx = -1
        for room in eventModel.roomModel.rooms{
          idx = idx + 1
            events.append([])
            for event in eventModel.events_pdf(){
                if event.rooms?.contains(Int(room.id)) == true {
                    events[idx].append(event)
                }
            }
        }
        for day in 0..<31{
            
            var event : Event? = nil
            for room_idx in 0..<events.count   { // obj index
                for event_idx in 0..<events[room_idx].count{   // events for obj
                    let ev = events[room_idx][event_idx]
                    var dd_int = 0
                    var string = ev.date_start!.dd
                    string.removeFirst()
                    if string.first == "0" {
                        string.removeFirst()
                    }
                    dd_int = Int(string)!
                    if dd_int == day + 1 && room_idx == 0{
                        event = ev
                        events_for_table.append([])
                        events_for_table[events_for_table.count - 1].append(day + 1)
                        for room in eventModel.roomModel.rooms{
                            events_for_table[events_for_table.count - 1].append(nil)
                        }
                        events_for_table[events_for_table.count - 1][room_idx + 1] = ev
                        
                    }
                    if dd_int == day + 1 && room_idx > 0{
                        var i = 1
                        for event_pre in events[room_idx - 1] {
                            i = i + 1
                            if  ev.date_start!.hour == event_pre.date_start!.hour
                            {
                                events_for_table[events_for_table.count - i][room_idx + 1] = ev
                                break
                            }
                            
                        }
                    /*    if  ev.date_start!.hour != events[room_idx - 1][event_idx].date_start!.hour
                        {
                            events_for_table.append([])
                        }else {
                            print(room_idx - 1)
                            print(ev.date_start!.hour)
                            print(events[room_idx - 1][event_idx].date_start!.hour)
                            
                        }*/
                        event = ev
                       /* events_for_table[events_for_table.count - 1].append(day + 1)
                        for room in eventModel.roomModel.rooms{
                            events_for_table[events_for_table.count - 1].append(nil)
                        }
                        events_for_table[events_for_table.count - 1][room_idx + 1] = ev*/
                        
                    }
                    
                    
                }
            }
              //  _ = (event != nil) ? events_for_table[day].append(event) : events_for_table[day].append(nil)
                if event == nil {
                    events_for_table.append([])
                    events_for_table[events_for_table.count - 1].append(day + 1)
                    for room in eventModel.roomModel.rooms{
                        events_for_table[events_for_table.count - 1].append(nil)
                    }
                }
        }
        
        
        return events_for_table
    }
    func drawTableHeaderRect(drawContext: CGContext, pageRect: CGRect) {
        drawContext.saveGState()
        drawContext.setLineWidth(3.0)

        // Draw header's 1 top horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: defaultOffset))
        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: defaultOffset))
        drawContext.strokePath()

        // Draw header's 1 bottom horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: defaultOffset * 3))
        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: defaultOffset * 3))
        drawContext.strokePath()

        // Draw header's 3 vertical lines
        drawContext.setLineWidth(2.0)
        drawContext.saveGState()
        let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(eventModel.roomModel.rooms.count + 1)
        for verticalLineIndex in 0..<eventModel.roomModel.rooms.count + 2 {
            let tabX = CGFloat(verticalLineIndex) * tabWidth
            drawContext.move(to: CGPoint(x: tabX + defaultOffset, y: defaultOffset))
            drawContext.addLine(to: CGPoint(x: tabX + defaultOffset, y: defaultOffset * 3))
            drawContext.strokePath()
        }

        drawContext.restoreGState()
    }

    func drawTableHeaderTitles(titles: [String], drawContext: CGContext, pageRect: CGRect) {
        // prepare title attributes
        let textFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]

        // draw titles
        let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(eventModel.roomModel.rooms .count + 1)
        for titleIndex in 0..<titles.count {
            let attributedTitle = NSAttributedString(string: titles[titleIndex].capitalized, attributes: titleAttributes)
            let tabX = CGFloat(titleIndex) * tabWidth
            let textRect = CGRect(x: tabX + defaultOffset,
                                  y: defaultOffset * CGFloat(eventModel.roomModel.rooms.count + 1) / 2,
                                  width: tabWidth,
                                  height: defaultOffset * 2)
            attributedTitle.draw(in: textRect)
        }
    }

    func drawTableContentInnerBordersAndText(drawContext: CGContext, pageRect: CGRect, tableDataItems: [[Any?]]) {
        drawContext.setLineWidth(1.0)
        drawContext.saveGState()

        let defaultStartY = defaultOffset * CGFloat(eventModel.roomModel.rooms.count)
        
        for elementIndex in 0..<tableDataItems.count {
            let yPosition = CGFloat(elementIndex) * defaultStartY + defaultStartY

            // Draw content's elements texts
            let textFont = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            let textAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont
            ]
            let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(eventModel.roomModel.rooms.count + 1)
            var attributedText = NSAttributedString(string: "", attributes: textAttributes)
            for objIndex in 0..<tableDataItems[elementIndex].count {
                print(tableDataItems[elementIndex])
                if objIndex == 0 { // Month Day
                    attributedText = NSAttributedString(string:  String(tableDataItems[elementIndex][objIndex] as! Int),
                                                        attributes: textAttributes)
                }else {
                    let text = """
                        \((tableDataItems[elementIndex][objIndex] as? Event)?.title ?? "none")
                        \((tableDataItems[elementIndex][objIndex] as? Event)?.date_start!.hhMM ?? "")  - \((tableDataItems[elementIndex][objIndex] as? Event)?.date_end!.hhMM ?? "")
                        \((tableDataItems[elementIndex][objIndex] as? Event)?.description ?? "")
                        """
                    attributedText = NSAttributedString(string: text, attributes: textAttributes)
                   
                }
                let textRect = CGRect(x: CGFloat(objIndex) * tabWidth + defaultOffset,
                                      y: yPosition + defaultOffset  ,
                                      width: tabWidth,
                                      height: defaultOffset * 3)
                attributedText.draw(in: textRect)
            }

            // Draw content's 3 vertical lines
            for verticalLineIndex in 0..<4 {
                let tabX = CGFloat(verticalLineIndex) * tabWidth
                drawContext.move(to: CGPoint(x: tabX + defaultOffset, y: yPosition))
                drawContext.addLine(to: CGPoint(x: tabX + defaultOffset, y: yPosition + defaultStartY))
                drawContext.strokePath()
            }

            // Draw content's element bottom horizontal line
            drawContext.move(to: CGPoint(x: defaultOffset, y: yPosition + defaultStartY))
            drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: yPosition + defaultStartY))
            drawContext.strokePath()
        }
        drawContext.restoreGState()
    }
}
