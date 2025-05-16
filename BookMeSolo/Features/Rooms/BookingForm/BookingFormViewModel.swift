//
//  BookingFormViewModel.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 14/05/25.
//

import Foundation
import SwiftData

final class BookingFormViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var selectedSession: String?
    @Published var showSuccessAlert: Bool = false
    var room: CollabRoomModel
    var availability: [String: Bool] {
        room.availableSessions(on: selectedDate)
    }
    
    init(room: CollabRoomModel) {
        self.room = room
        selectedSession = availability.sorted { $0.key < $1.key }.first(where: { $0.value })?.key
    }

}
