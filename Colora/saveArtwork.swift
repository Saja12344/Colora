//
//  saveArtwork.swift
//  Colora
//
//  Created by Raghad Alzemami on 14/04/1447 AH.
//

import SwiftUI
import PhotosUI // Needed for saving to Photo Library



struct saveArtowrk: View {
    @FocusState private var isArtworkFocused: Bool
    @FocusState private var isSecArtworkFocused: Bool

    @State private var showDeletePopup = false
    @State private var showSavePopup = false
    @State private var mainSaveButton = false
    @State private var artworkName = ""
    @State private var artworkDescription = ""

    // ✅ Helper function: save a UIImage to the photo album
    func saveImageToAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    // ✅ Simple prototype save
    func SaveArtwork() {
        if let image = UIImage(named: "Artwork") {
            DispatchQueue.main.async {
                saveImageToAlbum(image)
            }
            print("✅ Artwork saved!")
        } else {
            print("⚠️ Could not find 'Artwork' image.")
        }
        print("Name: \(artworkName)")
        print("Description: \(artworkDescription)")
    }

    var body: some View {
        ZStack {
            AppBackgroundModifier()

            VStack {
                // MARK: - Top Buttons
                HStack {
                    // Delete button (top-left)
                    Button {
                        withAnimation {
                            showDeletePopup = true
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                            .padding(21)
                    }

                    Spacer()

                    // ✅ Top-right Save Button
                    Button(action: {
                        if let uiImage = UIImage(named: "Artwork") {
                            saveImageToAlbum(uiImage)
                            withAnimation {
                                showSavePopup = true
                            }
                            // Auto-hide after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSavePopup = false
                                }
                            }
                        } else {
                            print("⚠️ Artwork image not found.")
                        }
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 24))
                            .foregroundStyle(.white.opacity(0.99))
                            .padding(21)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // MARK: - Artwork Preview
                Image("New Note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                    .padding()

                Spacer()

                // MARK: - Artwork Details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Name your Artwork")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.leading, 25)

                    // ✅ Working text field
                    TextField("Enter Name", text: $artworkName)
                        .frame(height: 56)
                        .padding(.horizontal, 20)
                        .focused($isArtworkFocused)
                        .font(.system(size: 24))
                        .background(Color(red: 0.15, green: 0.18, blue: 0.2))
                        .foregroundStyle(.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isArtworkFocused
                                    ? Color(red: 176/255, green: 166/255, blue: 223/255)
                                    : Color.gray.opacity(0.3),
                                    lineWidth: 1
                                )
                                .padding(.horizontal, 2)
                        )
                        .padding(.horizontal, 20)

                    Text("How did drawing make you feel?")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.leading, 25)

                    // ✅ Working text editor
                    TextEditor(text: $artworkDescription)
                        .frame(height: 127)
                        .padding(.horizontal, 20)
                        .background(Color(red: 0.15, green: 0.18, blue: 0.2))
                        .focused($isSecArtworkFocused)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isSecArtworkFocused
                                    ? Color(red: 176/255, green: 166/255, blue: 223/255)
                                    : Color.gray.opacity(0.3),
                                    lineWidth: 1
                                )
                                .padding(.horizontal, 2)
                        )
                        .padding(.horizontal, 20)

                    // MARK: - Bottom Save Button
                    Button {
                        SaveArtwork()
                        withAnimation { mainSaveButton = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation { mainSaveButton = false }
                        }
                        isArtworkFocused = false
                        isSecArtworkFocused = false
                    } label: {
                        Text("Save")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.74, green: 0.65, blue: 1.0))
                            .cornerRadius(40)
                    }
                    .padding(20)

                    Spacer()
                }
            }

            // MARK: - Delete Popup
            if showDeletePopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { showDeletePopup = false } }

                    GlassAlertView {
                        VStack(spacing: 16) {
                            Text("Delete this artwork?")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("Once deleted, it’s gone forever.")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)

                            HStack(spacing: 16) {
                                Button("Cancel") {
                                    withAnimation { showDeletePopup = false }
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Capsule())

                                Button("Delete") {
                                    print("Deleted!")
                                    withAnimation { showDeletePopup = false }
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

            // MARK: - Save Popup (top-right)
            if showSavePopup {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    GlassAlertView {
                        VStack(spacing: 16) {
                            Text("Artwork Saved!")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("Your drawing is now in your photo album")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)

                            Text("Keep creating, keep shining ✨")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 18)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Capsule())
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                    }
                }
            }

            // MARK: - Main Save (checkmark only)
            if mainSaveButton {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    GlassAlertView {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 80)
                            .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    saveArtowrk()
}
