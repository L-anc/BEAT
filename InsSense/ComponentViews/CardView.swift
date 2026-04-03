/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

struct CardView: View {
    let packet: DataPacket
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Label("\(packet.date.formatted(.dateTime.month().day().year()))", systemImage: "calendar")
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Label("\(packet.date.formatted(.dateTime.hour().minute()))", systemImage: "clock")
                    .accessibilityAddTraits(.isHeader)
            }
            Spacer()
            HStack {
                Label("\(packet.avgBPM)", systemImage: "heart")
                Spacer()
                Label("\(packet.status.rawValue)", systemImage: packet.status.systemImage)
                    .accessibilityLabel("\(packet.status.rawValue)")
            }
            .font(.callout)
        }
        .padding()
    }
}

#Preview(traits: .fixedLayout(width: 400, height: 120)) {
    return CardView(packet: DataPacket.sampleData[0])
}
