//
//  AuthUseCase.swift
//  DomainLayer
//
//  Created by Hristos Condrea on 17/5/22.
//

import Alamofire
import Combine
import Foundation

public struct AuthUseCase {
    private let authRepository: AuthRepository

    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    public func login(username: String, password: String) throws -> AnyPublisher<DataResponse<NetworkTokenResponse, NetworkErrorResponse>, Never> {
        let login = try authRepository.login(username: username, password: password)
        return login
    }

    public func register(email: String, firstName: String, lastName: String) throws -> AnyPublisher<DataResponse<EmptyEntity, NetworkErrorResponse>, Never> {
        let register = try authRepository.register(email: email, firstName: firstName, lastName: lastName)
        return register
    }

    public func logout() throws -> AnyPublisher<DataResponse<EmptyEntity, NetworkErrorResponse>, Never> {
        let logout = try authRepository.logout()
        return logout
    }

    public func refresh(refreshToken: String) throws -> AnyPublisher<DataResponse<NetworkTokenResponse, NetworkErrorResponse>, Never> {
        let refresh = try authRepository.refresh(refreshToken: refreshToken)
        return refresh
    }

    public func resetPassword(email: String) throws -> AnyPublisher<DataResponse<EmptyEntity, NetworkErrorResponse>, Never> {
        let resetPassword = try authRepository.resetPassword(email: email)
        return resetPassword
    }

    public func passwordValidation(password: String)throws -> AnyPublisher<DataResponse<NetworkTokenResponse, NetworkErrorResponse>, Never> {
        return try authRepository.passwordValidation(password: password) 
    }
}
