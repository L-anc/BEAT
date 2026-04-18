///*
// See LICENSE folder for this sample’s licensing information.
// */

import SwiftUI
import SwiftData

struct DetailView: View {
    let packetID: UUID
    @Environment(PacketStore.self) private var store
    @State private var packet: DecodedPacket?

    var body: some View {
        Group {
            if let packet {
                Spacer()
                List {
                    Section(header: Text("Packet Info")) {
                        HStack {
                            Label("Sample Date:", systemImage: "calendar")
                            Spacer()
                            Text("\(packet.endDate.formatted(.dateTime.month().day().year()))")
                        }
                        .accessibilityElement(children: .combine)
                        
                        HStack {
                            Label("Sample Time:", systemImage: "clock")
                            Spacer()
                            Text("\(packet.startDate.formatted(.dateTime.hour().minute())) - \(packet.endDate.formatted(.dateTime.hour().minute()))")
                        }
                        .accessibilityElement(children: .combine)
                        
                        HStack {
                            Label("Average Heart Rate:", systemImage: "heart")
                            Spacer()
                            if let avg = packet.heartRateSamples?.mean {
                                Text("\(Int(avg)) bpm")
                            } else {
                                Text("N/A")
                            }
                        }
                        .accessibilityElement(children: .combine)
                        
                        HStack {
                            Label("Predicted Status:", systemImage: packet.status.systemImage)
                            Spacer()
                            Text("\(packet.status.rawValue)")
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
                .navigationTitle(packet.id.uuidString)
            } else {
                ProgressView()
            }
        }
        .task {
            packet = try? store.fetchPacket(id: packetID)
        }
    }
}

#Preview {
    NavigationStack{
        DetailView(packetID: DataPacket.sampleData[0].id).withAppEnvironment()
    }
}
