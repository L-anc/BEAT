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
                        
                        DetailRow(labelText: "Sample Date:", systemImage: "calendar", summaryData: packet.endDate.formatted(.dateTime.month().day().year()))
                        
                        DetailRow(labelText: "Sample Time:", systemImage: "clock", summaryData: "\(packet.startDate.formatted(.dateTime.hour().minute())) - \(packet.endDate.formatted(.dateTime.hour().minute()))")
                        
                        DetailRow(labelText: "Predicted Status:", systemImage: packet.status.systemImage, summaryData: packet.status.rawValue)
                        
                        DetailRow(labelText: "Heart Rate:", systemImage: "heart", summaryData: packet.heartRateSamples, operation: .Mean)
                        
                        DetailRow(labelText: "Heart Rate Variation:", systemImage: "heart", summaryData: packet.hrvSamples, operation: .Mean)
                        
                        DetailRow(labelText: "Active Energy:", systemImage: "flame", summaryData: packet.activeEnergySamples, operation: .Sum)
                        
                        // Double check all units below this line
                        DetailRow(labelText: "Exercise Time:", systemImage: "figure.run", summaryData: packet.exerciseTimeSamples, operation: .Sum)
                        
                        DetailRow(labelText: "Body Temperature", systemImage: "thermometer.medium", summaryData: packet.bodyTemperatureSamples, operation: .Mean)
                        
                        DetailRow(labelText: "Wrist Temperature", systemImage: "thermometer.medium", summaryData: packet.wristTemperatureSamples, operation: .Mean)
                        
                        DetailRow(labelText: "Respiratory Rate", systemImage: "lungs", summaryData: packet.respiratoryRateSamples, operation: .Mean)
                        
                        DetailRow(labelText: "Blood Glucose", systemImage: "fork.knife", summaryData: packet.bloodGlucoseSamples, operation: .Sum)
                        
                        DetailRow(labelText: "Insulin", systemImage: "syringe", summaryData: packet.insulinSamples, operation: .Sum)
                        
                        // MARK: - Sleep and Workout points
                        SleepDetailRow(summaryData: packet.sleepSamples)
                        
                        WorkoutDetailRow(summaryData: packet.workoutSamples)
                        
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
