//import SwiftUI
//import UIKit // لأننا نستخدم UIImage(named:)
//import AVFoundation
//
//struct CalendarMonth: Identifiable {
//    let id = UUID()
//    let month: Date
//    let days: [DayData]
//}
//
//struct DayData: Identifiable {
//    let id = UUID()
//    let date: Date
//    let imageName: String? // nil = مافي صورة
//}
//
//
//struct CalendarView: View {
//    @State private var months: [CalendarMonth] = []
//    @State private var showPopup = false
//    @State private var isSoundOn = true
//    @AppStorage("userName") private var teamName: String = "Team 19" // ✅ Load saved username
//    @State private var isEditing = false
//    @State private var showHome = false
//    
//    // 👇 لعرض اللوحة المختارة
//    @State private var showGallery = false
//    @State private var selectedImageName: String? = nil
//    @ObservedObject var calendar = CalendarModel.shared
//    @State private var showCalendar = false
//
//
//
//    var body: some View {
//
//                NavigationView {
//                    ZStack {
//                        ScrollView {
//                            LazyVStack(spacing: 0) {
//                                ForEach(months) { month in
//                                    MonthView(month: month)
//                                }
//                            }
//                            .padding(.vertical)
//                        }
//                        .blur(radius: showPopup ? 6 : 0)
//                        
//                        // 👇 Popup
//                        if showPopup {
//                            PopupView(showPopup: $showPopup,
//                                      teamName: $teamName,
//                                      isEditing: $isEditing,
//                                      isSoundOn: $isSoundOn)
//                        }
//                    }
//                    .onAppear {
//                        if months.isEmpty { loadTenMonths() }
//                        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//                        UINavigationBar.appearance().shadowImage = UIImage()
//                        
//                        NotificationCenter.default.addObserver(forName: .didSelectArtworkImage, object: nil, queue: .main) { notif in
//                            if let name = notif.object as? String {
//                                selectedImageName = name
//                                showGallery = true
//                            }
//                        }
//                    }
//                    .appBackground()
//             
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarLeading) {
//                        Button {
//                            withAnimation { showPopup = true }
//                        } label: {
//                            Image(systemName: "gearshape")
//                                .foregroundColor(.white)
//                        }
//                    }
//                    
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        NavigationLink(destination: HomePage()
//                            .navigationBarBackButtonHidden(true)) {
//                                Image(systemName: "chevron.forward")
//                                    .foregroundColor(.white)
//                            }
//                    }
//                }
//            
//            // 👇 عرض الصفحة الرئيسية
//            .fullScreenCover(isPresented: $showHome) {
//                HomePage()
//            }
//                    
//
//            // 👇 عرض المعرض (ArtworkGalleryView) مع تمرير startIndex الصحيح
//            .fullScreenCover(isPresented: $showGallery) {
//                if let selectedName = selectedImageName,
//                   let startIndex = sampleArtworks.firstIndex(where: { $0.imageName == selectedName }) {
//                    ArtworkGalleryView(artworks: sampleArtworks, startIndex: startIndex)
//                } else {
//                    ArtworkGalleryView(artworks: sampleArtworks)
//                }
//            }
//
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(.ultraThinMaterial.opacity(3), for: .navigationBar)
//            .toolbarColorScheme(.dark, for: .navigationBar)
//        }
//    }
//    
//    // MARK: - Helpers
//    func loadTenMonths() {
//        let today = Date()
//        let calendar = Calendar.current
//        months = (0..<5).compactMap { offset in
//            if let date = calendar.date(byAdding: .month, value: offset, to: today) {
//                return generateMonth(for: date)
//            }
//            return nil
//        }
//    }
//    
//    func generateMonth(for date: Date) -> CalendarMonth {
//        let calendar = Calendar.current
//        guard let range = calendar.range(of: .day, in: .month, for: date) else {
//            return CalendarMonth(month: date, days: [])
//        }
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy_MM_dd"
//        
//        let days = range.map { day -> DayData in
//            let dayDate = calendar.date(bySetting: .day, value: day, of: date)!
//            let imageName = "drawing_\(formatter.string(from: dayDate))"
//            if UIImage(named: imageName) != nil {
//                return DayData(date: dayDate, imageName: imageName)
//            } else {
//                return DayData(date: dayDate, imageName: nil)
//            }
//        }
//        
//        return CalendarMonth(month: date, days: days)
//    }
//}
//
//// MARK: - Month View
//struct MonthView: View {
//    let month: CalendarMonth
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Text(monthTitle(for: month.month))
//                .font(.headline)
//                .padding(.leading, -165)
//                .foregroundColor(.white)
//                .frame(maxWidth: 375, minHeight: 40)
//                .background(AppTheme.daysBackground)
//                .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
//                .padding(.top, 50)
//            
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
//                ForEach(month.days) { day in
//                    DayCell(day: day, days: month.days, onImageTap: { imageName in
//                        NotificationCenter.default.post(name: .didSelectArtworkImage, object: imageName)
//                    })
//                }
//            }
//            .frame(width: 360)
//            .padding(.vertical)
//            .padding(.all, 8)
//            .background(AppTheme.monthsBackground.opacity(0.4))
//            .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
//            .shadow(color: .black.opacity(0.25), radius: 7, x: 0, y: 4)
//        }
//    }
//    
//    private func monthTitle(for date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter.string(from: date)
//    }
//}
//
//// MARK: - Day Cell
//struct DayCell: View {
//    let day: DayData
//    let days: [DayData]
//    var onImageTap: (String) -> Void
//
//    var body: some View {
//        Button {
//            if let imageName = day.imageName {
//                onImageTap(imageName)
//            }
//        } label: {
//            ZStack(alignment: .bottomLeading) {
//                if let imageName = day.imageName {
//                    Image(imageName)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 60, height: 55)
//                        .clipped()
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(isStreak ? AppTheme.Streak : Color.clear, lineWidth: 4)
//                        )
//                } else {
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(AppTheme.daysBackground.opacity(0.7))
//                        .frame(width: 60, height: 55)
//                }
//                
//                Text("\(Calendar.current.component(.day, from: day.date))")
//                    .font(.caption)
//                    .bold()
//                    .foregroundColor(AppTheme.monthsBackground)
//                    .padding(4)
//            }
//        }
//        .buttonStyle(.plain)
//    }
//    
//    private var isStreak: Bool {
//        let calendar = Calendar.current
//        guard day.imageName != nil else { return false }
//        
//        let prevDate = calendar.date(byAdding: .day, value: -1, to: day.date)
//        let nextDate = calendar.date(byAdding: .day, value: 1, to: day.date)
//        
//        let hasPrev = prevDate.flatMap { prev in
//            days.first(where: { calendar.isDate($0.date, inSameDayAs: prev) })?.imageName != nil
//        } ?? false
//        
//        let hasNext = nextDate.flatMap { next in
//            days.first(where: { calendar.isDate($0.date, inSameDayAs: next) })?.imageName != nil
//        } ?? false
//        
//        return hasPrev || hasNext
//    }
//}
//
//// MARK: - Popup View
//struct PopupView: View {
//    @Binding var showPopup: Bool
//    @Binding var teamName: String
//    @Binding var isEditing: Bool
//    @Binding var isSoundOn: Bool
//    @StateObject private var audio = AudioManager.shared
//
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .ignoresSafeArea()
//                .onTapGesture {
//                    withAnimation { showPopup = false }
//                }
//            
//            VStack(spacing: 50) {
//                HStack {
//                    Button {
//                        withAnimation { showPopup = false }
//                    } label: {
//                        Image(systemName: "xmark")
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    Spacer()
//                }
//                
//                HStack {
//                    if isEditing {
//                        TextField("Your name", text: $teamName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .foregroundColor(.black)
//                        
//                        Button {
//                            isEditing = false
//                        } label: {
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.white)
//                        }
//                    } else {
//                        Text(teamName)
//                            .font(.largeTitle)
//                            .foregroundColor(.white)
//                        Button {
//                            isEditing = true
//                        } label: {
//                            Image(systemName: "pencil")
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//                
//                HStack(spacing: 160)  {
//                    Text("Sounds")
//                        .foregroundColor(.white)
//
//                    Toggle(isOn: $audio.isPlaying) {
//                        Image(systemName: audio.isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
//                            .foregroundColor(.white)
//                    }
//                    .labelsHidden()
//                    .onChange(of: audio.isPlaying) { oldValue, newValue in
//                        newValue ? audio.play() : audio.pause()
//                    }
//                    .toggleStyle(SpeakerToggleStyle(
//                        onColor: AppTheme.Streak,
//                        offColor: Color.gray.opacity(0.2),
//                        iconColor: Color.black,
//                        shadowColor: AppTheme.accent )
//                    )
//                }
//
//            }
//            .frame(width: 350,height: 280)
//            .background(
//                AppTheme.daysBackground.opacity(0.6)
//                    .background(.ultraThinMaterial)
//            )
//            .cornerRadius(16)
//            .shadow(radius: 10)
//        }
//        .onAppear {
//            audio.configureSession()
//            audio.load(resource: "music", ext: "mp3")
//            if audio.isPlaying { audio.play() }
//        }
//    }
//}
//
//// 👇 إشعار لاختيار الصورة من الخلايا
//extension Notification.Name {
//    static let didSelectArtworkImage = Notification.Name("didSelectArtworkImage")
//}
//
//#if DEBUG
//struct InfiniteCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView(showCalendar: .constant(true))
//    }
//}
//#endif
import SwiftUI
import UIKit
import AVFoundation

// MARK: - Models
struct CalendarMonth: Identifiable {
    let id = UUID()
    let month: Date
    let days: [DayData]
}

struct DayData: Identifiable {
    let id = UUID()
    let date: Date
    let imageName: String? // nil = لا توجد صورة
}

// MARK: - Calendar View
struct CalendarView: View {
    @Binding var showCalendar: Bool
    @State private var months: [CalendarMonth] = []
    @State private var showPopup = false
    @State private var isSoundOn = true
    @AppStorage("userName") private var teamName: String = "Team 19"
    @State private var isEditing = false
    @State private var showHome = false

    @State private var showGallery = false
    @State private var selectedImageName: String? = nil
    @ObservedObject var calendar = CalendarModel.shared

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(months) { month in
                            MonthView(month: month)
                        }
                    }
                    .padding(.vertical)
                }
                .blur(radius: showPopup ? 6 : 0)

                if showPopup {
                    PopupView(showPopup: $showPopup,
                              teamName: $teamName,
                              isEditing: $isEditing,
                              isSoundOn: $isSoundOn)
                }
            }
            .onAppear {
                if months.isEmpty { loadTenMonths() }
                UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
                UINavigationBar.appearance().shadowImage = UIImage()

                NotificationCenter.default.addObserver(forName: .didSelectArtworkImage, object: nil, queue: .main) { notif in
                    if let name = notif.object as? String {
                        selectedImageName = name
                        showGallery = true
                    }
                }
            }
            .appBackground()

            // Toolbar
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button { withAnimation { showPopup = true } } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                    }
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: HomePage()
                        .navigationBarBackButtonHidden(true)) {
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.white)
                        }
                }
            }

            // FullScreen Cover for Home
            .fullScreenCover(isPresented: $showHome) { HomePage() }

            // FullScreen Cover for Artwork Gallery
            .fullScreenCover(isPresented: $showGallery) {
                let artworks = CalendarModel.shared.artworks
                if let selectedName = selectedImageName,
                   let startIndex = artworks.firstIndex(where: { $0.imageName == selectedName }) {
                    ArtworkGalleryView(artworks: artworks, startIndex: startIndex)
                } else {
                    ArtworkGalleryView(artworks: artworks)
                }
            }


            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial.opacity(3), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - Helpers
    func loadTenMonths() {
        let today = Date()
        let calendar = Calendar.current
        months = (0..<5).compactMap { offset in
            if let date = calendar.date(byAdding: .month, value: offset, to: today) {
                return generateMonth(for: date)
            }
            return nil
        }
    }

    func generateMonth(for date: Date) -> CalendarMonth {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return CalendarMonth(month: date, days: [])
        }

        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy_MM_dd"   // نفس اللي تستخدمينه في اسم الملف

        let days = range.map { day -> DayData in
            let dayDate = calendar.date(bySetting: .day, value: day, of: date)!
            let dayKey = formatter.string(from: dayDate)

            // ✅ بدل isDate(..): طابق بالنص
            let artwork = CalendarModel.shared.artworks.first { art in
                // لو التاريخ محفوظ كنص بنفس النمط
                if art.date == dayKey { return true }
                // أو لو اسم الصورة يحتوي اليوم (مثل drawing_yyyy_MM_dd.png / بدون امتداد)
                return art.imageName.contains(dayKey)
            }

            return DayData(date: dayDate, imageName: artwork?.imageName)
        }

        return CalendarMonth(month: date, days: days)
    }

}

// MARK: - Month View
struct MonthView: View {
    let month: CalendarMonth

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(monthTitle(for: month.month))
                .font(.headline)
                .padding(.leading, -165)
                .foregroundColor(.white)
                .frame(maxWidth: 375, minHeight: 40)
                .background(AppTheme.daysBackground)
                .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
                .padding(.top, 50)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
                ForEach(month.days) { day in
                    DayCell(day: day, days: month.days, onImageTap: { imageName in
                        NotificationCenter.default.post(name: .didSelectArtworkImage, object: imageName)
                    })
                }
            }
            .frame(width: 360)
            .padding(.vertical)
            .padding(.all, 8)
            .background(AppTheme.monthsBackground.opacity(0.4))
            .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))
            .shadow(color: .black.opacity(0.25), radius: 7, x: 0, y: 4)
        }
    }

    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Day Cell
struct DayCell: View {
    let day: DayData
    let days: [DayData]
    var onImageTap: (String) -> Void

    var body: some View {
        Button {
            if let imageName = day.imageName {
                onImageTap(imageName)
            }
        } label: {
            ZStack(alignment: .bottomLeading) {
                if let imageName = day.imageName {
                    // جلب الصورة من المستندات
                    if let uiImage = loadImageFromDocuments(name: imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 55)
                            .background(.white)
                            .clipped()
                            .cornerRadius(8)
                    } else {
                        // fallback إذا الصورة مش موجودة
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppTheme.daysBackground.opacity(0.7))
                            .frame(width: 60, height: 55)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppTheme.daysBackground.opacity(0.7))
                        .frame(width: 60, height: 55)
                }
                
                Text("\(Calendar.current.component(.day, from: day.date))")
                    .font(.caption)
                    .bold()
                    .foregroundColor(AppTheme.monthsBackground)
                    .padding(4)
            }
        }
        .buttonStyle(.plain)
    }

    func loadImageFromDocuments(name: String) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(name)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
}

// MARK: - Popup View
struct PopupView: View {
    @Binding var showPopup: Bool
    @Binding var teamName: String
    @Binding var isEditing: Bool
    @Binding var isSoundOn: Bool
    @StateObject private var audio = AudioManager.shared

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { withAnimation { showPopup = false } }

            VStack(spacing: 50) {
                HStack {
                    Button { withAnimation { showPopup = false } } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }

                HStack {
                    if isEditing {
                        TextField("Your name", text: $teamName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.black)
                        Button { isEditing = false } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                        }
                    } else {
                        Text(teamName)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Button { isEditing = true } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                        }
                    }
                }

                HStack(spacing: 160)  {
                    Text("Sounds")
                        .foregroundColor(.white)

                    Toggle(isOn: $audio.isPlaying) {
                        Image(systemName: audio.isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .foregroundColor(.white)
                    }
                    .labelsHidden()
                    .onChange(of: audio.isPlaying) { oldValue, newValue in
                        newValue ? audio.play() : audio.pause()
                    }
                    .toggleStyle(SpeakerToggleStyle(
                        onColor: AppTheme.Streak,
                        offColor: Color.gray.opacity(0.2),
                        iconColor: Color.black,
                        shadowColor: AppTheme.accent)
                    )
                }
            }
            .frame(width: 350,height: 280)
            .background(AppTheme.daysBackground.opacity(0.6)
                .background(.ultraThinMaterial))
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .onAppear {
            audio.configureSession()
            audio.load(resource: "music", ext: "mp3")
            if audio.isPlaying { audio.play() }
        }
    }
}

// 👇 إشعار لاختيار الصورة من الخلايا
extension Notification.Name {
    static let didSelectArtworkImage = Notification.Name("didSelectArtworkImage")
}

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    @State static var showCalendar = false
    static var previews: some View {
        CalendarView(showCalendar: $showCalendar)
    }
}
#endif
