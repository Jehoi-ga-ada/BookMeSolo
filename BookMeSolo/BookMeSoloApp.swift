//
//  BookMeSoloApp.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 09/05/25.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct BookMeSoloApp: App {
    init() {
        // Remove all saved tip states:
        try? Tips.resetDatastore()
        // Then set up TipKit; .immediate ensures no frequency cap:
        try? Tips.configure([
            .displayFrequency(.immediate)
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .modelContainer(SampleData.shared.modelContainer)
                .preferredColorScheme(.dark)
        }
    }
}
