//
//  Home.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI
import SwiftData

struct PacketView: View {
    @Environment(PacketStore.self) private var store
    @State private var summaries: [PacketSummary] = []
  
    var body: some View {
        NavigationStack {
            List(summaries) { summary in
                NavigationLink(destination: DetailView(packetID: summary.id)) {
                    CardView(summary: summary)
                }
                .listRowSeparator(.visible, edges: .bottom)
                .listRowSeparatorTint(.gray)
            }
            .navigationTitle("Data Packets")
            .task {
                summaries = (try? store.fetchSummaries()) ?? []
            }
        }
    }
}

#Preview {
    PacketView().withAppEnvironment()
}


//@ViewBuilder
//@MainActor
//func f() -> some View {
//    // Key for debugging previews!! Put all preview code in here
//}
