//
//  BookingReceiptModel.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 12/05/25.
//


//
//  BookingReceiptModel.swift
//  BookMe
//
//  Created by Jehoiada Wong on 26/03/25.
//

import Foundation
import SwiftData

@Model
class BookingReceiptModel: Identifiable{
    var id: UUID = UUID()
    var collab: CollabRoomModel
    var date: Date
    var session: String
    
    init(collab: CollabRoomModel, date: Date, session: String) {
        self.collab = collab
        self.date = date
        self.session = session
        
        // Link this booking with the corresponding collab room and person.
        collab.bookings.append(self)
    }
        
    static let sampleData = BookingReceiptData.createDummyBookingReceipts()
}
