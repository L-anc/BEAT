/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct CardView: View {
    let summary: PacketSummary
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Label("\(summary.endDate.formatted(.dateTime.month().day().year()))", systemImage: "calendar")
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Label("\(summary.endDate.formatted(.dateTime.hour().minute()))", systemImage: "clock")
                    .accessibilityAddTraits(.isHeader)
            }
            Spacer()
            HStack {
                if let avg = summary.avgBPM {
                    Text("\(Int(avg)) bpm")
                } else {
                    Text("N/A")
                }
                Spacer()
                Label("\(summary.status.rawValue)", systemImage: summary.status.systemImage)
                    .accessibilityLabel("\(summary.status.rawValue)")
            }
            .font(.callout)
        }
        .padding()
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 120)) {
    return CardView(summary: DataPacket.sampleSummaries[0])
}
