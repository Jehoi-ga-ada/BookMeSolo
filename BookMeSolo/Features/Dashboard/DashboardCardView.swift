import SwiftUI
import TipKit

/// A unified data model for the Dashboard card, either a booked receipt or an available session.
enum DashboardCardData {
    case booked(BookingReceiptModel)
    case available(room: CollabRoomModel, session: String)
}

struct DashboardCardView: View {
    let date: Date
    var receipt: BookingReceiptModel? = nil
    var nearestSession: AvailableSession? = nil
    let tipGroup: TipGroup
    let isEligible: Bool

    @Environment(\.modelContext) private var context
    
    @State private var showingSuccessAlert = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    let room = receipt?.collab ?? nearestSession!.room
                    let session = receipt?.session ?? nearestSession!.session
                    
                    Text(room.name)
                        .font(.system(size: 26, weight: .bold))
                    Text(session)
                        .font(.system(size: 22))
                    Text("Capacity: \(room.capacity)")
                        .font(.system(size: 18))
                    Text("Facilities: Big Desk, TV")
                        .font(.system(size: 18))
                }
                .foregroundColor(.text)
                
                Spacer()
                
                Image((receipt?.collab.imagePreviews.first ?? nearestSession!.room.imagePreviews.first) ?? "")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2))
            }
            .padding(.bottom)
            
            Button(action: onAction) {
                Text("Book")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .frame(height: 60)
                    .background(isBookable ? Color.button : Color.disabledButton)
                    .foregroundColor(.primer)
                    .cornerRadius(10)
            }
            .presentationCompactAdaptation(.popover)
            .popoverTip(
                isEligible
                ? (tipGroup.currentTip as? BookTip) : nil,
                arrowEdge: .bottom
            )
            .disabled(!isBookable)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 250)
        .background(Color.shadow)
    }
    
    // MARK: - Helpers
    private var isBookable: Bool {
        guard let room = receipt?.collab ?? nearestSession?.room,
              let session = receipt?.session ?? nearestSession?.session else { return false }
        let availability = room.availableSessions(on: date)
        return availability[session] ?? false
    }
    
    private func onAction() {
        
        // 1) Resolve room & session safely
        guard let room    = receipt?.collab ?? nearestSession?.room,
              let session = receipt?.session ?? nearestSession?.session
        else {
            return
        }

        // 2) Perform the booking
        let result = DataManager.shared.book(
            in: context, 
            room: room,
            date: date,
            session: session
        )

        // 3) Show success alert if result non‑nil
        if result != nil {
            showingSuccessAlert = true
        }
    }
}
