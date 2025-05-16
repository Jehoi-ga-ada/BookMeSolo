//
//  RoomsViewModel.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 13/05/25.
//

import Foundation
import SwiftData

/// Simple ViewModel: separate loading and searching of rooms.
final class RoomsViewModel: ObservableObject {
    @Published var rooms: [CollabRoomModel] = []
    @Published var searchText: String = "" {
        didSet { applySearch() }
    }

    private let context: ModelContext
    private var allRooms: [CollabRoomModel] = []

    init(context: ModelContext) {
        self.context = context
        loadRooms()
    }
}

private extension RoomsViewModel {
    func loadRooms() {
        Task {
            let descriptor = FetchDescriptor<CollabRoomModel>()
            do {
                let fetched = try context.fetch(descriptor)
                DispatchQueue.main.async {
                    self.allRooms = fetched
                    self.applySearch()
                }
            } catch {
                DispatchQueue.main.async {
                    self.allRooms = []
                    self.rooms = []
                }
            }
        }
    }

    func applySearch() {
        rooms = searchText.isEmpty
            ? allRooms
            : allRooms.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        rooms = rooms.sorted(by: {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        })
    }
}
