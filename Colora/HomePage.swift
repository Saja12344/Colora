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
    @State private var showCanva = false
    @State private var dragOffset: CGFloat = 0
    
    
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.clear.appBackground()
                    .ignoresSafeArea()
                    .onAppear {
                        if audio.isPlaying {
                            audio.play()
                        }
                    }
                
                VStack {
                    // Calendar button
                    Button {
                        withAnimation(.easeInOut) { showCalendar = true }
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

                            Text("Breathe, imagine, and let your thoughts flow")
                                .font(.system(size: 24, weight: .light))
                                .foregroundStyle(.white)
                                .padding(.top, 16)

                            Text("Your canvas awaits — make it yours!")
                                .font(.system(size: 24, weight: .light))
                                .foregroundStyle(.white)
                                .padding(.top, 8)

                        }
                        .padding(.all,16)
                        
                   
                        Spacer()
                       Spacer()
                      Spacer()
                        
                        // “Swipe Up” hint with motion
                        VStack {
                            Image(systemName: "chevron.up")
                                .foregroundStyle(.white)
                                .offset(y: dragOffset / 10) // little motion feedback
                            Image(systemName: "chevron.up")
                                .foregroundStyle(.white)
                                .offset(y: dragOffset / 10)
                            Text("Breathe in, and begin.")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(red: 255/255, green: 237/255, blue: 168/255))
                                .padding(.top, 12)
                        }
                        .opacity(1.0 - min(dragOffset / 150, 1))
                    }
                
//                    .offset(y: dragOffset)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                // Only react to upward drags
//                                if value.translation.height < 0 {
//                                    dragOffset = value.translation.height
//                                }
//                            }
//                            .onEnded { value in
//                                if value.translation.height < -120 {
//                                    // Enough upward drag → trigger full screen
//                                    withAnimation(.spring()) {
//                                        showCanva = true
//                                        dragOffset = 0
//                                    }
//                                } else {
//                                    // Cancel
//                                    withAnimation(.spring()) {
//                                        dragOffset = 0
//                                    }
//                                }
//                            }
//                    )
                    
                    // Calendar overlay
                    if showCalendar {
                        CalendarView(showCalendar: $showCalendar)
                            .transition(.move(edge: .leading))
                            .zIndex(1)
                    }
                }
            .offset(y: dragOffset)
              .gesture(
                  DragGesture()
                      .onChanged { value in
                          if value.translation.height < 0 {
                              dragOffset = value.translation.height
                          }
                      }
                      .onEnded { value in
                          if value.translation.height < -120 {
                              withAnimation(.spring()) {
                                  showCanva = true
                                  dragOffset = 0
                              }
                          } else {
                              withAnimation(.spring()) {
                                  dragOffset = 0
                              }
                          }
                      }
              )
          }
          .fullScreenCover(isPresented: $showCanva) {
              Canva()
          }
                // 👇 full screen transition
             }
     
    
        }
  
    
    
    
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomePage()
        }
    }
