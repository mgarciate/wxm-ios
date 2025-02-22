//
//  StationIndication.swift
//  wxm-ios
//
//  Created by Pantelis Giazitsis on 22/2/24.
//

import SwiftUI
import DomainLayer
import Toolkit

private struct StationIndicationModifier: ViewModifier {
	let device: DeviceDetails
	let followState: UserDeviceFollowState?
	let mainScreenViewModel = MainScreenViewModel.shared

	func body(content: Content) -> some View {
		content
			.indication(show: .init(get: { device.hasIssues(mainVM: mainScreenViewModel, followState: followState) },
									set: { _ in }),
						borderColor: Color(colorEnum: device.overallWarningType(mainVM: mainScreenViewModel, followState: followState).iconColor),
						bgColor: Color(colorEnum: device.overallWarningType(mainVM: mainScreenViewModel, followState: followState).tintColor)) {
				statusView
			}
	}
}

private extension StationIndicationModifier {
	@ViewBuilder
	var statusView: some View {
		let alertsCount = device.issuesCount(mainVM: mainScreenViewModel, followState: followState)
		let warningType = device.overallWarningType(mainVM: mainScreenViewModel, followState: followState)
		if alertsCount > 1 {
			multipleAlertsView(alertsCount: alertsCount)
		} else if !device.isActive {
			HStack(spacing: CGFloat(.smallSpacing)) {
				Image(asset: warningType.icon)
					.renderingMode(.template)
					.foregroundColor(Color(colorEnum: warningType.iconColor))

				Text(LocalizableString.offlineStation.localized)
					.foregroundColor(Color(colorEnum: .text))
					.font(.system(size: CGFloat(.mediumFontSize), weight: .bold))

				Spacer()
			}
			.padding(CGFloat(.smallSidePadding))
		} else {
			warningView
		}
	}

	@ViewBuilder
	func multipleAlertsView(alertsCount: Int) -> some View {
		let warningType = device.overallWarningType(mainVM: mainScreenViewModel, followState: followState)
		HStack(spacing: CGFloat(.smallSpacing)) {
			Image(asset: warningType.icon)
				.renderingMode(.template)
				.foregroundColor(Color(colorEnum: warningType.iconColor))

			Text(LocalizableString.issues(alertsCount).localized)
				.foregroundColor(Color(colorEnum: .text))
				.font(.system(size: CGFloat(.mediumFontSize), weight: .bold))

			Spacer()

			Button {
				Router.shared.navigateTo(.viewMoreAlerts(ViewModelsFactory.getAlertsViewModel(device: device,
																							  mainVM: mainScreenViewModel,
																							  followState: followState)))

				WXMAnalytics.shared.trackEvent(.selectContent, parameters: [.contentType: .viewAll,
																	  .itemId: .multipleIssue])
			} label: {
				Text(LocalizableString.viewAll.localized)
					.padding(.horizontal, CGFloat(.mediumToLargeSidePadding))
					.padding(.vertical, CGFloat(.smallToMediumSidePadding))
			}
			.buttonStyle(WXMButtonStyle.transparentFixedSize)
			.clipShape(Capsule())

		}
		.padding(CGFloat(.defaultSidePadding))
	}

	@ViewBuilder
	var warningView: some View {
		if device.needsUpdate(mainVM: mainScreenViewModel, followState: followState) {
			CardWarningView(title: LocalizableString.stationWarningUpdateTitle.localized,
							message: LocalizableString.stationWarningUpdateDescription.localized,
							showContentFullWidth: true,
							closeAction: nil) {
				Button {
					mainScreenViewModel.showFirmwareUpdate(device: device)

					WXMAnalytics.shared.trackEvent(.prompt, parameters: [.promptName: .OTAAvailable,
																   .promptType: .warnPromptType,
																   .action: .action])
				} label: {
					Text(LocalizableString.stationWarningUpdateButtonTitle.localized)
				}
				.buttonStyle(WXMButtonStyle.transparent)
				.buttonStyle(.plain)
				.padding(.top, CGFloat(.minimumPadding))
			}
			.onAppear {
				WXMAnalytics.shared.trackEvent(.prompt, parameters: [.promptName: .OTAAvailable,
															   .promptType: .warnPromptType,
															   .action: .viewAction])
			}
		} else if device.isBatteryLow(followState: followState) {
			CardWarningView(title: LocalizableString.stationWarningLowBatteryTitle.localized,
							message: LocalizableString.stationWarningLowBatteryDescription.localized,
							showContentFullWidth: true,
							closeAction: nil) {
				Button {
					guard let profile = device.profile else {
						return
					}

					var urlString: String?
					switch profile {
						case .m5:
							urlString = DisplayedLinks.m5Batteries.linkURL
						case .helium:
							urlString = DisplayedLinks.heliumBatteries.linkURL
					}

					if let urlString, let url = URL(string: urlString) {
						UIApplication.shared.open(url)
					}
					
					WXMAnalytics.shared.trackEvent(.selectContent, parameters: [.contentType: .webDocumentation,
																		  .itemId: .custom(urlString ?? "")])
				} label: {
					Text(LocalizableString.stationWarningLowBatteryButtonTitle.localized)
				}
				.buttonStyle(WXMButtonStyle.transparent)
				.buttonStyle(.plain)
				.padding(.top, CGFloat(.minimumPadding))
			}
		} else {
			EmptyView()
		}
	}

}

private struct OfflineStationIndicationModifier: ViewModifier {
	let device: DeviceDetails

	func body(content: Content) -> some View {
		content
			.indication(show: .init(get: { !device.isActive },
									set: { _ in }),
						borderColor: Color(colorEnum: CardWarningType.error.iconColor),
						bgColor: Color(colorEnum: CardWarningType.error.tintColor)) {
				CardWarningView(type: .error,
								title: LocalizableString.offlineStation.localized,
								message: LocalizableString.offlineStationDescription.localized,
								closeAction: nil) {
					EmptyView()
				}
			}
	}
}

extension View {
	@ViewBuilder
	func stationIndication(device: DeviceDetails, followState: UserDeviceFollowState?) -> some View {
		modifier(StationIndicationModifier(device: device, followState: followState))
	}

	@ViewBuilder
	func offlineStationIndication(device: DeviceDetails) -> some View {
		modifier(OfflineStationIndicationModifier(device: device))
	}
}

#Preview {
	VStack {
		HStack {
			Spacer()
			Text(verbatim: "Station")
			Spacer()
		}
	}
	.WXMCardStyle()
	.stationIndication(device: .mockDevice, followState: nil)
	.wxmShadow()
	.padding()
}
