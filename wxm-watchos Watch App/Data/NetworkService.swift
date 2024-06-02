//
//  NetworkService.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 31/5/24.
//

import Foundation

enum ApiError: Error {
    case missingURL
    case badResponse
    case parsingError
    case unauthorized
}

enum ApiEndpoint {
    case login
    case refresh
    case myDevices
    case cells
    case devicesByCell(cellId: String)
    case networkStats
    
    var rawValue: String {
        switch self {
        case .login:
            return "auth/login"
        case .refresh:
            return "auth/refresh"
        case .myDevices:
            return "me/devices"
        case .cells:
            return "cells"
        case .devicesByCell(let cellId):
            return "cells/\(cellId)/devices"
        case .networkStats:
            return "network/stats"
        }
    }
}

actor TokenManager {
    private var token: String?
    private var refreshToken: String?
    private var urlSession: URLSession
    
    init(token: String?, refreshToken: String?, urlSession: URLSession) {
        self.token = token
        self.refreshToken = refreshToken
        self.urlSession = urlSession
    }
    
    func getToken() -> String? {
        return token
    }
    
    func getRefreshToken() -> String? {
        return refreshToken
    }
    
    func refreshToken() async throws {
        guard let refreshUrl = URL(string: "https://api.weatherxm.com/api/v1/auth/refresh") else {
            throw ApiError.missingURL
        }
        
        var refreshRequest = URLRequest(url: refreshUrl)
        refreshRequest.httpMethod = "POST"
        refreshRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add any necessary headers or body for the refresh request
        do {
            refreshRequest.httpBody = try JSONEncoder().encode(RefreshTokenRequest(refreshToken: refreshToken!))
        } catch {
            throw ApiError.parsingError
        }
        
        let (data, response) = try await urlSession.data(for: refreshRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ApiError.badResponse
        }
        
        // Assuming the new token is returned in the response body
        let tokens = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        // Only one task can update the token at a time
        token = tokens.token
        refreshToken = tokens.refreshToken
    }
}

class NetworkService<T> where T: Codable {
    private let urlSession: URLSession
    private let baseURL: String
    private let tokenManager: TokenManager
    private let maxRetries = 5
    
    init() {
        urlSession = URLSession.shared
        baseURL = "https://api.weatherxm.com/api/v1"
        // TODO: Remove
        tokenManager = TokenManager(
            token: "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzcG9rZWQwNy5wYW5zQGljbG91ZC5jb20iLCJzY29wZXMiOlsiQ1VTVE9NRVJfVVNFUiJdLCJ1c2VySWQiOiIyZTM0YzQyMC0xM2Y1LTExZWYtOTkwOC0xYmIwOGEzNzQ2ODEiLCJmaXJzdE5hbWUiOiJGIiwibGFzdE5hbWUiOiJMIiwiZW5hYmxlZCI6dHJ1ZSwiaXNQdWJsaWMiOmZhbHNlLCJ0ZW5hbnRJZCI6IjI1MGZjZTAwLTg1Y2YtMTFlYy05NmUxLWQ3ZDRjZjIwMGNjOSIsImN1c3RvbWVySWQiOiIyZTMxZGRmMC0xM2Y1LTExZWYtOTkwOC0xYmIwOGEzNzQ2ODEiLCJpc3MiOiJ3ZWF0aGVyeG0uY29tIiwiaWF0IjoxNzE3MjM1OTAxLCJleHAiOjE3MTcyNDQ5MDF9.CoPzKlMXH1EFg4sJeqOVMfDYhr9CEoLxhzcDQreNbuEtykKjJ1WzseI2oTxJwrsQHYAnRuN8bSK2p9gpwE-mUA",
            refreshToken: "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzcG9rZWQwNy5wYW5zQGljbG91ZC5jb20iLCJzY29wZXMiOlsiUkVGUkVTSF9UT0tFTiJdLCJ1c2VySWQiOiIyZTM0YzQyMC0xM2Y1LTExZWYtOTkwOC0xYmIwOGEzNzQ2ODEiLCJpc1B1YmxpYyI6ZmFsc2UsImlzcyI6IndlYXRoZXJ4bS5jb20iLCJqdGkiOiI2N2ZiMzVhYy1jMjlmLTQ2ODQtOWY4OC0zNjk0NjZjNGIxYjgiLCJpYXQiOjE3MTcyMzU5MDEsImV4cCI6MTcxOTg2MzkwMX0.ZgdC60s344RsTa5AxYRJQcpfGV1vRhnr20o_UwEyQvjkuo46N5bdh2GgYYGwi8fAvWHp7Trm_YKiLyHkZfxXWw",
            urlSession: urlSession)
    }
    
    func get(endpoint: ApiEndpoint, attempt: Int = 0) async throws -> T {
        guard let url = URL(string: [baseURL, endpoint.rawValue].joined(separator: "/")) else { throw ApiError.missingURL }
        guard attempt < maxRetries else { throw ApiError.unauthorized }
        var urlRequest = URLRequest(url: url)
        if let token = await tokenManager.getToken() {
            print("Token: \(token.suffix(5))")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let data: Data
        let response: URLResponse
        print(urlRequest)
        (data, response) = try await urlSession.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            guard (response as? HTTPURLResponse)?.statusCode == 401 else {
                throw ApiError.badResponse
            }
            try await tokenManager.refreshToken()
            return try await get(endpoint: endpoint, attempt: attempt + 1)
        }
        do{
            let _ = try JSONDecoder().decode(T.self, from: data)
        }catch{
            print(error)
        }
        guard let element = try? JSONDecoder().decode(T.self, from: data) else { throw ApiError.parsingError }
        return element
    }
    
    func post<U: Codable>(endpoint: ApiEndpoint, body: U, attempt: Int = 0) async throws -> T {
        guard let url = URL(string: [baseURL, endpoint.rawValue].joined(separator: "/")) else { throw ApiError.missingURL }
        guard attempt < maxRetries else { throw ApiError.unauthorized }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = await tokenManager.getToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw ApiError.parsingError
        }
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            guard (response as? HTTPURLResponse)?.statusCode == 401 else {
                throw ApiError.badResponse
            }
            try await tokenManager.refreshToken()
            return try await get(endpoint: endpoint, attempt: attempt + 1)
        }
        guard let element = try? JSONDecoder().decode(T.self, from: data) else {
            throw ApiError.parsingError
        }
        return element
    }
}
