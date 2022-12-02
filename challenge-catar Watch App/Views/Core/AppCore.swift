//
//  ContentView.swift
//  challenge-catar Watch App
//
//  Created by sml on 25/11/22.
//

import SwiftUI
import Charts

struct AppCore: View {
            
    var body: some View {
        NavigationStack {
            selectScreen
        }
    }
    
    private var selectScreen: some View {
        SelectScreen()
            .navigationDestination(for: RouteScreen.self){ route in
                switch route {
                case .runningScreen:
                    RunningScreen()
                case .sleepScreen:
                    SleepScreen()
                case .reportScreen:
                    ReportsScreen()
                }
            }
    }
}

struct AppCore_Previews: PreviewProvider {
    static var previews: some View {
        AppCore()
    }
}

