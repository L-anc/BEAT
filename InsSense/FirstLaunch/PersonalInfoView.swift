//
//  PersonalInfo.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI

struct PersonalInfoView: View {
    
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @StateObject private var store = DemographicsStore()

    var body: some View {
        
        NavigationStack{
            
            Form {
                Text("Necessary Info")
                    .font(.largeTitle)
                    .bold()
                                
                HStack {
                    Text("Age")
                    Spacer()
                    
                    TextField(
                        "25",
                        value: $store.age,
                        format: .number.precision(.fractionLength(0))
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
                
                Picker("Sex", selection: Binding(
                    get: { store.sex },
                    set: { store.sex = $0 }
                )) {
                    
                    ForEach(BiologicalSex.allCases) { sex in
                        Text(sex.rawValue.capitalized)
                            .tag(sex)
                    }
                }
                
                HStack {
                    Text("Height (cm)")
                    Spacer()
                    
                    TextField(
                        "170",
                        value: $store.heightCm,
                        format: .number.precision(.fractionLength(0))
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Weight (kg)")
                    Spacer()
                    
                    TextField(
                        "70",
                        value: $store.weightKg,
                        format: .number.precision(.fractionLength(0))
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                }
                
            }
            
            Button("Accept") {
                firstLaunch = false
            }
            .font(.title2)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal)
            
        }
        .padding()
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    PersonalInfoView()
}
