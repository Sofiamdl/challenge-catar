//
//  ReportsScreen.swift
//  challenge-catar Watch App
//
//  Created by sml on 29/11/22.
//

import SwiftUI

struct ReportsScreen: View {
    var body: some View {
        ScrollView {
            VStack{
                Avarage(distancePerHour: "50k", sleepingHours: "4h")
                IdealSleepGraph(idealSleepInMinute: 5, averageMinutesSlept: 4)
            }
            .navigationBarTitle("Relatório Semanal")
            .padding()
            
        }
        

    }
}
