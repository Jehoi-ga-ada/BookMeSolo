//
//  DashboardViewModel.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 12/05/25.
//

import SwiftUI
import Foundation

enum DashboardTab: String, CaseIterable, Identifiable {
    case recentlyBooked = "Recently Booked"
    case nearestSession = "Nearest Session"

    var id: String { rawValue }
}

final class DashboardViewModel: ObservableObject {
    let tabs = ["Recently Booked", "Nearest Session"]
    
    // Published properties for state
    @Published var selectedTab: DashboardTab = .recentlyBooked
    @Published var selectedDate: Date = Date()
}
