///*
// See LICENSE folder for this sample’s licensing information.
// */

import SwiftUI

struct DetailView: View {
    let packet: DataPacket

    var body: some View {
        List {
            Section(header: Text("Packet Info")) {
                HStack {
                    Label("Sample Date:", systemImage: "calendar")
                    Spacer()
                    Text("\(packet.date.formatted(.dateTime.month().day().year()))")
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Label("Sample Time:", systemImage: "clock")
                    Spacer()
                    Text("\(packet.date.formatted(.dateTime.hour().minute()))")
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Label("Average Heart Rate:", systemImage: "heart")
                    Spacer()
                    Text("\(packet.avgBPM) bpm")
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Label("Average Movement:", systemImage: "applewatch.radiowaves.left.and.right")
                    Spacer()
                    Text(String(format: "%.2f", packet.avgMotion) + " m/s")
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
    }
}

#Preview {
    NavigationStack {
        DetailView(packet: DataPacket.sampleData[0])
    }
}
