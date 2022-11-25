//
//  SomeView.swift
//  challenge-catar Watch App
//
//  Created by sml on 25/11/22.
//

import SwiftUI

struct SomeView: View {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        HStack{
            Button("Oi") {
                coordinator.goBack()
            }
        }
    }
}
