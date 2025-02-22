//
//  ClaimDeviceContainerViewModel.swift
//  wxm-ios
//
//  Created by Pantelis Giazitsis on 29/4/24.
//

import Foundation

class ClaimDeviceContainerViewModel: ObservableObject {
	@Published var selectedIndex: Int = 0
	@Published var isMovingNext = true

	var steps: [ClaimDeviceStep] = []
	let navigationTitle: String

	init(type: ClaimStationType) {
		navigationTitle = type.navigationTitle
		steps = getSteps(for: type)
	}

	func moveNext() {
		isMovingNext = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.selectedIndex += 1
		}
	}

	func movePrevious() {
		isMovingNext = false
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.selectedIndex -= 1
		}
	}
}

private extension ClaimDeviceContainerViewModel {
	func getSteps(for type: ClaimStationType) -> [ClaimDeviceStep] {
		switch type {
			case .m5:
				getM5Steps()
			case .d1:
				getD1Steps()
			case .helium:
				getHeliumSteps()
			case .pulse:
				getPulseSteps()
		}
	}

	func getM5Steps() -> [ClaimDeviceStep] {
		let beginViewModel = ViewModelsFactory.getClaimStationM5BeginViewModel { [weak self] in
			self?.moveNext()
		}

		let snViewModel = ViewModelsFactory.getClaimStationM5SNViewModel { [weak self] serialNumber in
			guard let serialNumber else {
				self?.moveNext()
				return
			}

			self?.moveNext()
		}

		return [.begin(beginViewModel), .serialNumber(snViewModel), .location]
	}

	func getD1Steps() -> [ClaimDeviceStep] {
		let beginViewModel = ViewModelsFactory.getClaimStationBeginViewModel { [weak self] in
			self?.moveNext()
		}

		let snViewModel = ViewModelsFactory.getClaimStationSNViewModel { [weak self] serialNumber in
			guard let serialNumber else {
				self?.moveNext()
				return
			}

			self?.moveNext()
		}

		return [.begin(beginViewModel), .serialNumber(snViewModel), .location]
	}
	
	func getHeliumSteps() -> [ClaimDeviceStep] {
		[]
	}

	func getPulseSteps() -> [ClaimDeviceStep] {
		[]
	}
}

extension ClaimDeviceContainerViewModel: HashableViewModel {
	func hash(into hasher: inout Hasher) {
	}
}
