//
//  Dashboard.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 09/05/25.
//

import Foundation
import SwiftUI
import SwiftData
import TipKit

struct DateTip: Tip {
    var title: Text { Text("Date Selector") }
    var message: Text? { Text("Select a date to book.") }
//    var image: Image? { Image(systemName: "arrow.down.circle") }
}


struct RecentNearestTip: Tip {
    var title: Text { Text("Recent & Nearest") }
    var message: Text? { Text("Select to see your recent bookings or nearest available slots.") }
//    var image: Image? { Image(systemName: "arrow.down.circle") }
}

struct BookTip: Tip {
    var title: Text { Text("Book the Session") }
    var message: Text? { Text("Book the collab room based on the session and the date you selected.") }
}

struct DashboardView: View {
        
    @StateObject private var viewModel: DashboardViewModel
    @State
    var tips = TipGroup(.ordered) {
        RecentNearestTip()
        DateTip()
        BookTip()
    }
    
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primer.ignoresSafeArea()
                VStack(alignment: .leading) {
                    Picker("", selection: $viewModel.selectedTab) {
                        ForEach(DashboardTab.allCases) { tab in
                            Text(tab.id).tag(tab)
                        }
                    }
                    .presentationCompactAdaptation(.popover)
                    .popoverTip(tips.currentTip as? RecentNearestTip)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .presentationCompactAdaptation(.popover)
                        .popoverTip(tips.currentTip as? DateTip)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .padding(.all)
                    
                    switch viewModel.selectedTab {
                    case .recentlyBooked:
                        ScrollView {
    
                            ForEach(viewModel.recentlyBooked) { receipt in
                                let isFirstReceipt = receipt.id == viewModel.recentlyBooked.first?.id
                                DashboardCardView(date: viewModel.selectedDate, receipt: receipt, tipGroup: tips, isEligible: isFirstReceipt)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            }
                            
                        }
                    case .nearestSession:
                        if viewModel.nearestAvailable.isEmpty {
                            Text("No upcoming sessions")
                                .frame(width: .infinity, alignment: .center)
                                .foregroundStyle(.button)
                                .padding(.horizontal)
                        } else {
                            ScrollView {
                                
                                ForEach(viewModel.nearestAvailable) { slot in
                                    let nearest = slot.id == viewModel.nearestAvailable.first?.id
                                    DashboardCardView(date: viewModel.selectedDate,
                                                      nearestSession: slot, tipGroup: tips, isEligible: nearest)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                }
                                
                            }
                        }
                    }
                    Spacer()
                }
                .navigationTitle(Text("Dashboard"))
            }
        }
    }
}

//#Preview {
//    DashboardView()
//}
