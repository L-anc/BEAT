import SwiftUI
import Charts
 
 
/// Maps the raw HealthKit stage strings from SleepDataPoint to display metadata.
enum SleepStage: String, CaseIterable {
    case awake   = "awake"
    case core    = "core"    // HK "Light" sleep
    case rem     = "rem"
    case deep    = "deep"
    case unknown = "unknown"
 
    /// Human-readable label shown in the legend.
    var displayName: String {
        switch self {
        case .awake:   return "Awake"
        case .core:    return "Core (Light)"
        case .rem:     return "REM"
        case .deep:    return "Deep"
        case .unknown: return "Unknown"
        }
    }
 
    /// Chart / legend color for this stage.
    var color: Color {
        switch self {
        case .awake:   return Color(red: 1.0,  green: 0.78, blue: 0.24)  // amber
        case .core:    return Color(red: 0.58, green: 0.51, blue: 0.95)  // lavender
        case .rem:     return Color(red: 0.40, green: 0.76, blue: 0.95)  // sky blue
        case .deep:    return Color(red: 0.22, green: 0.33, blue: 0.87)  // deep blue
        case .unknown: return Color(red: 0.60, green: 0.60, blue: 0.60)  // grey
        }
    }
 
    /// Build from the raw string stored in SleepDataPoint.stage.
    /// Falls back to .unknown for anything unrecognised.
    init(rawStage: String) {
        self = SleepStage(rawValue: rawStage.lowercased()) ?? .unknown
    }
}
 
// MARK: - Summary Model
 
struct SleepStageSummary: Identifiable {
    let id = UUID()
    let stage: SleepStage
    let totalMinutes: Double
    var percentage: Double
}
 
// MARK: - Aggregation
 
extension Array where Element == SleepDataPoint {
    /// Collapse all data points into per-stage totals, preserving display order.
    func sleepSummaries(includeUnknown: Bool = false) -> [SleepStageSummary] {
        var totals: [SleepStage: Double] = [:]
 
        for point in self {
            let stage = SleepStage(rawStage: point.stage)
            guard includeUnknown || stage != .unknown else { continue }
            totals[stage, default: 0] += point.duration / 60 // → minutes
        }
 
        let grandTotal = totals.values.reduce(0, +)
        guard grandTotal > 0 else { return [] }
 
        // Return in canonical display order (awake → core → rem → deep)
        return SleepStage.allCases.compactMap { stage in
            guard let minutes = totals[stage], minutes > 0 else { return nil }
            return SleepStageSummary(
                stage: stage,
                totalMinutes: minutes,
                percentage: (minutes / grandTotal) * 100
            )
        }
    }
 
    /// Total sleep duration as a formatted string, e.g. "7h 23m".
    var formattedTotalDuration: String {
        let totalSeconds = self.reduce(0) { $0 + $1.duration }
        let h = Int(totalSeconds) / 3600
        let m = (Int(totalSeconds) % 3600) / 60
        return "\(h)h \(m)m"
    }
}
 
// MARK: - View
 
struct SleepPieChartView: View {
    /// Pass your array of SleepDataPoint objects directly.
    let dataPoints: [SleepDataPoint]
 
    private var summaries: [SleepStageSummary] {
        dataPoints.sleepSummaries()
    }
 
    var body: some View {
        VStack(spacing: 24) {
            Text("Sleep Analysis")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
 
            // Donut chart
            Chart(summaries) { summary in
                SectorMark(
                    angle: .value("Duration", summary.totalMinutes),
                    innerRadius: .ratio(0.55),
                    angularInset: 2
                )
                .foregroundStyle(summary.stage.color)
                .cornerRadius(4)
                .annotation(position: .overlay) {
                    if summary.percentage >= 8 {
                        Text("\(Int(summary.percentage))%")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(height: 280)
            .overlay {
                VStack(spacing: 2) {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(dataPoints.formattedTotalDuration)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }
 
            // Legend
            VStack(spacing: 10) {
                ForEach(summaries) { summary in
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(summary.stage.color)
                            .frame(width: 14, height: 14)
 
                        Text(summary.stage.displayName)
                            .font(.system(size: 15, weight: .medium))
 
                        Spacer()
 
                        Text(String(format: "%.0f min", summary.totalMinutes))
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
 
                        Text(String(format: "(%.0f%%)", summary.percentage))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(summary.stage.color)
                            .frame(width: 50, alignment: .trailing)
                    }
                    .padding(.horizontal, 4)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
            )
        }
        .padding()
    }
}
 
// MARK: - Preview
// SleepDataPoint can't be constructed without HKCategorySample in previews,
// so we add a small debug-only convenience init.
 
#if DEBUG
extension SleepDataPoint {
    /// Preview-only init — no HKCategorySample needed.
    init(stage: String, durationMinutes: Double) {
        self.timestamp = Date()
        self.stage = stage
        self.duration = durationMinutes * 60
    }
}
 
#Preview {
    SleepPieChartView(dataPoints: [
        SleepDataPoint(stage: "awake",   durationMinutes: 10),
        SleepDataPoint(stage: "core",    durationMinutes: 90),
        SleepDataPoint(stage: "rem",     durationMinutes: 75),
        SleepDataPoint(stage: "deep",    durationMinutes: 60),
        SleepDataPoint(stage: "core",    durationMinutes: 45),
        SleepDataPoint(stage: "rem",     durationMinutes: 40),
        SleepDataPoint(stage: "awake",   durationMinutes: 5),
        SleepDataPoint(stage: "deep",    durationMinutes: 35),
        SleepDataPoint(stage: "unknown", durationMinutes: 3),
    ])
}
#endif
