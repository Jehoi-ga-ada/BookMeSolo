//
//  DataManager.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 14/05/25.
//

import Foundation
import SwiftData

@MainActor
public final class DataManager {
    public static let shared = DataManager()
    private let container: ModelContainer
    
    private init() {
        // Register your models here
        container = try! ModelContainer(for: CollabRoomModel.self, BookingReceiptModel.self)
    }
    
    @discardableResult
    func book(
        in context: ModelContext,
        room: CollabRoomModel,
        date: Date,
        session: String) -> BookingReceiptModel? {
            // 1) Validate required fields
            guard !session.isEmpty else {
                return nil
            }
            
            // 2) Create model
            let receipt = BookingReceiptModel(
                collab: room,
                date: date,
                session: session
            )
            
            // 3) Persist
            context.insert(receipt)
            do {
                try container.mainContext.save()
                return receipt
            } catch {
                // swallow or log error, but don't throw
                print("❌ DataManager.book failed:", error)
                return nil
            }
        }
    
    /// Update an existing booking’s date and/or session.
    @discardableResult
    func edit(
        in context: ModelContext,
        booking: BookingReceiptModel,
        newDate: Date? = nil,
        newSession: String? = nil
    ) -> Bool {
        if let d = newDate {
            booking.date = d
        }
        if let s = newSession, !s.isEmpty {
            booking.session = s
        }
        do {
            try context.save()
            return true
        } catch {
            print("❌ DataManager.edit save error:", error)
            return false
        }
    }
    
    /// Delete a booking from the given context.
    @discardableResult
    func delete(
        in context: ModelContext,
        booking: BookingReceiptModel
    ) -> Bool {
        context.delete(booking)
        do {
            try context.save()
            print("deleted")
            return true
        } catch {
            print("❌ DataManager.delete save error:", error)
            return false
        }
    }
}
