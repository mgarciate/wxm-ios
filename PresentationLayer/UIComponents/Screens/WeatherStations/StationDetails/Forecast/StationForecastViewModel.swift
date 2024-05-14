//
//  StationForecastViewModel.swift
//  wxm-ios
//
//  Created by Pantelis Giazitsis on 16/3/23.
//

import Foundation
import Toolkit
import DomainLayer
import Combine

class StationForecastViewModel: ObservableObject {
    weak var containerDelegate: StationDetailsViewModelDelegate?
    let offsetObject: TrackableScrollOffsetObject = TrackableScrollOffsetObject()
	@Published private(set) var forecasts: [NetworkDeviceForecastResponse] = [] {
		didSet {
			updateHourlyItems()
		}
	}
    @Published private(set) var viewState: ViewState = .loading
	@Published private(set) var hourlyItems: [StationForecastMiniCardView.Item] = []

    var overallMinTemperature: Double? {
        forecasts.min { ($0.daily?.temperatureMin ?? 0.0) < ($1.daily?.temperatureMin ?? 0.0) }?.daily?.temperatureMin
    }
    var overallMaxTemperature: Double? {
        forecasts.max { ($0.daily?.temperatureMax ?? 0.0) < ($1.daily?.temperatureMax ?? 0.0) }?.daily?.temperatureMax
    }
    private(set) var failObj: FailSuccessStateObject?
    private(set) var hiddenViewConfiguration: WXMEmptyView.Configuration?

    private var device: DeviceDetails?
	private var followState: UserDeviceFollowState?
    private var cancellables: Set<AnyCancellable> = []
    private let useCase: MeUseCase?

    init(containerDelegate: StationDetailsViewModelDelegate? = nil, useCase: MeUseCase?) {
        self.containerDelegate = containerDelegate
        self.useCase = useCase
        observeOffset()
    }

    func refresh(completion: @escaping VoidCallback) {

        Task { @MainActor in
            await containerDelegate?.shouldRefresh()
            completion()
        }
    }

    func hadndleRetryButtonTap() {
        viewState = .loading
        refresh {}
    }

	func handleForecastTap(forecast: NetworkDeviceForecastResponse) {
		guard let device, let index = forecasts.firstIndex(where: { $0.date == forecast.date }) else {
			return
		}

		let conf = ForecastDetailsViewModel.Configuration(forecasts: forecasts,
														  selectedforecastIndex: index,
														  selectedHour: nil,
														  device: device,
														  followState: followState)
		let viewModel = ViewModelsFactory.getForecastDetailsViewModel(configuration: conf)
		Router.shared.navigateTo(.forecastDetails(viewModel))

		WXMAnalytics.shared.trackEvent(.selectContent, parameters: [.contentType: .dailyCard,
															  .itemId: .dailyForecast])
	}

    private func getDeviceForecastDaily(deviceId: String?) async -> Result<[NetworkDeviceForecastResponse], NetworkErrorResponse>? {
        guard let deviceId = deviceId else {
            return nil
        }
        
        do {
            let getUserDeviceForecastById = try useCase?.getUserDeviceForecastById(deviceId: deviceId,
                                                                                   fromDate: getCurrentDateInStringForForecast(),
                                                                                   toDate: getΤοDateForWeeklyForecastCall())
            return await withCheckedContinuation { continuation in

                getUserDeviceForecastById?.sink { response in
                        continuation.resume(returning: response.result)
                    }.store(in: &cancellables)
            }
        } catch { return nil }
    }
}

private extension StationForecastViewModel {
    func observeOffset() {
        offsetObject.$diffOffset.sink { [weak self] value in
            guard let self = self else {
                return
            }
            self.containerDelegate?.offsetUpdated(diffOffset: value)
        }
        .store(in: &cancellables)
    }

    func generateHiddenViewConfiguration() -> WXMEmptyView.Configuration {
        let description: String = LocalizableString.hiddenContentDescription( device?.name ?? "").localized
        let buttonIcon: FontIcon = .heart
        let buttonTitle: LocalizableString = .favorite
        let buttonAction: VoidCallback = { [weak self] in self?.containerDelegate?.shouldAskToFollow() }

        return WXMEmptyView.Configuration(image: (.lockedIcon, .darkestBlue),
                                          title: LocalizableString.hiddenContentTitle.localized,
                                          description: description.attributedMarkdown ?? "",
                                          buttonFontIcon: buttonIcon,
                                          buttonTitle: buttonTitle.localized,
                                          action: buttonAction)
    }

    func handleResponseResult(_ result: Result<[NetworkDeviceForecastResponse], NetworkErrorResponse>) {
        switch result {
            case .success(let forecasts):
                self.forecasts = forecasts
                self.viewState = .content
            case .failure(let error):
                let obj = error.uiInfo.defaultFailObject(type: .stationForecast) {
                    self.hadndleRetryButtonTap()
                }

                self.failObj = obj
                self.viewState = .fail
        }
    }

    func getΤοDateForWeeklyForecastCall() -> String {
        Date.now.getFormattedDateOffsetByDays(7)
    }

    func getCurrentDateInStringForForecast() -> String {
        Date.now.getFormattedDate(format: .onlyDate)
    }

	func updateHourlyItems() {
		guard let timezone = forecasts.first?.tz.toTimezone else {
			hourlyItems = []
			return
		}

		let hourly = forecasts.map { $0.hourly }.compactMap { $0 }.flatMap { $0 }
		let startDate = Date.now.advancedByHours(hours: -1)
		let endDate = Date.now.advancedByHours(hours: 24)
		let filtered = hourly.filter { ($0.timestamp?.timestampToDate(timeZone: timezone) ?? .distantPast) >= startDate  &&  ($0.timestamp?.timestampToDate(timeZone: timezone) ?? .distantPast) < endDate }

		hourlyItems = filtered.map { weather in
			return weather.toMiniCardItem(with: timezone, action: { [weak  self] in
				self?.handleTap(for: weather)

				WXMAnalytics.shared.trackEvent(.selectContent, parameters: [.contentType: .hourlyDetailsCard,
																	  .itemId: .hourlyForecast])
			})
		}
	}

	func handleTap(for weather: CurrentWeather) {
		guard let device, let timezone = forecasts.first?.tz.toTimezone else {
			return
		}

		let selectedHour = weather.timestamp?.timestampToDate().getHour(with: timezone)
		let conf = ForecastDetailsViewModel.Configuration(forecasts: forecasts,
														  selectedforecastIndex: 0,
														  selectedHour: selectedHour,
														  device: device,
														  followState: followState)
		let viewModel = ViewModelsFactory.getForecastDetailsViewModel(configuration: conf)
		Router.shared.navigateTo(.forecastDetails(viewModel))
	}
}

// MARK: - StationDetailsViewModelChild

extension StationForecastViewModel: StationDetailsViewModelChild {
    func refreshWithDevice(_ device: DeviceDetails?, followState: UserDeviceFollowState?, error: NetworkErrorResponse?) async {
        self.device = device
		self.followState = followState

        if followState == nil {
            DispatchQueue.main.async {
                self.hiddenViewConfiguration = self.generateHiddenViewConfiguration()
                self.viewState = .hidden
            }
            return
        }

        guard let res = await getDeviceForecastDaily(deviceId: device?.id) else {
            return
        }
        DispatchQueue.main.async {
            self.handleResponseResult(res)
        }
    }

    func showLoading() {
        viewState = .loading
    }
}

// MARK: - Mock

extension StationForecastViewModel {

    static var mockInstance: StationForecastViewModel {
        StationForecastViewModel(useCase: SwinjectHelper.shared.getContainerForSwinject().resolve(MeUseCase.self))
    }
}
