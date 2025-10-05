//
//  GlassAlertView.swift
//  Ccolora
//
//  Created by Deemah Alhazmi on 02/10/2025.
//

import SwiftUI

struct GlassAlertView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            content
        }
        .padding(20)
        .frame(maxWidth: 280)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 10)
    }
}
