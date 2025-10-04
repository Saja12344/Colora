//
//  Logoscreen.swift
//  Colora App
//
//  Created by Najla on 06/04/1447 AH.
//

//
//  ContentView.swift
//  Colora App
//
//  Created by Najla on 03/04/1447 AH.
//

import SwiftUI

struct Logoscreen: View {

    // Use Doubles (not Ints) so you don't get 0
    private let bg = Color(red: 40.0/255.0, green: 54.0/255.0, blue: 43.0/255.0) // #28362B
    private let accent = Color(red: 156.0/255.0, green: 146.0/255.0, blue: 210.0/255.0)
    private let yellow = Color(red: 255/255.0, green: 237/255.0, blue: 168/255.0)

    var body: some View {
        ZStack {
            // Solid background that truly fills the screen
            Rectangle()
                .fill(bg)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("logo colora") // ensure the asset name matches EXACTLY
                    .resizable()
                    .scaledToFit()
                    .frame(width: 213, height: 59)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                
                
                HStack(spacing: 0) {
                    Text("Draw, Feel, ")
                        .foregroundStyle(.white)
                        .font(.nunitoBold(24))
                        .font(.system(size: 24, weight: .bold))
                    Text("Reflect!")
                        .foregroundStyle(accent)
                        .font(.nunitoBold(24))
                        
                }
                
                
                HStack(spacing: 0){
                    Text("Powered By ")
                        .foregroundStyle(.white)
                        .font(.nunitoBold(16))
                       
                    
                    Text("Team 19")
                        .foregroundStyle(yellow)
                        .font(.nunitoBold(16))
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                        
                    
                }
            
            
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    Logoscreen()
}
