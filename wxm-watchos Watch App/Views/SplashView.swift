//
//  SplashView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 2/6/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            VStack {
                Image(asset: .weatherXMLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width:180)
                    .padding(EdgeInsets(top: -60, leading: 0, bottom: -40, trailing: 0))
                
                Text("WatchWeatherXM")
                    .font(.system(size: CGFloat(.mediumFontSize)))
            }
        }
        .background() {
            Color(colorEnum: .top)
        }
    }
}

#Preview {
    SplashView()
}
