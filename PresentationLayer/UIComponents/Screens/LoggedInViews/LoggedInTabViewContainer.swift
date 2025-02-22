//
//  LoggedInTabViewContainer.swift
//  PresentationLayer
//
//  Created by Hristos Condrea on 28/5/22.
//

import DomainLayer
import SwiftUI
import Toolkit

struct LoggedInTabViewContainer: View {
	@StateObject var mainViewModel: MainScreenViewModel = .shared
    @State var isTabBarShowing: Bool = true
    @StateObject var explorerViewModel: ExplorerViewModel
	@StateObject var profileViewModel: ProfileViewModel
    @State var tabBarItemsSize: CGSize = .zero

    public init(swinjectHelper: SwinjectInterface) {
        let container = swinjectHelper.getContainerForSwinject()
		_explorerViewModel = StateObject(wrappedValue: ViewModelsFactory.getExplorerViewModel())
		_profileViewModel = StateObject(wrappedValue: ViewModelsFactory.getProfileViewModel())
    }

    var body: some View {
        ZStack {
            selectedTabView
                .animation(.easeIn(duration: 0.3), value: mainViewModel.selectedTab)

            if !explorerViewModel.isSearchActive {
                tabBar
            }
        }
        .fullScreenCover(isPresented: $mainViewModel.showFirmwareUpdate) {
            NavigationContainerView {
                UpdateFirmwareView(viewModel: UpdateFirmwareViewModel(device: mainViewModel.deviceToUpdate ?? DeviceDetails.emptyDeviceDetails) {
                    mainViewModel.showFirmwareUpdate = false
                    if let device = mainViewModel.deviceToUpdate {
                        Router.shared.navigateTo(.stationDetails(ViewModelsFactory.getStationDetailsViewModel(deviceId: device.id ?? "",
                                                                                                              cellIndex: device.cellIndex,
                                                                                                              cellCenter: device.cellCenter?.toCLLocationCoordinate2D())))
                    }
                } cancelCallback: {
                    mainViewModel.showFirmwareUpdate = false
                })
            }
        }
        .fullScreenCover(isPresented: $mainViewModel.showAnalyticsPrompt) {
            AnalyticsView(show: $mainViewModel.showAnalyticsPrompt,
                          viewModel: ViewModelsFactory.getAnalyticsViewModel())
        }
    }

    @ViewBuilder
    private var selectedTabView: some View {
        ZStack {
            switch mainViewModel.selectedTab {
                case .homeTab:
                    WeatherStationsHomeView(swinjectHelper: mainViewModel.swinjectHelper,
                                            isTabBarShowing: $isTabBarShowing,
                                            tabBarItemsSize: $tabBarItemsSize,
											isWalletEmpty: $mainViewModel.isWalletMissing)
                    .onAppear {
                        WXMAnalytics.shared.trackScreen(.deviceList)
                    }
                case .mapTab:
                    explorer
                        .onAppear {
                            WXMAnalytics.shared.trackScreen(.explorer)
                            explorerViewModel.showTopOfMapItems = true
                        }
                case .profileTab:
                    ProfileView(viewModel: profileViewModel,
								isTabBarShowing: $isTabBarShowing,
								tabBarItemsSize: $tabBarItemsSize)
                        .onAppear {
                            WXMAnalytics.shared.trackScreen(.profile)
                        }
            }
        }
    }

    private var tabBar: some View {
        VStack(spacing: CGFloat(.defaultSpacing)) {
            Spacer()
            VStack(spacing: CGFloat(.defaultSpacing)) {
                if mainViewModel.selectedTab == .mapTab {
                    fabButtons
                }

                if mainViewModel.selectedTab == .homeTab {
                    addStationsButton
                }

				TabBarView($mainViewModel.selectedTab, mainViewModel.isWalletMissing)
                    .opacity(isTabBarShowing ? 1 : 0)
            }
            .sizeObserver(size: $tabBarItemsSize)
        }
    }
}

private extension LoggedInTabViewContainer {
    @ViewBuilder
    var explorer: some View {
        ZStack {
            MapBoxMapView()
                .environmentObject(explorerViewModel)
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .zIndex(0)
                .shimmerLoader(show: $explorerViewModel.isLoading)

            if explorerViewModel.showTopOfMapItems {
                SearchView(viewModel: explorerViewModel.searchViewModel)
                    .transition(.move(edge: .top).animation(.easeIn(duration: 0.5)))
                    .zIndex(1)
            }
        }
        .animation(.easeIn(duration: 0.4), value: explorerViewModel.showTopOfMapItems)
    }

    @ViewBuilder
    var fabButtons: some View {
        VStack(spacing: CGFloat(.defaultSidePadding)) {
            if explorerViewModel.showTopOfMapItems {
                Spacer()

                VStack(spacing: CGFloat(.defaultSpacing)) {
                    HStack {
                        Spacer()
                        userLocationButton
                    }

                    HStack {
                        Spacer()
                        netStatsButton
                    }
                }
                .transition(AnyTransition.move(edge: .trailing))
                .animation(.easeIn)
            }
        }
        .padding(CGFloat(.defaultSidePadding))
    }

    @ViewBuilder
    var netStatsButton: some View {
        Button {
            Router.shared.navigateTo(.netStats(ViewModelsFactory.getNetworkStatsViewModel()))
        } label: {
            Image(asset: .networkStatsIcon)
                .renderingMode(.template)
                .foregroundColor(Color(colorEnum: .netStatsFabTextColor))
        }
        .frame(width: CGFloat(.fabButtonsDimension), height: CGFloat(.fabButtonsDimension))
        .background(Color(colorEnum: .netStatsFabColor))
        .cornerRadius(CGFloat(.cardCornerRadius))
        .wxmShadow()
    }

    @ViewBuilder
    var userLocationButton: some View {
        Button {
            explorerViewModel.userLocationButtonTapped()
        } label: {
            Image(asset: .detectLocation)
                .renderingMode(.template)
                .foregroundColor(Color(colorEnum: .text))
        }
        .frame(width: CGFloat(.fabButtonsDimension), height: CGFloat(.fabButtonsDimension))
        .background(Circle().foregroundColor(Color(colorEnum: .top)))
        .wxmShadow()
    }

    @ViewBuilder
    var addStationsButton: some View {
        HStack {
            Spacer()
            AddButton()
                .opacity(isTabBarShowing ? 1 : 0)
        }
        .padding(CGFloat(.defaultSidePadding))
    }
}
