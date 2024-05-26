//
//  View+.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 1/6/24.
//

import Foundation
import SwiftUI

private struct BackgroundModifier<V: View>: ViewModifier {
    let background: () -> V

    func body(content: Content) -> some View {
        ZStack {
            background().ignoresSafeArea()
            content
        }
    }
}

extension View {
    @ViewBuilder
    func background<Content: View>(_ content: @escaping () -> Content) -> some View {
        modifier(BackgroundModifier(background: content))
    }
}
