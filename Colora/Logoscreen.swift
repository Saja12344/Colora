import SwiftUI

struct Logoscreen: View {
    @Binding var showOnboarding: Bool
    @State private var isActive = false
    

    var body: some View {
        ZStack {
            AppTheme.bg.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Spacer()
                
                Image("logo colora") // تأكد اسم الصورة بالـ Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 213, height: 59)

                VStack {
                    HStack(spacing: 0) {
                        Text("Draw, Feel, ")
                            .foregroundColor(.white)
                            .font(.nunitoBold(24))
                        Text("Reflect!")
                            .foregroundColor(AppTheme.accent)
                            .font(.nunitoBold(24))

                    }
                    Spacer()

                    
                    HStack(spacing: 0) {
                        Text("Powered By ")
                            .foregroundColor(.white)
                            .font(.nunitoBold(16))
                        Text("Team 19")
                            .foregroundColor(AppTheme.yellow)
                            .font(.nunitoBold(16))
                    }
                    .padding(.bottom) // المسافة من الأسفل
                }

//                Spacer()
            }                    .padding(.top,300) // المسافة من الأسفل


        }

        .preferredColorScheme(.dark)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showOnboarding = true
                    isActive = true
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    Logoscreen(showOnboarding: .constant(false))
}
// MARK: - Custom Font Helper

