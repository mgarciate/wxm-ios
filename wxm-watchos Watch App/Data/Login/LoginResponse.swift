//
//  LoginResponse.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 31/5/24.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let refreshToken: String
}
