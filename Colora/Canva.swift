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
    @State private var savedArtwork: UIImage? = nil      // يحفظ الرسم بعد الضغط على Done
    @State private var showSavePage = false             // لتفعيل NavigationLink

    @State private var drawingStartTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var offsetY: CGFloat = 0



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
                            .offset(y: offsetY) // ✅ نربط الحركة هنا
                        
                        
                        if !isToolPickerVisible && isPromptVisible {
                            CarouselCardView()
                            
                            
                                .onAppear {
                                    // يبدأ من تحت ويطلع لفوق
                                    offsetY = UIScreen.main.bounds.height
                                    withAnimation(.spring()) {
                                        offsetY = 0
                                    }
                                }}
                        
                    }
                    
                }}
            .toolbar {
                // 👇 Back button on the leading side
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // حركة نزول قبل الإغلاق
                        withAnimation(.spring()) {
                            offsetY = UIScreen.main.bounds.height  // ينزل الشاشة لتحت
                        }
                        
                        // بعد ما تخلص الأنيميشن، يسوي dismiss
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss() // يرجع للهوم بيج بعد النزول
                        }
                        
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(AppTheme.bg.opacity(0.7))
                                .font(.system(size: 18, weight: .medium))
                            
                        }
                        .labelStyle(.titleAndIcon)
                        .padding(10)
                        .foregroundColor(AppTheme.Streak)
                        .cornerRadius(12)
                    }
                    
                    
                }
                
                
                
                // 👇 Tool picker toggle
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: toggleToolPicker) {
                        Image(systemName: isToolPickerVisible
                              ? "pencil.tip.crop.circle.fill"
                              : "pencil.tip.crop.circle")
                    }
                    .foregroundColor(AppTheme.bg.opacity(0.7))
                    
                }
                
               
                if isToolPickerVisible {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            let image = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
                            savedArtwork = image
                            showSavePage = true
                        }
                        .bold()
                        .foregroundColor(AppTheme.bg.opacity(0.7))
                    }
                }


        
                // 👇 Clear canvas (optional)
                if isToolPickerVisible {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            clearCanvas()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(AppTheme.bg.opacity(0.7))
                            
                        }
                    }
                }
            }
            // NavigationLink دائما موجودة في الـ View hierarchy
            NavigationLink(
                destination: Group {
                    if let artwork = savedArtwork {
                        saveArtowrk(artworkImage: artwork)
                            .navigationBarBackButtonHidden(true)
                    }
                },
                isActive: $showSavePage,
                label: { EmptyView() }
            )
            .hidden()

        
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
            showFloatingToolPicker() // ✅ يظهر فقط عند الضغط على القلم
        } else {
            toolPicker.setVisible(false, forFirstResponder: canvasView)
        }
    }

    func showFloatingToolPicker() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
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
          
            savedArtwork = image

            DispatchQueue.main.async {
                showSavePage = true
            }
        }
    }

}



#Preview {
    NavigationView {
        Canva()
    }
}


