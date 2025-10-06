//
//  Canva.swift
//  Colora
//
//  Created by Raghad Alzemami on 14/04/1447 AH.
//


import SwiftUI
import PencilKit
import Photos

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // No update logic needed
    }
}
struct Canva: View {
    @Environment(\.dismiss) private var dismiss  // 👈 for back navigation
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var isToolPickerVisible = false
    @State private var isPromptVisible = true

    @State private var savedImage: UIImage? = nil
    @State private var showImageView = false
    @State private var drawingStartTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var savedDate: Date?
    @State private var savedArtwork: ArtworkModel? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                // Canvas area
                VStack {
                    ZStack(alignment: .top) {
                        CanvasView(canvasView: $canvasView)
                            .onAppear {
                                drawingStartTime = Date()
                                showFloatingToolPicker()
                            }
                            .background(Color.white)
                            .cornerRadius(8)

                        if !isToolPickerVisible && isPromptVisible {
                            CarouselCardView()
                        }
                    }
                }
            }
            .toolbar {
                // 👇 Back button on the leading side
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss() // ✅ goes back to HomePage
                    } label: {
                        Label("Back", systemImage: "chevron.backward")
                            .labelStyle(.titleAndIcon)
                    }
                }

                // 👇 Tool picker toggle
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: toggleToolPicker) {
                        Image(systemName: isToolPickerVisible
                              ? "pencil.tip.crop.circle.fill"
                              : "pencil.tip.crop.circle")
                    }
                }

                // 👇 “Done” save button
                if isToolPickerVisible {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            saveDrawing()
                        }
                        .bold()
                    }
                }

                // 👇 Clear canvas (optional)
                if isToolPickerVisible {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            clearCanvas()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Helper functions

    func clearCanvas() {
        canvasView.drawing = PKDrawing()
        canvasView.undoManager?.removeAllActions()
    }

    func toggleToolPicker() {
        isToolPickerVisible.toggle()
        if isToolPickerVisible {
            showFloatingToolPicker()
        } else {
            toolPicker.setVisible(false, forFirstResponder: canvasView)
        }
    }

    func showFloatingToolPicker() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        }
    }

    func saveDrawing() {
        let image = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd"
        let fileName = "drawing_\(formatter.string(from: Date())).png"

        if let data = image.pngData() {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            try? data.write(to: url)
            print("✅ Saved image to: \(url.path)")
        }

        if let startTime = drawingStartTime {
            let timeSpent = Date().timeIntervalSince(startTime)
            let newArtwork = ArtworkModel(dateCreated: Date(), timeSpent: timeSpent, image: image)
            savedArtwork = newArtwork

            DispatchQueue.main.async {
                showImageView = true
            }
        }
    }

}



#Preview {
    NavigationView {
        Canva()
    }
}


