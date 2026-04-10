//
//  HomeView.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(PacketStore.self) private var store
    @State private var packets: [DecodedPacket] = []
    @State private var demographics = Demographics.current

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    TimeSeriesChart(
                        data: packets.compactMap { $0.heartRateSamples }.flatMap { $0 },
                        title: "Heart Rate",
                        yAxisLabel: "BPM"
                    )

                    VStack(alignment: .leading) {
                        Text("Recent Packets")
                            .font(.headline)

                        ForEach(packets, id: \.id) { packet in
                            HStack {
                                Text(packet.startDate, style: .time)
                                Spacer()
                                Text("\(packet.heartRateSamples?.count ?? 0) HR samples")
                            }
                            .padding(.vertical, 4)
                            Divider()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .task {
                packets = (try? store.fetchPackets()) ?? []
            }
        }
    }
}

#Preview {
    HomeView().withAppEnvironment()
}
