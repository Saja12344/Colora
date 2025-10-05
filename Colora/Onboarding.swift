import SwiftUI
import AVFoundation

// MARK: - Slide model
struct OnboardingSlide: Identifiable {
    let id = UUID()
    let tagTitle: String
    let headline: String
    let subtext: String
    let iconSystemName: String // outline SF Symbol (no ".fill")
    let imageName: String      // Asset name (PNG/JPG)
}

// MARK: - Simple audio manager for looping bg music
final class AudioManager: ObservableObject {
    private var player: AVAudioPlayer?

    func configureSession() {
        do {
            // .ambient respects the silent switch (no background capability needed)
            // Use .playback if you want to ignore silent switch
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ Audio session error:", error)
        }
    }

    func load(resource: String, ext: String) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
            print("❌ music file not found: \(resource).\(ext)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1       // loop forever
            player?.prepareToPlay()
            player?.volume = 0.5
        } catch {
            print("⚠️ AVAudioPlayer init failed:", error)
        }
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player?.stop()
        player = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

struct Onboarding: View {
    @State private var isOn = true
    @State private var page = 0
    @StateObject private var audio = AudioManager()   // 👈 keep the player alive

    init() {
        UIPageControl.appearance().isHidden = true
    }

    private let bg = Color(red: 240/255, green: 240/255, blue: 250/255)

    private let slides: [OnboardingSlide] = [
        .init(
            tagTitle: "Draw",
            headline: "Draw your feelings",
            subtext: "Let your emotions flow onto the canvas. No rules, no pressure — just space to release what’s inside.",
            iconSystemName: "hand.tap",
            imageName: "Draw2"
        ),
        .init(
            tagTitle: "Feel",
            headline: "Feel your calm",
            subtext: "Gentle prompts guide you to explore your emotions, helping you shift from stress into balance.",
            iconSystemName: "sparkles",
            imageName: "Feel"
        ),
        .init(
            tagTitle: "Reflect",
            headline: "Reflect on your journey",
            subtext: "Save your drawings and words, and see how your inner world transforms over time.",
            iconSystemName: "text.bubble",
            imageName: "breathe"
        )
    ]

    private let ctaTitle = "Begin your calm"
    private let skip = "Skip"

    // ✅ Green & enabled only on the last slide
    private var isLastPage: Bool { page == slides.count - 1 }

    var body: some View {
        ZStack(alignment: .topLeading) {
            bg.ignoresSafeArea()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(
                    SpeakerToggleStyle(
                        onColor: Color(hex: "FFEDA8"),
                        offColor: Color.gray.opacity(0.2),
                        iconColor: Color(hex: "28362B"),
                        shadowColor: Color(hex: "B0A6DF")
                    )
                )
                .padding(.top, 24)
                .padding(.leading, 24)
                // 🔊 respond to toggle changes
                .onChange(of: isOn) { on in
                    if on {
                        audio.play()
                    } else {
                        audio.pause()
                    }
                }

            VStack(spacing: 16) {
                Spacer().frame(height: 100)

                // Paged cards
                TabView(selection: $page) {
                    ForEach(Array(slides.enumerated()), id: \.element.id) { idx, slide in
                        OnboardingCard(slide: slide)
                            .tag(idx)
                            .frame(maxWidth: .infinity, minHeight: 370)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 380)

                // --- Tappable dots between card and buttons ---
                DotsIndicator(total: slides.count, current: $page)
                    .padding(.top, 4)

                Spacer()

                // ✅ CTA: green & enabled only on last slide; dim/disabled otherwise
                Button(ctaTitle) {
                    // Runs only when enabled (last slide)
                    // TODO: continue app flow (dismiss onboarding / navigate)
                }
                .font(.nunitoBold(24))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 64)
                .background(
                    (isLastPage ? Color(hex: "28362B") : Color.black.opacity(0.10))
                        .animation(.easeInOut(duration: 0.2), value: isLastPage)
                )
                .clipShape(Capsule())
                .padding(.horizontal, 24)
                .disabled(!isLastPage)          // not tappable until last slide
                .allowsHitTesting(isLastPage)   // ignore taps when not last

                Button(skip) { }
                    .font(.nunitoMedium(16))
                    .foregroundColor(Color(hex: "28362B"))
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        // 🔊 set up / tear down audio once the view appears/disappears
        .onAppear {
            audio.configureSession()
            audio.load(resource: "music", ext: "mp3")   // 👈 your file: music.mp3
            if isOn { audio.play() }
        }
        .onDisappear {
            audio.stop()
        }
    }
}

// MARK: - Tappable Black dots control (wired to TabView)
struct DotsIndicator: View {
    let total: Int
    @Binding var current: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<max(total, 0), id: \.self) { i in
                let isCurrent = (i == current)
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        current = i
                    }
                    #if os(iOS)
                    UISelectionFeedbackGenerator().selectionChanged()
                    #endif
                } label: {
                    Circle()
                        .fill(isCurrent ? Color.black : Color.black.opacity(0.3))
                        .frame(width: isCurrent ? 8 : 6, height: isCurrent ? 8 : 6)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                        .accessibilityLabel("Go to page \(i + 1)")
                        .accessibilityAddTraits(isCurrent ? .isSelected : [])
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Card View (fixed size, NO MASK) + Fonts
struct OnboardingCard: View {
    private let innerStart = Color(hex: "4E6813")
    private let innerEnd   = Color(hex: "28362B")
    private let shadowColor = Color(hex: "B0A6DF")

    let slide: OnboardingSlide

    private let cardWidth: CGFloat = 224.26
    private let cardHeight: CGFloat = 350
    private let imageWidth: CGFloat = 210
    private let imageHeight: CGFloat = 200

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 20, style: .continuous)

        shape
            .fill(
                LinearGradient(
                    colors: [innerStart.opacity(0.5), innerEnd.opacity(0.5)],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            .frame(width: cardWidth, height: cardHeight)
            .shadow(color: shadowColor.opacity(0.5), radius: 50)
            .overlay(
                shape.stroke(Color.black.opacity(0.25), lineWidth: 1).blendMode(.multiply)
            )
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(slide.tagTitle)
                            .font(.nunitoBold(24))
                            .foregroundColor(Color(hex: "FFEDA8"))
                            .lineLimit(1)

                        Spacer(minLength: 0)

                        Image(systemName: slide.iconSystemName)
                            .font(.system(size: 16, weight: .semibold))
                            .symbolRenderingMode(.monochrome)
                            .foregroundColor(.white.opacity(0.9))
                    }

                    Text(slide.headline)
                        .font(.nunitoBold(16))
                        .foregroundColor(.white)

                    Text(slide.subtext)
                        .font(.nunitoLight(12))
                        .foregroundColor(.white.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Image(slide.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageWidth, height: imageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .clipped()
                }
                .padding(8)
                .frame(width: cardWidth, height: cardHeight, alignment: .top)
            }
            .frame(width: cardWidth, height: cardHeight)
    }
}

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

// MARK: - Font helpers
extension Font {
    static func boldena(_ size: CGFloat)       -> Font { .custom("BoldenaBold-VGjmz", size: size) }
    static func nunitoBold(_ size: CGFloat)    -> Font { .custom("Nunito-Bold", size: size) }
    static func nunitoMedium(_ size: CGFloat)  -> Font { .custom("Nunito-Medium", size: size) }
    static func nunitoLight(_ size: CGFloat)   -> Font { .custom("Nunito-Light", size: size) }
}

// MARK: - Hex helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0; Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}

#Preview { Onboarding() }
