//
//  ArtworkGalleryView.swift
//  Colora
//
//  Created by Deemah Alhazmi on 25/09/2025.
//

import SwiftUI
import PhotosUI
import UIKit

// Helper function: save a UIImage to the photo album
func saveImageToAlbum(_ image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
}

struct ArtworkGalleryView: View {
    var artworks: [Artwork] = sampleArtworks
    var startIndex: Int = 0   // 👈 to open at specific artwork

    @Environment(\.dismiss) private var dismiss   // 👈 allows swipe-down dismiss
    @State private var isShowingSaveAlert = false
    @State private var isShowingDeleteAlert = false
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0   // 👈 for interactive swipe

    init(artworks: [Artwork] = sampleArtworks, startIndex: Int = 0) {
        self.artworks = artworks
        self.startIndex = startIndex
        _currentIndex = State(initialValue: startIndex)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 147/255, green: 139/255, blue: 183/255),
                    Color(red: 40/255, green: 54/255, blue: 43/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // ===== Artwork Gallery =====
            TabView(selection: $currentIndex) {
                ForEach(artworks.indices, id: \.self) { index in
                    VStack(spacing: 20) {
                        // Top bar
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundStyle(.white.opacity(0.99))
                            }

                            Spacer()

                            Button(action: {
                                if let uiImage = UIImage(named: artworks[index].imageName) {
                                    saveImageToAlbum(uiImage)
                                    withAnimation { isShowingSaveAlert = true }
                                }
                            }) {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.title2)
                                    .foregroundStyle(.white.opacity(0.99))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)

                        // Artwork card
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.white)
                                .shadow(radius: 10)

                            Image(artworks[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(10)
                        }
                        .frame(maxWidth: 340, maxHeight: 440)
                        .offset(y: dragOffset) // 👈 move with swipe
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.height > 0 {
                                        dragOffset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.height > 120 {
                                        dismiss() // 👈 dismiss on drag down
                                    } else {
                                        withAnimation(.spring()) { dragOffset = 0 }
                                    }
                                }
                        )

                        // Info card
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.40))
                            .shadow(radius: 10)
                            .frame(maxWidth: .infinity)
                            .frame(height: 220)
                            .overlay(
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(alignment: .firstTextBaseline, spacing: 18) {
                                        Label(artworks[index].date, systemImage: "calendar")
                                        Label(artworks[index].timeSpent, systemImage: "timer")
                                        Spacer(minLength: 8)
                                        Image(systemName: "pencil")
                                            .imageScale(.medium)
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.75))

                                    Text(artworks[index].title)
                                        .font(.title2.weight(.bold))
                                        .foregroundStyle(.white)

                                    Text(artworks[index].description)
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.75))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(16)
                                , alignment: .leading
                            )
                            .padding(.horizontal)

                        Spacer(minLength: 10)
                    }
                    .tag(index)
                    .padding(.bottom, 8)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .blur(radius: (isShowingSaveAlert || isShowingDeleteAlert) ? 10 : 0)

            // ===== Save Alert =====
            if isShowingSaveAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { isShowingSaveAlert = false } }

                GlassAlertView {
                    Text("Artwork saved!")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Your drawing is now in your photo album")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)

                    Button(action: {
                        withAnimation { isShowingSaveAlert = false }
                    }) {
                        Text("Keep creating, keep shining ✨")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 18)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Capsule())
                    }
                }
            }

            // ===== Delete Alert =====
            if isShowingDeleteAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { isShowingDeleteAlert = false } }

                GlassAlertView {
                    Text("Delete this artwork?")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Once deleted, it’s gone forever.")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)

                    HStack(spacing: 16) {
                        Button("Cancel") {
                            withAnimation { isShowingDeleteAlert = false }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())

                        Button("Delete") {
                            print("Artwork deleted")
                            withAnimation { isShowingDeleteAlert = false }
                        }
                        .foregroundColor(.red)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                    }
                }
            }
        }
    }
}

//import SwiftUI

// MARK: - Gallery View

