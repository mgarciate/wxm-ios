//
//  ExplorerSearchViewModel.swift
//  wxm-ios
//
//  Created by Pantelis Giazitsis on 21/6/23.
//

import Combine
import DomainLayer
import CoreLocation
import Toolkit
import SwiftUI

protocol ExplorerSearchViewModelDelegate: AnyObject {
    func rowTapped(coordinates: CLLocationCoordinate2D, deviceId: String?, cellIndex: String?)
    func searchWillBecomeActive(_ active: Bool)
    func settingsButtonTapped()
}

class ExplorerSearchViewModel: ObservableObject {

    @Published var isSearchActive: Bool = false {
        didSet {
            delegate?.searchWillBecomeActive(isSearchActive)
        }
    }
    @Published var isLoading = false
    @Published var showNoResults: Bool = false
    @Published var searchResults: [SearchView.Row] = []
    @Published var isShowingRecent: Bool = true
    /// Will be assigned from the view. We do not assign directly this proprety as a binding in theTextfield
    @Published private var searchTerm: String = "" {
        didSet {
            handleSearchTermChanges()
        }
    }

    weak var delegate: ExplorerSearchViewModelDelegate?
    private let useCase: NetworkUseCase?
    private var searchCancellable: AnyCancellable?
    private let searchTermLimit = 2
    private var cancellables = Set<AnyCancellable>()

    init(useCase: NetworkUseCase? = nil) {
        self.useCase = useCase

        $searchTerm
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.performSearch(searchTerm: newValue)
            }
            .store(in: &cancellables)
    }

    func handleTapOnResult(_ result: SearchView.Row) {
        guard let lat = result.networkModel?.lat, let lon = result.networkModel?.lon else {
            return
        }

        isSearchActive = false
        delegate?.rowTapped(coordinates: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                            deviceId: result.networkModel?.deviceId,
                            cellIndex: result.networkModel?.cellIndex)

        if let model = result.networkModel {
            saveRecent(model: model)
        }

        searchTerm.removeAll()

        let isStation = result.networkModel?.deviceId != nil
        Logger.shared.trackEvent(.selectContent, parameters: [.contentType: .networkSearch,
                                                              .itemId: isShowingRecent ? .recent : .search,
                                                              .itemListId: isStation ? .station : .location])
    }

    func handleSettingsButtonTap() {
        Logger.shared.trackEvent(.selectContent, parameters: [.actionName: .explorerSettings])
        delegate?.settingsButtonTapped()
    }

    func handleSubmitButtonTap() {
        guard searchTerm.count < searchTermLimit else {
            return
        }
        
        let toastText = LocalizableString.Search.termLimitMessage(searchTermLimit).localized.attributedMarkdown
        Toast.shared.show(text: toastText ?? "", type: .info)
    }

    func updateSearchTerm(_ term: String) {
        let trimmed = term.trimWhiteSpaces()
        guard searchTerm != trimmed else {
            return
        }
        searchTerm = trimmed
    }
}

private extension ExplorerSearchViewModel {

    /// Handles search term changes.
    /// 1. Cancels the pending requst
    /// 2. If search term lenght is less than `searchTermLimit` we do nothing
    /// 3. If search term is empty we show recent results
    /// 4. Otherwise we schedule a new search request (ln 46)
    func handleSearchTermChanges() {
        searchCancellable?.cancel()
        isLoading = false

        guard searchTerm.count >= searchTermLimit else {
            if searchTerm.isEmpty {

                loadRecent()
                isShowingRecent = true
            }
            return
        }

        isLoading = true
    }

    func performSearch(searchTerm: String) {
        searchCancellable?.cancel()
        isLoading = false

        guard searchTerm.count >= searchTermLimit else {
            if searchTerm.isEmpty {
                loadRecent()
                isShowingRecent = true
            }
            return
        }

        isLoading = true

        do {
            searchCancellable = try useCase?.search(term: searchTerm).sink { [weak self] response in
                self?.isLoading = false
                if let error = response.error {
                    let info = error.uiInfo
                    if let message = info.description?.attributedMarkdown {
                        Toast.shared.show(text: message)
                    }
                }

                self?.updateSearchResults(response: response.value)
                self?.isShowingRecent = false
            }
        } catch {

        }
    }

    func updateSearchResults(response: NetworkSearchResponse?) {
        let devices: [any NetworkSearchItem] = response?.devices ?? []
        let addresses: [any NetworkSearchItem] = response?.addresses ?? []
        let items: [any NetworkSearchItem] = [devices, addresses].flatMap { $0 }

        updateSearchResults(data: items)
    }

    func updateSearchResults(data: [any NetworkSearchItem]) {
        self.searchResults = data.compactMap { item in
            if let device = item as? NetworkSearchDevice {
                guard let icon = device.connectivity?.icon,
                      let name = device.name?.withHighlightedPart(text: searchTerm, color: Color(colorEnum: .text)) else {
                    return nil
                }

                return SearchView.Row(icon: icon,
                                      title: name,
                                      subtitle: nil,
                                      networkModel: device)

            }

            if let address = item as? NetworkSearchAddress {
                guard let name = address.name?.withHighlightedPart(text: searchTerm, color: Color(colorEnum: .text)),
                let place = address.place else {
                    return nil
                }

                return SearchView.Row(fontIcon: .locationDot,
                                      title: name,
                                      subtitle: place,
                                      networkModel: address)
            }

            return nil
        }
        self.showNoResults = searchResults.isEmpty
    }

    func loadRecent() {
        let recent = useCase?.getSearchRecent()
        updateSearchResults(data: recent ?? [])
    }

    func saveRecent(model: NetworkSearchModel) {
        if let device = model as? NetworkSearchDevice {
            useCase?.insertSearchRecentDevice(device: device)
            return
        }

        if let address = model as? NetworkSearchAddress {
            useCase?.insertSearchRecentAddress(address: address)
            return
        }
    }
}

extension ExplorerSearchViewModel {
    static var mock: ExplorerSearchViewModel {
        let viewModel = ExplorerSearchViewModel()
        viewModel.searchTerm = "Search text"
        viewModel.isSearchActive = true
        viewModel.searchResults = [.init(icon: .wifi,
                                         title: "list item",
                                         subtitle: nil,
                                         networkModel: nil),
                                   .init(icon: .helium,
                                         title: "List item 1",
                                         subtitle: "subtitle",
                                         networkModel: nil),
                                   .init(fontIcon: .locationDot,
                                         title: "List item 2",
                                         subtitle: "subtitle",
                                         networkModel: nil)]
        return viewModel
    }
}
