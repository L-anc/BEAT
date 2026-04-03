//
//  PrivacyDisclaimerView.swift
//  ChatPrototype
//
//  Created by Controllab on 3/29/26.
//

import SwiftUI
import MarkdownUI

struct DisclaimerView: View {

    @State private var document: String?
    @State private var errorMessage: String?
    
    private func loadDocument() {
        do {

            document = try MarkdownLoader.load("Disclaimer")

        } catch {

            errorMessage = error.localizedDescription
            print(error)
            
        }
    }

    var body: some View {

        VStack {

            if let document {
                
                ScrollView {
                    Markdown(document)
                }
                .padding()
                Spacer()
                
                NavigationLink("Accept") {
                    PersonalInfoView()
                }
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)


            } else if let errorMessage {

                VStack(spacing: 20) {
                    
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                    
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                    
                }.padding()

            } else {
                
                // Both document and errorMessage are nil = still loading
                ProgressView("Loading...")
                
            }
        }
        .task {loadDocument()}
        .padding()
    }
}

#Preview {
    DisclaimerView()
}
