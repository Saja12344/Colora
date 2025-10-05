//
//  HomePage.swift
//  Colora
//
//  Created by Norah Aldawsari on 10/04/1447 AH.
//

import SwiftUI

struct HomePage: View {
    @State private var showCalendar = false
    @StateObject private var audio = AudioManager.shared
    @AppStorage("userName") private var userName: String = ""


    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.clear.appBackground()
            
                    .onAppear {
                        if audio.isPlaying {
                            audio.play() // لو شغال، يكمل
                        }
                    }
                    .onDisappear {
                        // ممكن تخلينه فاضي أو توقفين الصوت لو حبيتي
                    }
                
                VStack {
                    // أيقونة الكالندر
                    Button {
                        withAnimation(.easeInOut) {
                            showCalendar = true
                        }
                    } label: {
                        Image(systemName: "photo.stack")
                            .padding(12)
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(28)
                            .padding(.trailing, 300)
                    }
                    
                    Spacer()
                    
                    
                    // هنا الانتقال لصفحة الكالندر
                    
                    
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Welcome")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.white)

                            Text(userName.isEmpty ? "Team 19," : "\(userName),") // ✅ shows saved name
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color(red: 176/255, green: 166/255, blue: 223/255))
                        }

                        
                        Text("To your creative space!")
                            .font(.system(size: 36, weight: .medium))
                            .foregroundStyle(.white)
                        Text("Take a moment to simply be")
                            .font(.system(size: 24, weight: .light))
                            .foregroundStyle(.white)
                            .padding(.top, 16)
                        Text("Your Canvas is waiting!")
                            .font(.system(size: 24, weight: .light))
                            .foregroundStyle(.white)
                        
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack{
                        Image(systemName: "chevron.up")
                            .foregroundStyle(.white)
                        Image(systemName: "chevron.up")
                            .foregroundStyle(.white)
                        Text("Breath in, and begin.")
                            .font(.system(size: 16, weight:.bold))
                            .foregroundColor(Color(red: 255/255, green: 237/255, blue: 168/255))
                            .padding(.top, 12)
                        
                        
                    }
                    
                }
                if showCalendar {
                    CalendarView(showCalendar: $showCalendar)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                    
                }}}}}


#Preview {
    HomePage()
}

