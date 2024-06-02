//
//  LoadingView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 50)
                Image(asset: .wxmBlackLogo) // Use your logo image here
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .rotationEffect(.degrees(rotation))
                    .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: rotation)
                    .onAppear {
                        rotation = 360
                }
            }
            Spacer()
        }
        .background() {
            Color(colorEnum: .top)
        }
    }
}

#Preview {
    LoadingView()
}
