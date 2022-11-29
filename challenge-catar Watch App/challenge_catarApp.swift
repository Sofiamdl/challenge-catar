//
//  challenge_catarApp.swift
//  challenge-catar Watch App
//
//  Created by sml on 25/11/22.
//

import SwiftUI

@main
struct challenge_catar_Watch_AppApp: App {
    @ObservedObject var coordinator = Coordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                AppCore()
                .navigationDestination(for: Destination.self) { destination in
                    ViewFactory.viewForDestination(destination)
                }
            }
            .environmentObject(coordinator)
        }
    }
}
