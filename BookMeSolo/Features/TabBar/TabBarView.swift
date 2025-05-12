//
//  TabBarView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 12/05/25.
//

import Foundation
import SwiftUI

struct TabBarView: View {
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
                DashboardView()
            }
            Tab("Rooms", systemImage: "star"){
                RoomsView()
            }
            Tab("History", systemImage: "star"){
                HistoryView()
            }
        }
        .tint(.button)
    }
}

#Preview {
    TabBarView()
        .modelContainer(SampleData.shared.modelContainer)
}
