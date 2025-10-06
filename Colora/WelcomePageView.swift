//
//  WelcomePageView.swift
//  Colora
//
//  Created by Deemah Alhazmi on 05/10/2025.
//

import Foundation
import SwiftUI

struct WelcomePageView: View {
    @AppStorage("userName") private var userName: String = ""   // persistent storage
    @State private var tempName: String = ""                   // temp input before saving
    @State private var hasSubmitted: Bool = false              // controls navigation

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 147/255, green: 139/255, blue: 183/255),
                    Color(red: 40/255, green: 54/255, blue: 43/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Spacer().frame(height: 80)

                // Lotus
                Text("🪷")
                    .font(.system(size: 60))

                // Title
                Text("Hi There!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                // Description
                Text("Before we begin, tell us how you’d like us to call you. It can be your real name, a nickname, or even something fun and creative \nwhatever feels most you.")
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading) // ✅ align left
                    .lineSpacing(4)
                    .padding(.trailing, 40)

                Spacer().frame(height: 40)

                // ==== Input Field & Arrow Button ====
                HStack {
                    TextField("Write your name", text: $tempName)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .foregroundColor(.white)
                        .tint(.white)
                        .frame(height: 50)

                    Button(action: {
                        if !tempName.isEmpty {
                            userName = tempName   // ✅ save permanently
                            hasSubmitted = true   // ✅ trigger navigation
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color(red: 176/255, green: 166/255, blue: 223/255))
                            .clipShape(Circle())
                    }
                }
                .padding(.trailing, 20)

                Spacer()
            }
            .padding(.horizontal, 30)
        }
        // 👇 Runs when screen appears — skips if userName already exists
        .onAppear {
            if !userName.isEmpty {
                hasSubmitted = true
            }
        }
        // 👇 Once hasSubmitted = true → jumps to HomePage
        .fullScreenCover(isPresented: $hasSubmitted) {
            HomePage()
        }

    }
}

#Preview {
    WelcomePageView()
}

