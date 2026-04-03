//
//  Home.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI
import SwiftData

struct PacketView: View {
    @Query(sort: \DataPacket.date, order: .reverse) private var packets: [DataPacket]
  
    var body: some View {
        NavigationStack {
            List(packets) { packet in
                NavigationLink(destination: DetailView(packet: packet)) {
                    CardView(packet: packet)
                }
                .listRowSeparator(.visible, edges: .bottom)
                .listRowSeparatorTint(.gray)
            }
            .navigationTitle("Data Packets")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DataPacket.self, configurations: config)
    
    for packet in DataPacket.sampleData {
        container.mainContext.insert(packet)
    }
    
    return PacketView()
        .modelContainer(container)
}
