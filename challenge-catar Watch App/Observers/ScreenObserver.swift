//
//  ScreenObserver.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 29/11/22.
//

import SwiftUI


class ScreenObserver: ObservableObject {

    @Published var screens: [ScreenAvaiable] = [
        ScreenAvaiable(id: 0, name: "Relatório Semanal", height: 96),
        ScreenAvaiable(id: 1, name: "Acompanhe Corrida", height: 96),
        ScreenAvaiable(id: 2, name: "Acompanhe Sono", height: 96)
    ]
}
