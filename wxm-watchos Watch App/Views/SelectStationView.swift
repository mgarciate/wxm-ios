//
//  SelectStationView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 2/6/24.
//

import SwiftUI

struct SelectStationView: View {
    let deviceName: String
    @State private var isSubscribed = false
    
    var body: some View {
        VStack(alignment: .center, spacing: CGFloat(.smallSpacing)) {
            Image(asset: .accountBalanceWallet)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .padding(8)
                .frame(width: 40)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
            Text("Subscribe to **\(deviceName)** as a patreon. Thank you!".attributedMarkdown ?? "")
                .font(.system(size: CGFloat(.caption)))
                .multilineTextAlignment(.center)
                .lineLimit(4)
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isSubscribed.toggle()
                }
            }) {
                Text(isSubscribed ? "Subscribed" : "Subscribe")
                    .foregroundColor(.white)
                    .padding()
                    .cornerRadius(10)
            }
            .background(isSubscribed ? Color(.success) : Color(.top))
            .cornerRadius(25) // Adjust the radius to your preference
            .padding()
        }
    }
}

#Preview {
    SelectStationView(deviceName: NetworkDevicesResponse.dummyData[0].name)
}
