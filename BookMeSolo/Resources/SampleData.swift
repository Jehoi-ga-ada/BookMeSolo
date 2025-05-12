//
//  SampleData.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 12/05/25.
//
import Foundation
import SwiftData


@MainActor
class SampleData {
    static let shared = SampleData()


    let modelContainer: ModelContainer


    var context: ModelContext {
        modelContainer.mainContext
    }


    private init() {
        let schema = Schema([
            BookingReceiptModel.self,
            CollabRoomModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)


        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        
        for CollabRoom in CollabRoomModel.sampleData {
            context.insert(CollabRoom)
        }
        
        for BookingReceipt in BookingReceiptModel.sampleData {
            context.insert(BookingReceipt)
        }
        
    }
}
