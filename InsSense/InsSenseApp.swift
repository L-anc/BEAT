//
//  InsSenseApp.swift
//  InsSense
//
//  Created by Controllab on 3/29/26.
//

import SwiftUI
import SwiftData

@main
struct InsSenseApp: App {
    @State private var container: ModelContainer
    @State private var packetStore: PacketStore
    @State private var healthKitManager: HealthKitManager
    
    init() {
        let container = try! ModelContainer(for: DataPacket.self, PacketSummary.self)
        let store = PacketStore(context: container.mainContext)
        _container = State(initialValue: container)
        _packetStore = State(initialValue: store)
        _healthKitManager = State(initialValue: HealthKitManager(
            context: container.mainContext,
            packetStore: store
        ))
        
        #if DEBUG
        UserDefaults.standard.removeObject(forKey: "firstLaunch")
        UserDefaults.standard.removeObject(forKey: "HKLastFetchDate")
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(healthKitManager)
                .environment(packetStore)
                .modelContainer(container)
                .task {
                    try? await healthKitManager.requestAuthorization()
                    healthKitManager.startObserving()
                    
                    #if DEBUG
                    print("-----------------------------")
                    print("Starting debug run at: \(Date.now)")
                    #endif
                }
        }
    }
}
