//
//  AppBackground.swift
//  Colora
//
//  Created by Norah Aldawsari on 10/04/1447 AH.
//


import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            // Base solid color
                        Color(red: 40/255, green: 54/255, blue: 43/255)
                            .edgesIgnoringSafeArea(.all)

                        // First LinearGradient for the top-left glow
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 176/255, green: 166/255, blue: 223/255).opacity(0.4),
                                Color.clear
                            ]),
                            startPoint: UnitPoint(x: -0.2, y: 0.2),
                            endPoint: UnitPoint(x: 0.8, y: 0.8)
                        )
                        .edgesIgnoringSafeArea(.all)

                        // Second LinearGradient for the bottom-right glow
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 176/255, green: 166/255, blue: 223/255).opacity(0.4),
                                Color.clear
                            ]),
                            startPoint: UnitPoint(x: 0.2, y: 0.2),
                            endPoint: UnitPoint(x: 1.2, y: 0.8)
                        )
                        .edgesIgnoringSafeArea(.all)
                   }
    }
}

#Preview {
    AppBackground()
}
