//
//  DeepLinkHandler.swift
//  wxm-ios
//
//  Created by Pantelis Giazitsis on 24/7/23.
//

import Foundation
import DomainLayer
import Combine
import UIKit
import Toolkit

class DeepLinkHandler {
	typealias QueryParamsCallBack = GenericCallback<[String: String]?>
	static let httpsScheme = "https"
	static let explorerHost = "explorer.weatherxm.com"
	static let explorerDevHost = "explorer-dev.weatherxm.com"
	static let stationsPath = "stations"
	static let cellsPath = "cells"
	static let tokenClaim = "token-claim"

    let useCase: NetworkUseCase
    private var searchCancellable: AnyCancellable?

    init(useCase: NetworkUseCase) {
        self.useCase = useCase
    }

	@discardableResult
	/// Handles the passed url
	/// - Parameter url: The url to handle/navigete
	/// - Parameter queryParamsCallback: A callback to pass the url query params if handled successfully
	/// - Returns: True if is handled successfully
	func handleUrl(_ url: URL, queryParamsCallback: QueryParamsCallBack? = nil) -> Bool {
        print(url)

		var handled = false
		defer {
			if handled {
				queryParamsCallback?(url.queryItems)
			}
		}

		switch url.scheme {
			case Self.httpsScheme:
				handled = handleUniversalLink(url: url)
			case Bundle.main.urlScheme:
				handled = handleUrlScheme(url: url)
			case widgetScheme:
				handled = handleWidgetUrlScheme(url: url)
			default:
				let canOpen = UIApplication.shared.canOpenURL(url)
				if canOpen {
					UIApplication.shared.open(url)
				}

				handled = canOpen
		}

		return handled
    }

    deinit {
        print("deInit \(Self.self)")
    }
}

private extension DeepLinkHandler {
	/// Handles the url scheme (not http)
	/// - Parameter url: The url to handle/navigete
	/// - Returns: True if is handled successfully
    func handleUrlScheme(url: URL) -> Bool {
        guard let path = url.host else {
			Router.shared.pop()
            return true
        }

        let value = url.lastPathComponent

        return handleNavigation(path: path, value: value)
    }

	/// Handles the widget url
	/// - Parameter url: The url to handle/navigete
	/// - Returns: True if is handled successfully
	func handleWidgetUrlScheme(url: URL) -> Bool {
		guard let host = url.host,
			  let widgetCase = WidgetUrlType(rawValue: host) else {
			return false
		}

		let pathComps = url.pathComponents
		switch widgetCase {
			case .station:
				if let deviceId = pathComps[safe: 1] {
					let route = Route.stationDetails(ViewModelsFactory.getStationDetailsViewModel(deviceId: deviceId,
																								  cellIndex: nil,
																								  cellCenter: nil))
					Router.shared.navigateTo(route)
					return true
				}

				return false
			case .loggedOut:
				let route = Route.signIn(ViewModelsFactory.getSignInViewModel())
				Router.shared.navigateTo(route)
				return true
			case .empty:
				return false
			case .error:
				return false
			case .selectStation:
				return false
		}
	}

	/// Handles the http url
	/// - Parameter url: The url to handle/navigete
	/// - Returns: True if is handled successfully
    func handleUniversalLink(url: URL) -> Bool {
        guard let host = url.host,
			  host == Self.explorerHost || host == Self.explorerDevHost,
              case let pathComps = url.pathComponents,
              pathComps.count == 3 else {
            return false
        }

        let path = pathComps[1]
        let value = pathComps[2]
        return handleNavigation(path: path, value: value)
    }

	/// Handles path to navigate
	/// - Parameter path: The path to navigate
	/// - Parameter value: The value to pass to the navigation path
	/// - Parameter additionalInfo: Extra params to be handled
	/// - Returns: True if is handled successfully
	func handleNavigation(path: String, value: String) -> Bool {
		switch path {
			case Self.stationsPath:
				moveToStation(name: value)
				return true
			case Self.cellsPath:
				// To be handled in the future
				return false
			case Self.tokenClaim:
				Router.shared.pop()
				return true
			default:
				return false
		}
    }

    func moveToStation(name: String) {
        let normalizedName = name.replacingOccurrences(of: "-", with: " ")
        guard normalizedName.count > 1 else { // To perform search the term's length should be greater than 1
            if let message = LocalizableString.Error.deepLinkInvalidUrl.localized.attributedMarkdown {
                Toast.shared.show(text: message)
            }
            return
        }

        do {
            searchCancellable = try useCase.search(term: normalizedName, exact: true, exclude: .places).sink { response in
                if let error = response.error {
                    let info = error.uiInfo
                    if let message = info.description?.attributedMarkdown {
                        Toast.shared.show(text: message)
                    }

                    return
                }

                if let device = response.value?.devices?.first,
                   let deviceId = device.id,
                   let cellIndex = device.cellIndex {
                    let cellCenter = device.cellCenter?.toCLLocationCoordinate2D()
                    let route = Route.stationDetails(ViewModelsFactory.getStationDetailsViewModel(deviceId: deviceId,
                                                                                                  cellIndex: cellIndex,
                                                                                                  cellCenter: cellCenter))
                    Router.shared.navigateTo(route)
                }
            }
        } catch {

        }
    }
}
