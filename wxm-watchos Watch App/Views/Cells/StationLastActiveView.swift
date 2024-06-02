//
//  StationLastActiveView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 2/6/24.
//

import SwiftUI

struct StationLastActiveView: View {

    let configuration: Configuration

    var body: some View {
        HStack(spacing: 0.0) {
            Image(asset: configuration.icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .foregroundColor(Color(colorEnum: configuration.stateColor))

            Text(configuration.lastActiveAt?.lastActiveTime() ?? "-")
                .font(.system(size: 10))
                .foregroundColor(Color(colorEnum: configuration.stateColor))
                .padding(.trailing, CGFloat(.smallSidePadding))
        }
        .WXMCardStyle(backgroundColor: Color(colorEnum: configuration.tintColor),
                      insideHorizontalPadding: 0.0,
                      insideVerticalPadding: -4.0,
                      cornerRadius: CGFloat(.buttonCornerRadius))
    }
}

extension StationLastActiveView {
    struct Configuration {
        let lastActiveAt: String?
        let icon: AssetEnum
        let stateColor: ColorEnum
        let tintColor: ColorEnum
    }
}

#Preview {
    let isActive = true
    let configuration = StationLastActiveView.Configuration(
        lastActiveAt: Date().ISO8601Format(),
        icon: .wifi,
        stateColor: activeStateColor(isActive: isActive),
        tintColor: activeStateTintColor(isActive: isActive)
    )
    return StationLastActiveView(configuration: configuration)
}
