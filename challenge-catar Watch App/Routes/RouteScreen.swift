//
//  Route.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 28/11/22.
//

import Foundation

enum RouteScreen: Hashable {
    case reportScreen
    case runningScreen
    case sleepScreen
    
    var imageName: String {
        switch self {
        case .reportScreen:
            return "circle.circle"
        case .runningScreen:
            return "figure.run"
        case .sleepScreen:
            return "bed.double.fill"
        }
    }
}
