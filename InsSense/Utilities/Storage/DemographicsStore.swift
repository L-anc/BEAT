//
//  DemographicsStore.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI
import Combine

class DemographicsStore: ObservableObject {

    @AppStorage("age") var age: Int = 0
    @AppStorage("sex") var sexRaw: String = BiologicalSex.preferNotToSay.rawValue
    @AppStorage("heightCm") var heightCm: Double = 0
    @AppStorage("weightKg") var weightKg: Double = 0

    var sex: BiologicalSex {
        get { BiologicalSex(rawValue: sexRaw) ?? .preferNotToSay }
        set { sexRaw = newValue.rawValue }
    }
}
