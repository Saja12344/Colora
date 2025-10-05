//
//  Root.swift
//  Colora
//
//  Created by saja khalid on 12/04/1447 AH.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showOnboarding = false
    @State private var showLogo = true

    var body: some View {
        ZStack {
            if showLogo {
                Logoscreen(showOnboarding: $showOnboarding)
                    .onChange(of: showOnboarding) { newValue in
                        if newValue { showLogo = false }
                    }
            } else if showOnboarding && !hasSeenOnboarding {
                Onboarding(showOnboarding: $showOnboarding)
            } else {
                HomePage()
            }
        }
    }
}
