import SwiftUI
import UIKit // لأننا نستخدم UIImage(named:)

struct CalendarMonth: Identifiable {
    let id = UUID()
    let month: Date
    let days: [DayData]
}

struct DayData: Identifiable {
    let id = UUID()
    let date: Date
    let imageName: String? // nil = مافي صورة
}

struct CalendarView: View {
    @State private var months: [CalendarMonth] = []
    @State private var showPopup = false
    @State private var isSoundOn = true
    @State private var teamName = "Team 19"
    @State private var isEditing = false
    @State private var showHome = false
    @Binding var showCalendar: Bool

    
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
                
                // 👇 Popup (محافظين على نفس التصميم)
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
            }
            .appBackground() // تستخدمها كما كانت
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        withAnimation { showPopup = true }
                    } label: {
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
            
        


            
            .fullScreenCover(isPresented: $showHome) {
                HomePage()
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
        formatter.dateFormat = "yyyy_MM_dd"
        
        let days = range.map { day -> DayData in
            let dayDate = calendar.date(bySetting: .day, value: day, of: date)!
            let imageName = "drawing_\(formatter.string(from: dayDate))"
            if UIImage(named: imageName) != nil {
                return DayData(date: dayDate, imageName: imageName)
            } else {
                return DayData(date: dayDate, imageName: nil)
            }
        }
        
        return CalendarMonth(month: date, days: days)
    }
}

// MARK: - Month View (نفس التخطيط و القيم)
struct MonthView: View {
    let month: CalendarMonth
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 👇 عنوان الشهر (نفس القيم)
            Text(monthTitle(for: month.month))
                .font(.headline)
                .padding(.leading, -165)
                .foregroundColor(.white)
                .frame(maxWidth: 375, minHeight: 40)
                .background(AppTheme.daysBackground)
                .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
                .padding(.top, 50)
            
            // 👇 أيام الشهر
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
                ForEach(month.days) { day in
                    DayCell(day: day, days: month.days)
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

// MARK: - Day Cell (نفس الشكل، مع isStreak محلي)
struct DayCell: View {
    let day: DayData
    let days: [DayData]
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let imageName = day.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 55)
                    .clipped()
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isStreak ? AppTheme.Streak : Color.clear, lineWidth: 4)
                    )
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
    
    private var isStreak: Bool {
        let calendar = Calendar.current
        guard day.imageName != nil else { return false }
        
        let prevDate = calendar.date(byAdding: .day, value: -1, to: day.date)
        let nextDate = calendar.date(byAdding: .day, value: 1, to: day.date)
        
        let hasPrev = prevDate.flatMap { prev in
            days.first(where: { calendar.isDate($0.date, inSameDayAs: prev) })?.imageName != nil
        } ?? false
        
        let hasNext = nextDate.flatMap { next in
            days.first(where: { calendar.isDate($0.date, inSameDayAs: next) })?.imageName != nil
        } ?? false
        
        return hasPrev || hasNext
    }
}

// MARK: - Popup View (نفس الحجم والخلفية والزجاج)
struct PopupView: View {
    @Binding var showPopup: Bool
    @Binding var teamName: String
    @Binding var isEditing: Bool
    @Binding var isSoundOn: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { showPopup = false }
                }
            
            VStack(spacing: 50) {
                HStack {
                    Button {
                        withAnimation { showPopup = false }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                
                HStack {
                    if isEditing {
                        TextField("Team Name", text: $teamName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.black)
                        
                        Button {
                            isEditing = false
                            // هنا ممكن تضيف أي عملية حفظ الاسم
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                        }
                    } else {
                        Text(teamName)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Button {
                            isEditing = true
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                        }
                    }
                }
                
                HStack(spacing: 160)  {
                    Text("Sounds")
                        .foregroundColor(.white)
                    
                    Toggle("", isOn: $isSoundOn)
                        .toggleStyle(SpeakerToggleStyle(
                            onColor: AppTheme.Streak,
                            offColor: .gray.opacity(0.3),
                            iconColor: .black,
                            shadowColor: AppTheme.Streak
                        ))
                }

            }
            .padding()
            .frame(width: 350,height: 280)
            
            //background -- glass with grean
            
            .background(
                AppTheme.daysBackground.opacity(0.6) // لون خفيف
                    .background(.ultraThinMaterial)   // زجاج
            )
            .cornerRadius(16)
            .shadow(radius: 10)
        }
    }
}

// MARK: - Toggle Style (موجود قبل لكن تأكدت إنه هنا)
struct SpeakerToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    var iconColor: Color
    var shadowColor: Color

    private let trackWidth: CGFloat = 88
    private let trackHeight: CGFloat = 44
    private let padding: CGFloat = 4

    func makeBody(configuration: Configuration) -> some View {
        let knobSize = trackHeight - padding * 2
        let travel = (trackWidth - knobSize) / 2

        return ZStack {
            Capsule()
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: trackWidth, height: trackHeight)
                .shadow(color: configuration.isOn ? shadowColor.opacity(0.35) : .clear,
                        radius: 12, x: 10, y: 6)

            Circle()
                .fill(.white)
                .frame(width: knobSize, height: knobSize)
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
                .overlay(
                    Image(systemName: configuration.isOn ? "speaker.wave.2" : "speaker.slash")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(iconColor)
                )
                .offset(x: configuration.isOn ? travel : -travel)
                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: configuration.isOn)
        }
        .contentShape(Rectangle())
        .onTapGesture { configuration.isOn.toggle() }
    }
}
#if DEBUG
struct InfiniteCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(showCalendar: .constant(true))
    }
}
#endif
