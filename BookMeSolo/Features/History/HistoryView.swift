//
//  HistoryView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 09/05/25.
//

import Foundation
import SwiftData
import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primer.ignoresSafeArea()
                VStack {
                    histories
                }
                .searchable(text: $viewModel.searchText)
                .navigationTitle(Text("History"))
            }
        }
    }
    
    var histories: some View {
        ScrollView {
            ForEach(viewModel.groupedReceipts, id: \.key) { dateKey, receipts in
                Section(header:
                            Text(dateKey)
                    .font(.system(size: 30))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 12)
                ) {
                    ForEach(receipts) { receipt in
                        HistoryCardView(receipt: receipt, onDelete: viewModel.delete)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

//#Preview {
//    HistoryView()
//}
