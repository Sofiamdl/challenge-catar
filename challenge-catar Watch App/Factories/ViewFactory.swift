//
//  ViewFactory.swift
//  challenge-catar Watch App
//
//  Created by sml on 25/11/22.
//

import SwiftUI

class ViewFactory {
    @ViewBuilder
    static func viewForDestination(_ destination: Destination) -> some View {
        switch destination {
        case .someView:
            SomeView()
        }
    }
}
