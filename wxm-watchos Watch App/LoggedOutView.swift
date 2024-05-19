//
//  LoggedOutView.swift
//  wxm-watchos Watch App
//
//  Created by Marcelino on 19/5/24.
//

import SwiftUI

struct LoggedOutView: View {
    var body: some View {
        VStack(spacing: 8.0) {
            
            VStack(spacing: 8.0) {
                Text("loggedOutTitle")
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("loggedOutDescription")
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Text("signIn")
                    Spacer()
                }
                .padding(.vertical, 12.0)
            }
        }
        .padding(.horizontal, 8.0)
//        .widgetBackground {
//            Color(colorEnum: .bg)
//        }
    }
}

#Preview {
    LoggedOutView()
}
