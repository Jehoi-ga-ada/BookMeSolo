//
//  HistoryViewModel.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 13/05/25.
//

import SwiftUI
import Foundation
import SwiftData

final class HistoryViewModel: ObservableObject {
    @Published var searchText: String = "" {
        didSet {
            applySearch()
        }
    }
    @Published var groupedReceipts: [(key: String, value: [BookingReceiptModel])] = []
    
    private let context: ModelContext
    @Published var allHistory: [BookingReceiptModel] = []
    @Published var histories: [BookingReceiptModel] = []
    
    // Helper to format date
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    init(context: ModelContext) {
        self.context = context
        loadHistory()
    }
    
    
    func delete(_ booking: BookingReceiptModel) {
        context.delete(booking)
        do {
            try context.save()
            print("deleted")
        } catch {
            print("⚠️ Failed to delete booking:", error)
        }
        // Re‑load from store
        loadHistory()
    }
}

private extension HistoryViewModel {
    func loadHistory() {
        Task {
            let descriptor = FetchDescriptor<BookingReceiptModel>()
            do {
                let fetched = try context.fetch(descriptor)
                DispatchQueue.main.async {
                    self.allHistory = fetched
                    self.applySearch()
                }
            } catch {
                DispatchQueue.main.async {
                    self.allHistory = []
                    self.histories = []
                }
            }
        }
    }
    
    func applySearch() {
        histories = searchText.isEmpty
        ? allHistory
        : allHistory.filter { $0.collab.name.localizedCaseInsensitiveContains(searchText)
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let grouped = Dictionary(grouping: histories) { receipt -> String in
            let receiptDate = calendar.startOfDay(for: receipt.date)
            if receiptDate == today {
                return "Today"
            } else {
                return dateFormatter.string(from: receiptDate)
            }
        }
        
        // Sort by date descending
        groupedReceipts = grouped.sorted {
            let lhsDate = $0.key == "Today" ? Date() : dateFormatter.date(from: $0.key) ?? Date.distantPast
            let rhsDate = $1.key == "Today" ? Date() : dateFormatter.date(from: $1.key) ?? Date.distantPast
            return lhsDate < rhsDate // Use > for descending
        }
    }
}
