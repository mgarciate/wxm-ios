//
//  StationDetailsContainerView.swift
//  wxm-watchos Watch App
//
//  Created by mgarciate on 19/5/24.
//

import SwiftUI

struct StationDetailsContainerView: View {
    var index: Int
    
    var body: some View {
        Text("\(index) - Hello, World!")
            .navigationTitle("Station \(index)")
    }
}

#Preview {
    StationDetailsContainerView(index: 1)
}
