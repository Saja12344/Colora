//
//  ContentView.swift
//  Colora
//
//  Created by saja khalid on 06/04/1447 AH.
//
import SwiftUI

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

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

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
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.blue.opacity(0.3)) // أو صورة: Image("backgroundIcons")
                    .frame(height: 100)            // ارتفاع الخلفية حسب الأيقونات
                    .edgesIgnoringSafeArea(.top)

                            Image("background")
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                
                HStack{
                    Image(systemName: "gearshape")
                    Spacer()                          // يدفع العناصر لليمين
                    Image(systemName: "chevron.forward")
                    
                }
                //icons settings
                        .padding(.leading, 30)   // مسافة من الجهة اليسار
                        .padding(.trailing, 30)
                        .padding(.top,30)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .position(x: UIScreen.main.bounds.width / 2, y: 50) // pinned at top
            ScrollView {

                LazyVStack(spacing: 20) {
                    ForEach(months) { month in
                        VStack(alignment: .leading, spacing: 10) {

                            // 👇 اسم الشهر داخل صندوق ملون
                            Text(monthTitle(for: month.month))
                                .font(.headline)
                                .foregroundColor(.white)                // لون النص
                                .padding(.vertical,10)                  // padding داخل الصندوق
                                .padding(.horizontal,110)
                               /* .background(backgroundMonthetitle)   */          // لون الخلفية
                                .cornerRadius(10)
                                .padding(.top, 100)                     // المسافة من فوق
                                .padding(.leading)

                            // 👇 أيام الشهر
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                                ForEach(month.days) { day in
                                    Text("\(Calendar.current.component(.day, from: day.date))")
                                        .frame(width: 40, height: 40)
                                        .background(day.imageName != nil ? Color.green : Color.gray.opacity(0.3))
                                        .cornerRadius(6)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .onAppear {
                            // لو هذا آخر شهر، نحمل الشهر اللي بعده
                            if month.id == months.last?.id {
                                loadNextMonth()
                            }
                        }
                    }
                }

                .padding(.vertical)
                .onAppear {
                    if months.isEmpty { loadInitialMonths() }
                }
            }
        }
    }

    // MARK: - Helpers (على مستوى الـ struct)
    func loadInitialMonths() {
        let today = Date()
        months = [
            generateMonth(for: today),
            generateMonth(for: Calendar.current.date(byAdding: .month, value: 1, to: today)!)
        ]
    }

    func loadNextMonth() {
        guard let last = months.last,
              let nextDate = Calendar.current.date(byAdding: .month, value: 1, to: last.month) else { return }
        months.append(generateMonth(for: nextDate))
    }

    func generateMonth(for date: Date) -> CalendarMonth {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return CalendarMonth(month: date, days: [])
        }

        let days = range.map { day -> DayData in
            let dayDate = calendar.date(bySetting: .day, value: day, of: date)!
            return DayData(date: dayDate, imageName: day % 3 == 0 ? "sampleImage" : nil)
        }

        return CalendarMonth(month: date, days: days)
    }

    func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct DayCell: View {
    let day: DayData

    var body: some View {
        if let imageName = day.imageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .clipped()
        } else {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
        }
    }
}

// Preview: لو Xcode 15 تقدر تستخدمين #Preview { ... }
// الطريقة التقليدية:
#if DEBUG
struct InfiniteCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
#endif

