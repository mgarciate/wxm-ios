//
//  LogInView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 19/5/24.
//

import SwiftUI

struct LogInView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack {
                TextField("User Name", text: $userName)
                    .textContentType(.username)
                    .multilineTextAlignment(.center)
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .multilineTextAlignment(.center)
                Button("Sign in") {
                }.disabled(userName.isEmpty || password.isEmpty)
            }
    }
}

#Preview {
    LogInView()
}
