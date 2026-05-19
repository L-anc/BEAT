import CoreMotion
import Foundation

class MotionManager {
    private let recorder = CMSensorRecorder()
    
    /// Fetches recorded accelerometer samples between two dates.
    /// CMSensorRecorder stores up to 3 days of data via the motion coprocessor.
    func fetchAccelSamples(from start: Date, to end: Date) -> [AccelDataPoint]? {
        guard CMSensorRecorder.isAccelerometerRecordingAvailable() else { return nil }
        
        let list = recorder.accelerometerData(from: start, to: end)
        
        return list?.compactMap { data in
            guard let accel = data as? CMRecordedAccelerometerData else { return nil }
            return AccelDataPoint(
                timestamp: Date(timeIntervalSinceReferenceDate: data.startDate.timeIntervalSinceReferenceDate),
                x: accel.acceleration.x,
                y: accel.acceleration.y,
                z: accel.acceleration.z
            )
        }
    }
}
