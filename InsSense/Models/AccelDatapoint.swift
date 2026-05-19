//
//  AccelDatapoint.swift
//  InsSense
//
//  Created by Controllab on 5/13/26.
//

struct AccelDataPoint: Codable {
    let timestamp: Date
    let x: Double
    let y: Double
    let z: Double

    var magnitude: Double { sqrt(x*x + y*y + z*z) }
}
