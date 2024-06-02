//
//  HiddenContentView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 2/6/24.
//

import SwiftUI

struct HiddenContentView: View {
    let deviceName: String
    
    var body: some View {
        VStack(alignment: .center, spacing: CGFloat(.smallSpacing)) {
            Image(asset: .lock)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .padding(8)
                .frame(width: 40)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
            Text(LocalizableString.hiddenContentTitle.localized)
                .font(.system(size: CGFloat(.titleFontSize)))
            Text(LocalizableString.hiddenContentDescription(deviceName).localized.attributedMarkdown ?? "")
                .font(.system(size: CGFloat(.caption)))
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    HiddenContentView(deviceName: NetworkDevicesResponse.dummyData[0].name)
}
