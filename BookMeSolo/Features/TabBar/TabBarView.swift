//
//  TabBarView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 12/05/25.
//

import Foundation
import SwiftUI
import TipKit

struct RoomsTip: Tip {
    var title: Text { Text("Book a room") }
    var message: Text? { Text("Book a custom room with your preferred size and amenities") }
//    var image: Image? { Image(systemName: "arrow.down.circle") }
}

struct TabBarView: View {
    var tip = RoomsTip()
    @Environment(\.modelContext) private var context
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.text
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        
        let segmentAppearance = UISegmentedControl.appearance()
        segmentAppearance.selectedSegmentTintColor = UIColor.button
        segmentAppearance.backgroundColor = UIColor.primer
        let normalAttrs = [NSAttributedString.Key.foregroundColor: UIColor.text]
        let selectedAttrs = [NSAttributedString.Key.foregroundColor: UIColor.primer]
        segmentAppearance.setTitleTextAttributes(normalAttrs, for: .normal)
        segmentAppearance.setTitleTextAttributes(selectedAttrs, for: .selected)

        UITabBar.appearance().backgroundColor = UIColor.darker
    }
    
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "star"){
                DashboardView(context: context)
            }
            Tab("Rooms", systemImage: "star"){
                RoomsView(context: context)
            }
            Tab("History", systemImage: "star"){
                HistoryView(context: context)
            }
        }
        .tint(.button)
    }
}

#Preview {
    TabBarView()
        .modelContainer(SampleData.shared.modelContainer)
        .preferredColorScheme(.dark)
}
