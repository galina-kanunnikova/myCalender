//
//  PDFCreator.swift
//  RoomPlaner
//
//  Created by Galina Kanunnikova on 06.09.21.
//

import Foundation
import PDFKit

class PDFCreator{
    let defaultOffset: CGFloat = 20
    let defaultOffset_y: CGFloat = 25//40
    var pageWidth = UIScreen.screenHeight
    var pageHeight = UIScreen.screenWidth
    var tabWidth: CGFloat = 0
    var horizontal_line_width: CGFloat = 0
    let cellHeight: CGFloat = CGFloat(150)
    let eventModel: EventModel
    init(eventModel: EventModel) {
        self.eventModel = eventModel
        if eventModel.roomModel.rooms.count >= 5 { //Landscape format
            pageWidth = UIScreen.screenHeight
            pageHeight = UIScreen.screenWidth
        }else {
            pageWidth = UIScreen.screenWidth
            pageHeight = UIScreen.screenHeight
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageWidth = pageWidth/1.2
            pageHeight = pageHeight/0.8
        }
        tabWidth = CGFloat((pageWidth - defaultOffset*2 - 50) / CGFloat(eventModel.roomModel.rooms.count))
        horizontal_line_width = CGFloat(eventModel.roomModel.rooms.count)*tabWidth + 50 + defaultOffset
    }
  
func createFlyer() -> Data {
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: UIGraphicsPDFRendererFormat())
    let tableDataHeaderTitles =  header(eventModel: eventModel)
    let tableDataItems = table_matrix()
    let numberOfElementsPerPage = calculateNumberOfElementsPerPage(with: pageRect)
    let tableDataChunked: [[[Any?]]] = tableDataItems.chunkedElements(into: numberOfElementsPerPage)
    let data = renderer.pdfData { context in
      for tableDataChunk in tableDataChunked {
            context.beginPage()
            let cgContext = context.cgContext
            drawDateTitle(drawContext: cgContext, pageRect: pageRect)
            drawTableHeaderRect(drawContext: cgContext, pageRect: pageRect)
            drawTableHeaderTitles(titles: tableDataHeaderTitles, drawContext: cgContext, pageRect: pageRect)
            drawTableContentInnerBordersAndText(drawContext: cgContext, pageRect: pageRect, tableDataItems: tableDataChunk)
        }
     }
     return data
}

    func calculateNumberOfElementsPerPage(with pageRect: CGRect) -> Int {
        let number = Int((pageRect.height - defaultOffset_y*4) / cellHeight)
            return number
        }

}

extension Array {
    func chunkedElements(into size: Int) -> [[Element]]{
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
// Drawings
extension PDFCreator {
    func header(eventModel: EventModel) -> [String]{
        var names : [String] = []
        names.append("day")
        for room in eventModel.roomModel.rooms{
            names.append(room.name!)
        }
        return names
    }
    func events_for_rooms() -> [[Event]]{
        var events_for_rooms : [[Event]] = []
        var idx = -1
        for room in eventModel.roomModel.rooms{
          idx = idx + 1
            events_for_rooms.append([])
            for event in eventModel.events_pdf(){
                if event.rooms?.contains(Int(room.id)) == true {
                    events_for_rooms[idx].append(event)
                }
            }
        }
        return events_for_rooms
    }
    
    func table_matrix() -> [[Any?]] {
        var matrix : [[Any?]] = []
        let rooms = eventModel.roomModel.rooms
        // empty matrix
        for day in 0..<31{
            matrix.append([]) // new line
            for room in rooms {
                matrix[day].append(day+1)
                matrix[day].append(nil)
            }
        }
        
         var last_edited_idx = 0
        // fill matrix
        for day in 0..<31{
            // devide events after day
            var i = (matrix.count - 31 )-1
            for event in eventModel.events_pdf(){
                var event_day = 0
                var string = event.date_start!.dd
                if string.first == "0" {
                    string.removeFirst()
                }
                event_day = Int(string)!
                if event_day == day + 1{
                    i = i + 1
                    for room_idx in 0..<rooms.count {
                        if event.rooms?.contains(room_idx) == true {
                            matrix[day + i][0] = day + 1
                            matrix[day + i][room_idx + 1] = event
                            last_edited_idx = day + 1
                            matrix.append([])
                            for room in rooms {
                                matrix[matrix.count - 1].append(31)
                                matrix[matrix.count - 1].append(nil)
                            }
                        }
                    }
                }
          }
      }
      
        var sorted_matrix = matrix.sorted{ ($0[0] as! Int) < ($1[0] as! Int) }
        var matrix_idx = 0
        for i in 0..<sorted_matrix.count{
            if sorted_matrix[i][0] as! Int == last_edited_idx {
                matrix_idx = i
            }
        }
   
        // update day number
        for i in matrix_idx + 1..<sorted_matrix.count{
            sorted_matrix[i][0] =  sorted_matrix[i - 1][0] as! Int + 1
            if sorted_matrix[i][0] as! Int > 31 {
                last_edited_idx = i
                break
            }
        }
        
        for i in last_edited_idx..<sorted_matrix.count{
            sorted_matrix.removeLast()
        }
        
        return sorted_matrix
    }
    
    func drawDateTitle(drawContext: CGContext, pageRect: CGRect) {
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
        let attributedTitle = NSAttributedString(string: eventModel.dayModel.pdfDate.mmYYYY.capitalized, attributes: titleAttributes)
        let textRect = CGRect(x:  defaultOffset,
                              y: defaultOffset ,
                              width: 100,
                              height: defaultOffset * 2)
        attributedTitle.draw(in: textRect)
    }
   
    func drawTableHeaderRect(drawContext: CGContext, pageRect: CGRect) {
        drawContext.saveGState()
        drawContext.setLineWidth(3.0)
        
        let tabX =  50
        // Draw header's 1 top horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: defaultOffset_y*2))
        drawContext.addLine(to: CGPoint(x: horizontal_line_width, y: defaultOffset_y*2))
        drawContext.strokePath()

        // Draw header's 1 bottom horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: defaultOffset_y * 4))
        drawContext.addLine(to: CGPoint(x: horizontal_line_width, y: defaultOffset_y * 4))
        drawContext.strokePath()

        // Draw header's  vertical lines
        drawContext.setLineWidth(2.0)
        drawContext.saveGState()
       
        drawContext.move(to: CGPoint(x:  defaultOffset, y: defaultOffset_y*2))
        drawContext.addLine(to: CGPoint(x: defaultOffset, y: defaultOffset_y * 4))
        drawContext.strokePath()
        drawContext.move(to: CGPoint(x: CGFloat(tabX) + defaultOffset, y: defaultOffset_y*2))
        drawContext.addLine(to: CGPoint(x: CGFloat(tabX) + defaultOffset, y: defaultOffset_y * 4))
        drawContext.strokePath()
        for verticalLineIndex in 1..<eventModel.roomModel.rooms.count*2 - 1 {
            let tabX = CGFloat(verticalLineIndex) * tabWidth
            drawContext.move(to: CGPoint(x: tabX + defaultOffset + 50, y: defaultOffset_y*2))
            drawContext.addLine(to: CGPoint(x: tabX + defaultOffset + 50, y: defaultOffset_y * 4))
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
        
        let tabX =  CGFloat(50)
        var attributedTitle = NSAttributedString(string: titles[0].capitalized, attributes: titleAttributes)
        var textRect = CGRect(x:defaultOffset ,
                              y: defaultOffset_y*2.5,
                              width: tabX,
                              height: defaultOffset * 2)
        attributedTitle.draw(in: textRect)

        attributedTitle = NSAttributedString(string: titles[1].capitalized, attributes: titleAttributes)
        textRect = CGRect(x: defaultOffset + 50,
                              y: defaultOffset_y*2.5,
                              width: tabWidth  ,
                              height: defaultOffset * 2)
        attributedTitle.draw(in: textRect)
       
        
        for titleIndex in 2..<titles.count {
            let attributedTitle = NSAttributedString(string: titles[titleIndex].capitalized, attributes: titleAttributes)
            let tabX = CGFloat(titleIndex) * tabWidth
            let textRect = CGRect(x: defaultOffset + tabX  ,
                                  y: defaultOffset_y*2.5,
                                  width: tabWidth,
                                  height: defaultOffset * 2)
            attributedTitle.draw(in: textRect)
        }
    }

    func drawTableContentInnerBordersAndText(drawContext: CGContext, pageRect: CGRect, tableDataItems: [[Any?]]) {
        drawContext.setLineWidth(1.0)
        drawContext.saveGState()

        let defaultStartY = defaultOffset_y * 4
        
        for day in 0..<tableDataItems.count {
            let yPosition = CGFloat(day) * cellHeight + defaultStartY
            // Draw content's elements texts
            let textFont = UIFont.systemFont(ofSize: 11.0, weight: .regular)
            let textFont_name = UIFont.systemFont(ofSize: 13.0, weight: .medium)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            let textAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont
            ]
            let textAttributes_name = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont_name
            ]
          
            var attributedText = NSAttributedString(string: "", attributes: textAttributes)
            for objIndex in 0..<tableDataItems[day].count {
                if objIndex == 0 { // Month Day
                    attributedText = NSAttributedString(string:  String(((tableDataItems[day][objIndex] as? Int) ?? 0)),
                                                        attributes: textAttributes)
                    let textRect = CGRect(x: defaultOffset,
                                          y: yPosition + 20 ,
                                          width: 50,
                                          height: cellHeight)
                    attributedText.draw(in: textRect)
                }else {
                    let text_name = """
                        \((tableDataItems[day][objIndex] as? Event)?.title ?? "none")
                        """
                    attributedText = NSAttributedString(string: text_name, attributes: textAttributes_name)
                    var textRect = CGRect(x: CGFloat(objIndex - 1) * CGFloat(tabWidth) + defaultOffset  + 50,
                                          y: yPosition ,
                                          width: tabWidth,
                                          height: 60)
                    if objIndex == 1 {
                        textRect = CGRect(x:  defaultOffset  + 50 ,
                                              y: yPosition ,
                                              width: CGFloat(tabWidth),
                                              height: 60)
                    }
                    attributedText.draw(in: textRect)
                    
                    let text_time = """
                        \((tableDataItems[day][objIndex] as? Event)?.date_start!.hhMM ?? "")  - \((tableDataItems[day][objIndex] as? Event)?.date_end!.hhMM ?? "")
                        """
                    attributedText = NSAttributedString(string: text_time, attributes: textAttributes)
                     textRect = CGRect(x: CGFloat(objIndex - 1) * CGFloat(tabWidth) + defaultOffset  + 50,
                                          y: yPosition + 45,
                                          width: tabWidth,
                                          height: 20)
                    if objIndex == 1 {
                        textRect = CGRect(x:  defaultOffset  + 50 ,
                                              y: yPosition + 45 ,
                                              width: CGFloat(tabWidth),
                                              height: 20)
                    }
                    attributedText.draw(in: textRect)
                    
                    let text_desc = """
                        Notiz : \((tableDataItems[day][objIndex] as? Event)?.desc ?? "")
                        """
                    attributedText = NSAttributedString(string: text_desc, attributes: textAttributes)
                     textRect = CGRect(x: CGFloat(objIndex - 1) * CGFloat(tabWidth) + defaultOffset  + 50,
                                          y: yPosition + 60,
                                          width: tabWidth,
                                          height: 80)
                    if objIndex == 1 {
                        textRect = CGRect(x:  defaultOffset  + 50 ,
                                              y: yPosition + 60 ,
                                              width: CGFloat(tabWidth),
                                              height: 90)
                    }
                    attributedText.draw(in: textRect)
                }
            }
            // Draw content's vertical lines
            for verticalLineIndex in 0..<eventModel.roomModel.rooms.count*2 + 1 {
                var tabX = CGFloat(verticalLineIndex - 1) * tabWidth
                if verticalLineIndex == 0 {
                    tabX = 0 - 50
                }
                if verticalLineIndex == 1 {
                    tabX = 50 - 50
                }
                drawContext.move(to: CGPoint(x: tabX + defaultOffset + 50, y: yPosition))
                drawContext.addLine(to: CGPoint(x: tabX + defaultOffset + 50, y: yPosition + cellHeight))
                drawContext.strokePath()
            }
            // Draw content's element bottom horizontal line
            drawContext.move(to: CGPoint(x: defaultOffset, y: yPosition ))
            drawContext.addLine(to: CGPoint(x: horizontal_line_width, y: yPosition ))
            drawContext.strokePath()
        }
        let yPosition = CGFloat(tableDataItems.count) * cellHeight + defaultStartY
        drawContext.move(to: CGPoint(x: defaultOffset, y: yPosition ))
        drawContext.addLine(to: CGPoint(x: horizontal_line_width, y: yPosition ))
        drawContext.strokePath()
        
        drawContext.restoreGState()
    }
}
