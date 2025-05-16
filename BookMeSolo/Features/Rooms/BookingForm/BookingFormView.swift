//
//  BookingFormView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 09/05/25.
//

import Foundation
import SwiftUI

struct BookingFormView: View {
    @Environment(\.modelContext) private var context
    @StateObject var viewModel: BookingFormViewModel
    
    init(room: CollabRoomModel) {
        _viewModel = StateObject(wrappedValue: BookingFormViewModel(room: room))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primer.ignoresSafeArea()
                VStack {
                    DatePicker("Pick a date", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.all)
                    
                    VStack(alignment: .leading) {
                        ForEach(viewModel.availability.keys.sorted(), id: \.self) { session in
                            let isAvailable = viewModel.availability[session] ?? false
                            HStack {
                                Text(session)
                                    .font(.subheadline)
                                Spacer()
                                Text(isAvailable ? "Available" : "Unavailable")
                                    .foregroundColor(isAvailable ? .green : .red)
                                    .padding(.horizontal, 10)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if isAvailable {
                                    viewModel.selectedSession = session
                                }
                            }
                            .padding()
                            .background(viewModel.selectedSession == session ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {onAction(room: viewModel.room, date: viewModel.selectedDate, session: viewModel.selectedSession!)}) {
                        Text("Book")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .tint(.primer)
                            .background(.button)
                            .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                }
                .navigationTitle(viewModel.room.name)
                .alert("Booking Successful", isPresented: $viewModel.showSuccessAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(successMessage)
                }
            }
        }
    }
    
    private var successMessage: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: viewModel.selectedDate)
        let session = viewModel.selectedSession ?? ""
        return "Your booking for \(viewModel.room.name) on \(dateString) during \(session) has been confirmed."
    }
    
    private func onAction(room: CollabRoomModel, date: Date, session: String) {        // 2) Perform the booking
        let result = DataManager.shared.book(
            in: context,
            room: room,
            date: date,
            session: session
        )

        // 3) Show success alert if result non‑nil
        if result != nil {
            viewModel.showSuccessAlert = true
        }
    }

}

#Preview {
    BookingFormView(room: CollabRoomData.generateCollabRooms()[0])
}
