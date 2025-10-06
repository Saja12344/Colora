//
//  Artwork.swift
//  Colora
//
//  Created by Deemah Alhazmi on 05/10/2025.
//
import Foundation
import SwiftUI

// The 'Identifiable' protocol makes it easy to use this struct in a ForEach loop.
struct Artwork: Identifiable {
    let id = UUID()
    let imageName: String // Name of the image asset in your project
    let title: String
    let description: String
    let date: String
    let timeSpent: String
}

// A simple example array of artworks to use for the preview.
let sampleArtworks: [Artwork] = [
    Artwork(
        imageName: "drawing_2025_10_20",
        title: "Blooming Cloud",
        description: "A mix of calm and heaviness, but softened by a touch of hope — like a quiet sky where new life is gently appearing.",
        date: "20 OCT",
        timeSpent: "2H"
    ),
    Artwork(
        imageName: "drawing_2025_10_12",
        title: "Sunset Ocean",
        description: "A serene painting of a sunset over the ocean, with vibrant colors reflecting on the water.",
        date: "12 OCT",
        timeSpent: "1.5H"
    ),
    Artwork(
        imageName: "drawing_2025_11_21",
        title: "Forest Path",
        description: "A peaceful path winding through a sun-dappled forest, inviting you to take a walk.",
        date: "21 NOV",
        timeSpent: "3H"
    ),
    // 🌸 Added artworks below — no code removed or changed above
    Artwork(
        imageName: "drawing_2025_10_03",
        title: "Lavender Calm",
        description: "Soft pastel tones reflecting inner peace and clarity. A meditative blend of light and stillness.",
        date: "03 OCT",
        timeSpent: "2.5H"
    ),
    Artwork(
        imageName: "drawing_2025_10_05",
        title: "Golden Flow",
        description: "Golden lines flowing like music — warmth, freedom, and energy captured in motion.",
        date: "05 OCT",
        timeSpent: "1.5H"
    ),
    Artwork(
        imageName: "drawing_2025_10_14",
        title: "Deep Green",
        description: "A mix of forest hues symbolizing growth, grounding, and quiet strength.",
        date: "14 OCT",
        timeSpent: "3H"
    ),
    Artwork(
        imageName: "drawing_2025_10_15",
        title: "Waves of Thought",
        description: "A stormy yet introspective ocean — a dance between chaos and clarity.",
        date: "15 OCT",
        timeSpent: "2H"
    ),
    Artwork(
        imageName: "drawing_2025_10_30",
        title: "Aurora Dream",
        description: "Inspired by the Northern Lights — color meets movement, light meets wonder.",
        date: "30 OCT",
        timeSpent: "2.5H"
    )
]
