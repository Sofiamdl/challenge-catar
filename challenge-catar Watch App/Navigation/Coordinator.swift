//
//  Coordinator.swift
//  challenge-catar Watch App
//
//  Created by sml on 25/11/22.
//

import SwiftUI

enum Destination: String {
    case someView
}

class Coordinator: ObservableObject {

    @Published var path: [Destination] = []

    func gotoHomePage() {
        path.removeLast(path.count)
    }

    func goToSomeView() {
        path.append(Destination.someView)
    }
}
