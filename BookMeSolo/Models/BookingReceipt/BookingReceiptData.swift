//
//  BookingReceiptData.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 12/05/25.
//

import Foundation

final class BookingReceiptData {
    static func createDummyBookingReceipts() -> [BookingReceiptModel] {
        let session: [String] =
            [
                "08:45 - 09:55",
                "10:10 - 11:20",
                "11:35 - 12:45",
                "13:00 - 14:10",
                "14:25 - 15:35",
                "15:50 - 17:00"
            ]
        
        var dates = [Date]()
        for dayOffset in 0..<5 {
            if let newDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) {
                dates.append(newDate)
            }
        }
                
        let collabRooms: [CollabRoomModel] = CollabRoomModel.sampleData
                
        var bookingReceipts: [BookingReceiptModel] = []
        for i in 0..<5 {
            bookingReceipts.append(BookingReceiptModel(collab: collabRooms[i], date: dates[i], session: session[i]))
        }
        return bookingReceipts
    }
}

extension Date {
    /// Returns a random Date between the given start and end dates.
    static func random(between start: Date, and end: Date) -> Date {
        let lowerBound = min(start, end)
        let upperBound = max(start, end)
        let randomTimeInterval = TimeInterval.random(in: lowerBound.timeIntervalSince1970...upperBound.timeIntervalSince1970)
        return Date(timeIntervalSince1970: randomTimeInterval)
    }
}
