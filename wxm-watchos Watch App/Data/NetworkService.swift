//
//  NetworkService.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 31/5/24.
//

import Foundation

enum ApiEndpoint: String {
    case login = "auth/login"
    case myDevices = "me/devices"
}

class NetworkService<T> where T: Codable {
    enum ApiError: Error {
        case missingURL
        case badResponse
        case parsingError
    }
    private let urlSession: URLSession
    private let baseURL: String
    // TODO: Remove
    private let token: String? = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzcG9rZWQwNy5wYW5zQGljbG91ZC5jb20iLCJzY29wZXMiOlsiQ1VTVE9NRVJfVVNFUiJdLCJ1c2VySWQiOiIyZTM0YzQyMC0xM2Y1LTExZWYtOTkwOC0xYmIwOGEzNzQ2ODEiLCJmaXJzdE5hbWUiOiJGIiwibGFzdE5hbWUiOiJMIiwiZW5hYmxlZCI6dHJ1ZSwiaXNQdWJsaWMiOmZhbHNlLCJ0ZW5hbnRJZCI6IjI1MGZjZTAwLTg1Y2YtMTFlYy05NmUxLWQ3ZDRjZjIwMGNjOSIsImN1c3RvbWVySWQiOiIyZTMxZGRmMC0xM2Y1LTExZWYtOTkwOC0xYmIwOGEzNzQ2ODEiLCJpc3MiOiJ3ZWF0aGVyeG0uY29tIiwiaWF0IjoxNzE3MjAyNDI4LCJleHAiOjE3MTcyMTE0Mjh9.S09V6wCgx7-alXnkI8u-JNDC2OrEV1DTjI0pvc8_OKPpJcwpADsEOHHSHmpomNzdZYnqmhdCBiiofinXV_KXFQ"
    
    init() {
        urlSession = URLSession.shared
        baseURL = "https://api.weatherxm.com/api/v1"
    }
    
    func get(endpoint: ApiEndpoint) async throws -> T {
        guard let url = URL(string: [baseURL, endpoint.rawValue].joined(separator: "/")) else { throw ApiError.missingURL }
        var urlRequest = URLRequest(url: url)
        if let token = token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let data: Data
        let response: URLResponse
        print(urlRequest)
        (data, response) = try await urlSession.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ApiError.badResponse }
        do{
            let _ = try JSONDecoder().decode(T.self, from: data)
        }catch{
            print(error)
        }
        guard let element = try? JSONDecoder().decode(T.self, from: data) else { throw ApiError.parsingError }
        return element
    }
    
    func post<U: Codable>(endpoint: ApiEndpoint, body: U) async throws -> T {
        guard let url = URL(string: [baseURL, endpoint.rawValue].joined(separator: "/")) else {
            throw ApiError.missingURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw ApiError.parsingError
        }
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ApiError.badResponse
        }
        guard let element = try? JSONDecoder().decode(T.self, from: data) else {
            throw ApiError.parsingError
        }
        return element
    }
}
