//
//  Root.swift
//  Colora
//
//  Created by saja khalid on 12/04/1447 AH.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("hasEnteredName") private var hasEnteredName = false
    @State private var showOnboarding = false
    @State private var showLogo = true

    var body: some View {
        ZStack {
            // 1️⃣ App Launch → Logo
            if showLogo {
                Logoscreen(showOnboarding: $showOnboarding)
                    .onChange(of: showOnboarding) { oldValue, newValue in
                        if newValue {
                            withAnimation {
                                showLogo = false
                            }
                        }
                    }

            // 2️⃣ After Logo → Onboarding
            } else if !hasSeenOnboarding {
                Onboarding(showOnboarding: $showOnboarding)
                    .onDisappear {
                        hasSeenOnboarding = true
                    }

            // 3️⃣ After Onboarding → Welcome page (enter name)
            } else if !hasEnteredName {
                WelcomePageView()
                    .onDisappear {
                        hasEnteredName = true
                    }

            // 4️⃣ Finally → Home
            } else {
                HomePage()
            }
        }
        .onAppear {
            // ✅ TEMPORARY RESET for testing (always start as new user)
            UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
            UserDefaults.standard.removeObject(forKey: "hasEnteredName")
            UserDefaults.standard.removeObject(forKey: "userName")
        }
    }
}


#Preview {
    RootView()
}
