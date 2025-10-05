import SwiftUI
import AVFoundation

final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?

    @Published var isPlaying: Bool = false

    func configureSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ Audio session error:", error)
        }
    }

    func load(resource: String, ext: String) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
            print("❌ File not found: \(resource).\(ext)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.prepareToPlay()
        } catch {
            print("⚠️ AVAudioPlayer init failed:", error)
        }
    }

    func play() {
        guard let player else { return }
        if !player.isPlaying {
            player.play()
            isPlaying = true
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.stop()
        isPlaying = false
    }
}



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
// MARK: - Toggle Style
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
        let travel = (trackWidth - knobSize) / 2.5

        return ZStack {
            Capsule()
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: trackWidth, height: trackHeight)
                .shadow(color: configuration.isOn ? shadowColor.opacity(0.35) : .clear,
                        radius: 12, x: 16, y: 6)

            Circle()
                .fill(.white)
                .frame(width: knobSize, height: knobSize)
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
                .overlay(
                    Image(systemName: configuration.isOn ? "speaker.wave.2" : "speaker.slash")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(iconColor)
                )
                .offset(x: configuration.isOn ? travel : -travel)
                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: configuration.isOn)
        }
        .contentShape(Rectangle())
        .onTapGesture { configuration.isOn.toggle() }
    }
}



struct AppTheme {
    // MARK: - Colors
    static let bg = Color(red: 40/255, green: 54/255, blue: 43/255) // #28362B
    static let accent = Color(red: 156/255, green: 146/255, blue: 210/255)
    static let yellow = Color(red: 255/255, green: 237/255, blue: 168/255)
    
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
