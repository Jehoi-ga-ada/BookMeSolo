//
//  Dashboard.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 09/05/25.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Picker("", selection: $viewModel.selectedTab) {
                    ForEach(DashboardTab.allCases) { tab in
                        Text(tab.id).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                    
                DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .padding(.horizontal)

                Group {
                    switch viewModel.selectedTab {
                    case .recentlyBooked:
                        DashboardCardView(date: viewModel.selectedDate, selectedTab: viewModel.selectedTab)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    case .nearestSession:
                        DashboardCardView(date: viewModel.selectedDate, selectedTab: viewModel.selectedTab)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                Spacer()
            }
            .background(Color.primer)
            .navigationTitle(Text("Dashboard"))
        }
    }
}

#Preview {
    DashboardView()
}
