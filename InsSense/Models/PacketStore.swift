//
//  PacketStore.swift
//  InsSense
//
//  Created by Controllab on 4/9/26.
//

import Foundation
import SwiftData

// Oldest packet stored locally
// Should be equivalent to model context window
//let StorageTime = Double(-3 * 3600)
let StorageTime = Double(-3.2*3600)

@Observable
class PacketStore {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // Local storage cut-off
    var cutoff: Date {
        Date.now.addingTimeInterval(StorageTime)
    }
    
    // MARK: - Fetching Packets
    
    // Fetches individual packet with unique UUID
    func fetchPacket(id: UUID) throws -> DecodedPacket? {
        let descriptor = FetchDescriptor<DataPacket>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first?.decoded()
    }
    
    // Fetches all packets in StorageTime window
    func fetchPackets() throws -> [DecodedPacket] {
        let descriptor = FetchDescriptor<DataPacket>(
            predicate: #Predicate { $0.startDate >= cutoff },
            sortBy: [SortDescriptor(\DataPacket.startDate, order: .reverse)]
        )
        return try context.fetch(descriptor).map { $0.decoded() }
    }
    
    // Fetches last n packets
    func fetchPackets(lastN: Int) throws -> [DecodedPacket] {
        var descriptor = FetchDescriptor<DataPacket>(
            predicate: #Predicate { $0.startDate >= cutoff },
            sortBy: [SortDescriptor(\DataPacket.startDate, order: .reverse)]
        )
        descriptor.fetchLimit = lastN
        return try context.fetch(descriptor).map { $0.decoded() }
    }
    
    // Fetches from date -> present
    func fetchPackets(from date: Date? = nil) throws -> [DecodedPacket] {
        let startDate = date ?? cutoff
        let descriptor = FetchDescriptor<DataPacket>(
            predicate: #Predicate { $0.startDate >= startDate },
            sortBy: [SortDescriptor(\DataPacket.startDate, order: .reverse)]
        )
        return try context.fetch(descriptor).map { $0.decoded() }
    }
    
    // MARK: - Fetching Summaries
    
    // Fetches individual summary with unique UUID
    func fetchSummary(id: UUID) throws -> PacketSummary? {
        let descriptor = FetchDescriptor<PacketSummary>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    // Fetches all packets in StorageTime window
    func fetchSummaries() throws -> [PacketSummary] {
        let descriptor = FetchDescriptor<PacketSummary>(
            predicate: #Predicate { $0.startDate >= cutoff },
            sortBy: [SortDescriptor(\PacketSummary.startDate, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    // MARK: - Deleting Packets & Summaries
    
    // Deletes expired packets and associated summaries
    func deleteExpiredPackets() throws {
        let descriptor = FetchDescriptor<DataPacket>(
            predicate: #Predicate { $0.startDate < cutoff }
        )
        let expired = try context.fetch(descriptor)
        expired.forEach { context.delete($0) }
        try context.save()
    }
}
