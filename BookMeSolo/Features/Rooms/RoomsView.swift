//
//  RoomsView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 09/05/25.
//

import Foundation
import SwiftUI
import SwiftData
import TipKit

struct PressTip: Tip {
    var title: Text { Text("Press the card to show the booking form.") }
//    var message: Text? { Text("With the booking form you can book a room.") }
}

struct RoomsView: View {
    @StateObject private var viewModel: RoomsViewModel
    var tip = PressTip()
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: RoomsViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primer.ignoresSafeArea()
                VStack {
                    ScrollView {
                        ForEach(viewModel.rooms) { room in
                            if room.id == viewModel.rooms.first?.id {
                                NavigationLink(destination: BookingFormView(room: room)) {
                                    RoomsCardView(room: room)
                                        .popoverTip(tip)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                }
                            }
                            else{
                                NavigationLink(destination: BookingFormView(room: room)) {
                                    RoomsCardView(room: room)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                }
                            }
                        }
                    }
                }
                .navigationTitle(Text("Rooms"))
                .searchable(text: $viewModel.searchText)
            }
        }
    }
}

//#Preview {
//    RoomsView()
//}
