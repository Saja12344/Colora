import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Color(red: 40/255, green: 54/255, blue: 43/255)
//                        .ignoresSafeArea()
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 176/255, green: 166/255, blue: 223/255).opacity(0.4),
                            .clear
                        ]),
                        startPoint: UnitPoint(x: -0.2, y: 0.2),
                        endPoint: UnitPoint(x: 0.8, y: 0.8)
                    )
//                    .ignoresSafeArea()
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 176/255, green: 166/255, blue: 223/255).opacity(0.4),
                            .clear
                        ]),
                        startPoint: UnitPoint(x: 0.2, y: 0.2),
                        endPoint: UnitPoint(x: 1.2, y: 0.8)
                    )
                    .blur(radius: 20)
                }
                    .ignoresSafeArea()

            )
    }
}
extension View {
    func appBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }}



struct AppTheme {
    // MARK: - Colors

        static let primary = Color(UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1))
        static let secondary = Color(UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1))
        static let grayBackground = Color.gray.opacity(0.3)
    static let monthsBackground = Color(
        red: 0x50 / 255.0,
        green: 0x5B / 255.0,
        blue: 0x54 / 255.0
        )
    static let daysBackground = Color(
        red: 0x28 / 255.0,   // R = 40
        green: 0x36 / 255.0, // G = 54
        blue: 0x2B / 255.0   // B = 43
    )

        static let Streak = Color(
            red: 0xB0 / 255.0,   // R = 176
            green: 0xA6 / 255.0, // G = 166
            blue: 0xDF / 255.0   // B = 223
        )

    }

// Helper لشكل مخصص فيه اختيار الكورنرات
struct RoundedCorner: Shape {
    var radius: CGFloat = 8
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}




    // MARK: - Spacing
    struct Spacing {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 32
    }

    // MARK: - Fonts
    struct Fonts {
        static let title = Font.system(size: 24, weight: .bold)
        static let subtitle = Font.system(size: 18, weight: .semibold)
        static let body = Font.system(size: 14, weight: .regular)
    }

    // MARK: - Icons
    struct Icons {
        static let settings = "gearshape"
        static let forward = "chevron.forward"
        static let back = "chevron.backward"
    }

    // MARK: - Buttons style (example)
    struct Buttons {
        static let cornerRadius: CGFloat = 10
        static let padding: CGFloat = 12
    }
