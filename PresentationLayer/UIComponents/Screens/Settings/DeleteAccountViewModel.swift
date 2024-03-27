//
//  DeleteAccountViewModel.swift
//  PresentationLayer
//
//  Created by Panagiotis Palamidas on 21/10/22.
//

import Combine
import DomainLayer
import Foundation
import UIKit
import Toolkit

final class DeleteAccountViewModel: ObservableObject {
    @Published var password = ""
    @Published var passwordHasError = false
    @Published var isToggleOn = false
	@Published var currentScreen: DeleteScreen = .info
    @Published var isValidatingPassword: Bool = false
    @Published var deleteFailureErrorMessage: String = ""
    let userID: String
    private var tokenResponse = NetworkTokenResponse()
    private var cancellableSet: Set<AnyCancellable> = []

    private let authUseCase: AuthUseCase
    private let meUseCase: MeUseCase
    private let keychainUseCase: KeychainUseCase
	private let settingsUseCase: SettingsUseCase

	init(userId: String, authUseCase: AuthUseCase, meUseCase: MeUseCase, keychainUseCase: KeychainUseCase, settingsUseCase: SettingsUseCase) {
        self.userID = userId
        self.authUseCase = authUseCase
        self.meUseCase = meUseCase
        self.keychainUseCase = keychainUseCase
		self.settingsUseCase = settingsUseCase
    }

    func tryLoginAndDeleteAccount() {
        isValidatingPassword = true
        let usersEmail = keychainUseCase.getUsersEmail()
        do {
            try authUseCase.login(username: usersEmail, password: password)
                .sink { response in
                    if response.error != nil {
                        self.isValidatingPassword = false
                        self.passwordHasError = true
                    } else {
                        self.isValidatingPassword = false
                        self.passwordHasError = false
                        self.tryDeleteAccount()
                    }
                }.store(in: &cancellableSet)
        } catch {}
    }

    func tryDeleteAccount() {
        LoaderView.shared.show()
        do {
            try meUseCase.deleteAccount()
                .sink { [weak self] response in
					guard let self else {
						return
					}
                    LoaderView.shared.dismiss()
                    if response.response?.statusCode != 204 {
                        if response.error != nil {
                            self.getErrorMessage(responseError: response.error)
                            self.currentScreen = DeleteScreen.failure
                            Logger.shared.trackEvent(.viewContent, parameters: [.contentName: .failure,
                                                                                .itemId: .custom(response.error?.backendError?.code ?? "")])
                        }
                    } else {
						Router.shared.navigateTo(.deleteAccountSuccess(self))
						_ = try? self.settingsUseCase.logout(localOnly: true)
                    }
                }.store(in: &cancellableSet)
        } catch {}
    }

    private func getErrorMessage(responseError: NetworkErrorResponse?) {
        if let error = (responseError?.initialError.underlyingError as? URLError) {
            switch error.code {
                case .notConnectedToInternet:
                    deleteFailureErrorMessage = "NO_CONNECTION"
                case .timedOut:
                    deleteFailureErrorMessage = "CONNECTION_TIMEOUT"
                case .unknown:
                    deleteFailureErrorMessage = "UNKNOWN"
                case .cannotParseResponse:
                    deleteFailureErrorMessage = "PARSE_JSON"
                default:
                    deleteFailureErrorMessage = "UNIDENTIFIED"
            }
        }
    }

    public func contactSupport() {
		HelperFunctions().openContactSupport(successFailureEnum: .deleteAccount, email: MainScreenViewModel.shared.userInfo?.email)
    }

    func getClientIndentifier() -> String {
        let bundleID = Bundle.main.buildIDPretty
        let bundleVersion = Bundle.main.buildVersionNumberPretty
        let appInformation = "wxm-ios:\(bundleID)-\(bundleVersion)"

        let systemVersion = UIDevice.current.systemVersion
        let releaseVersion = Bundle.main.releaseVersionNumberPretty
        let systemInfo = "iOS:\(systemVersion)-\(releaseVersion)"

        let manufacturer = "Apple"
        let deviceModel = UIDevice.modelName
        let deviceInfo = "\(manufacturer)-\(deviceModel)"

        let clientIdentifier = "\(appInformation);\(systemInfo);\(deviceInfo)"
        return clientIdentifier
    }
}

extension DeleteAccountViewModel {
    enum DeleteScreen {
        case info
        case failure
    }
}

extension DeleteAccountViewModel: HashableViewModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
}
