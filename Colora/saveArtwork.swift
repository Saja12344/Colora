//
//import SwiftUI
//import PhotosUI
//
//struct saveArtowrk: View {
//    var artworkImage: UIImage
//    
//    @FocusState private var isArtworkFocused: Bool
//    @FocusState private var isSecArtworkFocused: Bool
//
//    @State private var showDeletePopup = false
//    @State private var showSavePopup = false
//    @State private var mainSaveButton = false
//    @State private var artworkName = ""
//    @State private var artworkDescription = ""
//    @Environment(\.dismiss) private var dismiss
//    @State private var goToCalendar = false
//    @Binding var showCalendar: Bool
//    
//    
//    func saveImageToAlbum(_ image: UIImage) {
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//    }
//    func saveArtworkToCalendar() {
//        // 1️⃣ احفظ الصورة في ألبوم الصور
//        saveImageToAlbum(artworkImage)
//        
//        // 2️⃣ جهز اسم للصورة حسب التاريخ
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy_MM_dd"
//        let fileName = "drawing_\(formatter.string(from: Date()))"
//        
//        // 3️⃣ حفظ الصورة في مجلد المستندات
//        if let data = artworkImage.pngData() {
//            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                .appendingPathComponent("\(fileName).png")
//            do {
//                try data.write(to: url)
//                print("✅ Saved image as \(url.path)")
//            } catch {
//                print("⚠️ Failed to save image: \(error)")
//            }
//        }
//        
//        // 4️⃣ إضافة الصورة إلى CalendarModel
//        CalendarModel.shared.addArtwork(name: fileName, image: artworkImage)
//        
//        // 5️⃣ عرض Checkmark Animation
//        withAnimation { mainSaveButton = true }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            withAnimation { mainSaveButton = false }
//        }
//        
//        // 6️⃣ اغلق التركيز على الحقول النصية
//        isArtworkFocused = false
//        isSecArtworkFocused = false
//    }
//    
//    
//    func SaveArtwork() {
//        DispatchQueue.main.async {
//            saveImageToAlbum(artworkImage)
//        }
//        print("✅ Artwork saved!")
//        print("Name: \(artworkName)")
//        print("Description: \(artworkDescription)")
//    }
//    
//    var body: some View {
//        ZStack {
//            // Background
//            Color(red: 40/255, green: 54/255, blue: 43/255)
//                .ignoresSafeArea()
//            
//            LinearGradient(
//                gradient: Gradient(colors: [
//                    Color(red: 176/255, green: 166/255, blue: 223/255).opacity(0.4),
//                    .clear
//                ]),
//                startPoint: UnitPoint(x: -0.2, y: 0.2),
//                endPoint: UnitPoint(x: 0.8, y: 0.8)
//            )
//            .ignoresSafeArea()
//            
//            LinearGradient(
//                gradient: Gradient(colors: [
//                    Color(red: 176/255, green: 166/255, blue: 223/255).opacity(0.4),
//                    .clear
//                ]),
//                startPoint: UnitPoint(x: 0.2, y: 0.2),
//                endPoint: UnitPoint(x: 1.2, y: 0.8)
//            )
//            .blur(radius: 20)
//            .ignoresSafeArea()
//            
//            VStack(spacing: 20) {
//                // Top Buttons
//                HStack {
//                    Button {
//                        withAnimation { showDeletePopup = true }
//                    } label: {
//                        Image(systemName: "xmark")
//                            .foregroundStyle(.white)
//                            .font(.system(size: 24))
//                            .padding(21)
//                    }
//                    
//                    Spacer()
//                    
//                    Button {
//                        saveImageToAlbum(artworkImage)
//                        withAnimation { showSavePopup = true }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            withAnimation { showSavePopup = false }
//                        }
//                    } label: {
//                        Image(systemName: "square.and.arrow.down")
//                            .font(.system(size: 24))
//                            .foregroundStyle(.white.opacity(0.99))
//                            .padding(21)
//                            .padding(.top,10)
//                    }
//                    
//                }
//                .padding(.horizontal)
//                .padding(.top, 75)
//                
//                // Artwork with white frame
//                ZStack {
//                    RoundedRectangle(cornerRadius: 35)
//                        .fill(Color.white)
//                        .frame(width: 360, height: 320)
//                        .shadow(radius: 5)
//                    
//                    Image(uiImage: artworkImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 350, height: 320)
//                        .clipShape(RoundedRectangle(cornerRadius: 35))
//                }
//                .padding(.top, 20)
//                
//                // Artwork Details
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Name your Artwork")
//                        .font(.system(size: 16, weight: .bold))
//                        .foregroundStyle(.white)
//                        .padding(.leading, 25)
//                    
//                    TextField("Enter Name", text: $artworkName)
//                        .frame(height: 56)
//                        .padding(.horizontal, 20)
//                        .focused($isArtworkFocused)
//                        .font(.system(size: 24))
//                        .background(Color(red: 0.15, green: 0.18, blue: 0.2))
//                        .foregroundStyle(.white)
//                        .cornerRadius(20)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(
//                                    isArtworkFocused
//                                    ? Color(red: 176/255, green: 166/255, blue: 223/255)
//                                    : Color.gray.opacity(0.3),
//                                    lineWidth: 1
//                                )
//                                .padding(.horizontal, 2)
//                        )
//                        .padding(.horizontal, 20)
//                    
//                    Text("How did drawing make you feel?")
//                        .font(.system(size: 16, weight: .bold))
//                        .foregroundStyle(.white)
//                        .padding(.leading, 25)
//                    
//                    TextEditor(text: $artworkDescription)
//                        .frame(height: 100)
//                        .padding(.horizontal, 20)
//                        .background(Color(red: 0.15, green: 0.18, blue: 0.2))
//                        .focused($isSecArtworkFocused)
//                        .font(.system(size: 20))
//                        .foregroundStyle(.white)
//                        .scrollContentBackground(.hidden)
//                        .cornerRadius(20)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(
//                                    isSecArtworkFocused
//                                    ? Color(red: 176/255, green: 166/255, blue: 223/255)
//                                    : Color.gray.opacity(0.3),
//                                    lineWidth: 1
//                                )
//                                .padding(.horizontal, 2)
//                        )
//                        .padding(.horizontal, 20)
//                    
//                    VStack(spacing: 20) {
//                        // ... كل عناصر الصفحة
//
//                        Button {
//                            let formatter = DateFormatter()
//                            formatter.dateFormat = "yyyy_MM_dd"
//                            let fileName = "drawing_\(formatter.string(from: Date())).png"
//                            
//                            CalendarModel.shared.addArtwork(name: fileName, image: artworkImage)
//                            
//                            withAnimation { mainSaveButton = true }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                                withAnimation { mainSaveButton = false }
//                            }
//                            
//                            isArtworkFocused = false
//                            isSecArtworkFocused = false
//                            
//                            // 🔹 فعل الـ NavigationLink
//                            goToCalendar = true
//                        } label: {
//                            Text("Save")
//                                .font(.system(size: 20, weight: .bold))
//                                .foregroundColor(.black)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color(red: 0.74, green: 0.65, blue: 1.0))
//                                .cornerRadius(40)
//                        }
//
//                        // 🔹 NavigationLink مباشرة بعد الزر
//                        NavigationLink("", destination: CalendarView(showCalendar: $showCalendar), isActive: $goToCalendar)
//                            .hidden()
//                    }
//
//                    
//                    .padding(20)
//                    
//                }
//                .padding(.bottom, 70)
//                
//                
//                
//            }                .padding(.bottom, 30)
//            
//            
//            // Delete Popup
//            if showDeletePopup {
//                ZStack {
//                    Color.black.opacity(0.4)
//                        .ignoresSafeArea()
//                        .onTapGesture { withAnimation { showDeletePopup = false } }
//                    
//                    GlassAlertView {
//                        VStack(spacing: 16) {
//                            Text("Delete this artwork?")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            
//                            Text("Once deleted, it’s gone forever.")
//                                .font(.footnote)
//                                .foregroundColor(.white.opacity(0.8))
//                                .multilineTextAlignment(.center)
//                            
//                            HStack(spacing: 16) {
//                                Button("Cancel") {
//                                    withAnimation { showDeletePopup = false }
//                                }
//                                .foregroundColor(.white)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 16)
//                                .background(Color.white.opacity(0.2))
//                                .clipShape(Capsule())
//                                
//                                Button("Delete") {
//                                    print("Deleted!")
//                                    withAnimation {
//                                        showDeletePopup = false
//                                        dismiss()
//                                    }
//                                }
//                                .foregroundColor(.red)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 16)
//                                .background(Color.white.opacity(0.2))
//                                .clipShape(Capsule())
//                            }
//                        }
//                    }
//                }
//            }
//            
//            // Save Popup
//            if showSavePopup {
//                ZStack {
//                    Color.black.opacity(0.4).ignoresSafeArea()
//                    GlassAlertView {
//                        VStack(spacing: 16) {
//                            Text("Artwork Saved!")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            
//                            Text("Your drawing is now in your photo album")
//                                .font(.footnote)
//                                .foregroundColor(.white.opacity(0.8))
//                                .multilineTextAlignment(.center)
//                            
//                            Text("Keep creating, keep shining ✨")
//                                .font(.subheadline)
//                                .foregroundColor(.white)
//                                .padding(.vertical, 10)
//                                .padding(.horizontal, 18)
//                                .background(Color.black.opacity(0.6))
//                                .clipShape(Capsule())
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.8)
//                        }
//                    }
//                }
//            }
//            
//            // Main Save Checkmark
//            if mainSaveButton {
//                ZStack {
//                    Color.black.opacity(0.4).ignoresSafeArea()
//                    GlassAlertView {
//                        Image(systemName: "checkmark.circle.fill")
//                            .resizable()
//                            .foregroundStyle(.white)
//                            .frame(width: 80, height: 80)
//                            .padding()
//                    }
//                }
//            }
//        }
//    }
//}
//
//    
//    
//    struct saveArtowrk_Previews: PreviewProvider {
//        @State static var showCalendar = false
//        
//        static var previews: some View {
//            saveArtowrk(artworkImage: UIImage(named: "New Note")!, showCalendar: $showCalendar)
//        }
//    }
//
import SwiftUI
import PhotosUI

struct saveArtowrk: View {
    var artworkImage: UIImage
    @Binding var showCalendar: Bool

    @FocusState private var isArtworkFocused: Bool
    @FocusState private var isSecArtworkFocused: Bool
    @State private var showDeletePopup = false
    @State private var showSavePopup = false
    @State private var mainSaveButton = false
    @State private var artworkName = ""
    @State private var artworkDescription = ""
    @State private var goToCalendar = false
    @Environment(\.dismiss) private var dismiss
    

    func saveImageToAlbum(_ image: UIImage?) {
        guard let image = image else {
            print("❌ ما فيه صورة للحفظ")
            return
        }

        // 🔹 طلب صلاحية الوصول أول مرة
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                print("✅ Artwork saved!")
            } else {
                print("⚠️ لا يوجد إذن لحفظ الصور")
            }
        }
    }


    func saveToCalendar() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd"
        let fileName = "drawing_\(formatter.string(from: Date())).png"

        if let data = artworkImage.pngData() {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
            try? data.write(to: url)
        }

        CalendarModel.shared.addArtwork(name: fileName, image: artworkImage)

        withAnimation { mainSaveButton = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { withAnimation { mainSaveButton = false } }

        isArtworkFocused = false
        isSecArtworkFocused = false
        goToCalendar = true
    }

    var body: some View {
        ZStack {
            Color(red: 40/255, green: 54/255, blue: 43/255).ignoresSafeArea()
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 176/255, green: 166/255, blue: 223/255).opacity(0.4),
                    .clear
                ]),
                startPoint: UnitPoint(x: -0.2, y: 0.2),
                endPoint: UnitPoint(x: 0.8, y: 0.8)
            )
            .ignoresSafeArea()
            .blur(radius: 20)

            VStack(spacing: 20) {
                HStack {
                    Button { withAnimation { showDeletePopup = true } } label: {
                        Image(systemName: "xmark").foregroundStyle(.white).font(.system(size: 24)).padding(21)
                    }
                    Spacer()
                    Button {
                        saveImageToAlbum(artworkImage)
                        withAnimation { showSavePopup = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { showSavePopup = false } }
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 24))
                            .foregroundStyle(.white.opacity(0.99))
                            .padding(21).padding(.top,10)
                    }
                }
                .padding(.horizontal).padding(.top, 75)

                ZStack {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color.white)
                        .frame(width: 360, height: 320)
                        .shadow(radius: 5)
                    Image(uiImage: artworkImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Name your Artwork")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.leading, 25)
                    TextField("Enter Name", text: $artworkName)
                        .frame(height: 56)
                        .padding(.horizontal, 20)
                        .focused($isArtworkFocused)
                        .font(.system(size: 24))
                        .background(Color(red: 0.15, green: 0.18, blue: 0.2))
                        .foregroundStyle(.white)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(isArtworkFocused ? Color.purple : Color.gray.opacity(0.3), lineWidth: 1).padding(.horizontal, 2))
                        .padding(.horizontal, 20)

                    Text("How did drawing make you feel?")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.leading, 25)
                    TextEditor(text: $artworkDescription)
                        .frame(height: 100)
                        .padding(.horizontal, 20)
                        .background(Color(red: 0.15, green: 0.18, blue: 0.2))
                        .focused($isSecArtworkFocused)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .scrollContentBackground(.hidden)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(isSecArtworkFocused ? Color.purple : Color.gray.opacity(0.3), lineWidth: 1).padding(.horizontal, 2))
                        .padding(.horizontal, 20)

                    Button {
                        saveToCalendar()
                    } label: {
                        Text("Save")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.74, green: 0.65, blue: 1.0))
                            .cornerRadius(40)
                    }
                    .padding(.horizontal)

                    .navigationDestination(isPresented: $goToCalendar) {
                        CalendarView(showCalendar: $showCalendar)
                            .navigationBarBackButtonHidden(true)
                    }


                }
                .padding(.bottom, 70)

            }

            // Delete Popup
            if showDeletePopup {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea().onTapGesture { withAnimation { showDeletePopup = false } }
                    GlassAlertView {
                        VStack(spacing: 16) {
                            Text("Delete this artwork?").font(.headline).foregroundColor(.white)
                            Text("Once deleted, it’s gone forever.").font(.footnote).foregroundColor(.white.opacity(0.8)).multilineTextAlignment(.center)
                            HStack(spacing: 16) {
                                Button("Cancel") { withAnimation { showDeletePopup = false } }
                                    .foregroundColor(.white).padding(.vertical, 8).padding(.horizontal, 16).background(Color.white.opacity(0.2)).clipShape(Capsule())
                                Button("Delete") { withAnimation { showDeletePopup = false; dismiss() } }
                                    .foregroundColor(.red).padding(.vertical, 8).padding(.horizontal, 16).background(Color.white.opacity(0.2)).clipShape(Capsule())
                            }
                        }
                    }
                }
            }

            // Save Popup
            if showSavePopup {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    GlassAlertView {
                        VStack(spacing: 16) {
                            Text("Artwork Saved!").font(.headline).foregroundColor(.white)
                            Text("Your drawing is now in your photo album").font(.footnote).foregroundColor(.white.opacity(0.8)).multilineTextAlignment(.center)
                            Text("Keep creating, keep shining ✨").font(.subheadline).foregroundColor(.white)
                                .padding(.vertical, 10).padding(.horizontal, 18)
                                .background(Color.black.opacity(0.6)).clipShape(Capsule()).lineLimit(1).minimumScaleFactor(0.8)
                        }
                    }
                }
            }

            // Main Save Checkmark
            if mainSaveButton {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    GlassAlertView {
                        Image(systemName: "checkmark.circle.fill").resizable().foregroundStyle(.white).frame(width: 80, height: 80).padding()
                    }
                }
            }
        }
    }
}
