//
//  HomeView.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI

struct HomeView: View {

//    @EnvironmentObject var demographics: DemographicsStore
    let demographics: Demographics
    let packets: [DataPacket]
//    @StateObject private var packetStore = PacketStore()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    TimeSeriesChart(

                        data: DataPacket.sampleData,

                        title: "Heart Rate",

                        xValue: { $0.date },

                        yValue: { Double($0.avgBPM) },

                        yAxisLabel: "BPM"
                    )
                    

                    VStack(alignment: .leading) {

                        Text("Recent Packets")
                            .font(.headline)

                        ForEach(packets) { packet in

                            NavigationLink {

                                DetailView(packet: packet)

                            } label: {

                                HStack {

                                    Text(packet.date, style: .time)

                                    Spacer()

                                    Text("\(Int(packet.avgBPM)) bpm")
                                }
                                .padding(.vertical, 4)
                            }

                            Divider()
                        }
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    HomeView(demographics: Demographics.sampleData,  packets: DataPacket.sampleData)
}
