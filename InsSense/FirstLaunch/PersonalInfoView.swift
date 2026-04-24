//
//  PersonalInfo.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI
import SwiftData

struct PersonalInfoView: View {
    
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @AppStorage("unitSystem") var unitSystem: UnitSystem = .metric
    
    // Pull demographics data from user defaults
    @State private var demographics = Demographics.current
    
    // Input field vars
    @State private var ageText = ""
    @State private var heightText = ""
    @State private var weightText = ""
    
    // Manage focus
    enum Field { case age, height, weight }
    @FocusState private var focusedField: Field?

    var body: some View {
        
        NavigationStack{
            
            Form {
                Text("Necessary Info")
                    .font(.largeTitle)
                    .bold()
                
                Picker("Unit System", selection: $unitSystem) {
                    ForEach(UnitSystem.allCases, id: \.self) { system in
                        Text(system.rawValue).tag(system)
                    }
                }
                                
                HStack {
                    Text("Age")
                    Spacer()
                    TextField("25", text: $ageText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .age)
                        .onChange(of: ageText) {
                            ageText = ageText.filter { $0.isNumber }
                            if let val = Int(ageText) { demographics.age = val }
                        }
                }
                
                Picker("Sex", selection: $demographics.sex) {
                    ForEach(BiologicalSex.allCases) { sex in
                        Text(sex.rawValue.capitalized)
                            .tag(sex)
                    }
                }
                
                HStack {
                    Text("Height (cm)")
                    Spacer()
                     TextField("170", text: $heightText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .height)
                        .onChange(of: heightText) {
                            heightText = heightText.filter { $0.isNumber }
                            if let val = Double(heightText) { demographics.heightCm = val }
                        }
                }
                
                HStack {
                    Text("Weight (kg)")
                    Spacer()
                    TextField("70", text: $weightText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .weight)
                        .onChange(of: weightText) {
                            weightText = weightText.filter { $0.isNumber }
                            if let val = Double(weightText) { demographics.weightKg = val }
                        }
                }
                
            }
            .scrollDismissesKeyboard(.interactively)
            .safeAreaInset(edge: .bottom) {
                if focusedField != nil {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .padding(.trailing, 16)
                        .padding(.bottom, 4)
                    }
                    .background(.clear)
                }
            }
            .onAppear {
                ageText = demographics.age == 0 ? "" : "\(Int(demographics.age))"
                heightText = demographics.heightCm == 0 ? "" : "\(Int(demographics.heightCm))"
                weightText = demographics.weightKg == 0 ? "" : "\(Int(demographics.weightKg))"
            }
            
            if focusedField == nil {
                Button("Accept") {
                    focusedField = nil
                    Demographics.current = demographics
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
