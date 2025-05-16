import Foundation
import SwiftData

enum DashboardTab: String, CaseIterable, Identifiable {
    case recentlyBooked = "Recently Booked"
    case nearestSession  = "Nearest Session"

    var id: String { rawValue }
}

/// Represents an available session slot for a room.
struct AvailableSession: Identifiable {
    let id = UUID()
    let room: CollabRoomModel
    let session: String
}

final class DashboardViewModel: ObservableObject {
    // MARK: Inputs
    @Published var selectedTab: DashboardTab = .recentlyBooked { didSet { computeAll() } }
    @Published var selectedDate: Date = Date()           { didSet { computeAll() } }

    // MARK: Outputs
    @Published private(set) var recentlyBooked: [BookingReceiptModel] = []
    @Published private(set) var nearestAvailable: [AvailableSession]  = []

    // MARK: Internals
    private let context: ModelContext
    private var allReceipts: [BookingReceiptModel] = []
    private var allRooms:    [CollabRoomModel] = []

    init(context: ModelContext) {
        self.context = context
        fetchData()
    }

    // MARK: Data Fetching
    private func fetchData() {
        Task {
            let receiptDesc = FetchDescriptor<BookingReceiptModel>()
            let roomDesc    = FetchDescriptor<CollabRoomModel>()
            do {
                async let receipts = try context.fetch(receiptDesc)
                async let rooms    = try context.fetch(roomDesc)
                let (fetchedReceipts, fetchedRooms) = try await (receipts, rooms)

                await MainActor.run {
                    self.allReceipts = fetchedReceipts
                    self.allRooms    = fetchedRooms
                    self.computeAll()
                }
            } catch {
                await MainActor.run {
                    self.allReceipts      = []
                    self.allRooms         = []
                    self.recentlyBooked   = []
                    self.nearestAvailable = []
                }
            }
        }
    }

    // MARK: Computation
    private func computeAll() {
        computeRecentlyBooked()
        computeNearestAvailable()
    }

    /// Latest 3 bookings for the selected date, sorted newest first.
    private func computeRecentlyBooked() {
        let filtered = allReceipts
            .sorted { $0.date > $1.date }
        recentlyBooked = Array(filtered.prefix(3))
    }

    /// Finds earliest free sessions across all rooms by lexicographically comparing "HH:mm" prefixes.
    private func computeNearestAvailable() {
        // Collect free sessions
        let sessions: [AvailableSession] = allRooms.flatMap { room in
            room.availableSessions(on: selectedDate).compactMap { (session, isFree) in
                guard isFree else { return nil }
                return AvailableSession(room: room, session: session)
            }
        }

        // No availability
        guard !sessions.isEmpty else {
            nearestAvailable = []
            return
        }

        // Extract "HH:mm" and find earliest
        let earliestTime = sessions
            .map(\.session)
            .map { String($0.prefix(5)) }
            .min()!

        // Filter sessions starting at earliestTime
        nearestAvailable = sessions.filter { $0.session.hasPrefix(earliestTime) }
    }
}
