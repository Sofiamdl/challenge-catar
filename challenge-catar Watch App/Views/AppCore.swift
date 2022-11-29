//
//  ContentView.swift
//  challenge-catar Watch App
//
//  Created by sml on 25/11/22.
//

import SwiftUI
import Charts

struct Data: Identifiable {
    var id: String
    var time: Int
    var value:Int
}

struct AppCore: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        NavigationStack {
            SelectScreen()
                .navigationDestination(for: RouteScreen.self){ route in
                    switch route {
                    case .runningScreen:
                        SomeView()
                    case .sleepScreen:
                        SomeView()
                    case .reportScreen:
                        SomeView()
                    }
                }
        }
    }
}

struct AppCore_Previews: PreviewProvider {
    static var previews: some View {
        AppCore()
    }
}

