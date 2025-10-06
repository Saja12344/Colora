//
//  PromptView.swift
//  Colora
//
//  Created by Raghad Alzemami on 14/04/1447 AH.
//


import SwiftUI



struct CarouselCardView: View {
    private let prompts = [
        "Draw a Safe Place",
        "Draw Your Feelings Like a Place",
        "Draw a Path or Road",
        "Draw Your Feelings as People or Animals",
        "Draw Helpers and Friends",
        "Draw Where You Arrive",
        "Doodles"
    ]

    @State private var currentIndex = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 8) {
                TabView(selection: $currentIndex) {
                    ForEach(prompts.indices, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color("F0F1FA"))
                                .frame(
                                    width: geometry.size.width * 0.85, // 85% of screen width
                                    height: 80
                                )

                            Text(prompts[index])
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .frame(width: geometry.size.width, height: 100)
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 100)

                // Progress bar (dots)
                HStack(spacing: 6) {
                    ForEach(prompts.indices, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color("28362B") : Color.gray.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .frame(width: geometry.size.width) // Ensures whole component fits screen width
        }
        .frame(height: 140) // Enough height to include card + dots
    }
}
