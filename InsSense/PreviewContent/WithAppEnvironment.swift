//
//  AppEnvironment.swift
//  InsSense
//
//  Created by Controllab on 4/10/26.
//

import SwiftUI
import SwiftData

#if DEBUG
extension View {
    func withAppEnvironment() -> some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: DataPacket.self, PacketSummary.self, configurations: config)
        let store = PacketStore(context: container.mainContext)
        let hkManager = HealthKitManager(context: container.mainContext, packetStore: store)
        
        for packet in DataPacket.sampleData {
                container.mainContext.insert(packet)
        }
        
        return self
            .modelContainer(container)
            .environment(store)
            .environmentObject(hkManager)
    }
}
#endif
