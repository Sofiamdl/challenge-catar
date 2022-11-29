//
//  IdealSleepGraph.swift
//  challenge-catar Watch App
//
//  Created by sml on 29/11/22.
//

import SwiftUI

struct IdealSleepGraph: View {
    let idealSleepInMinute: Int
    let averageMinutesSlept: Int
    var calculation: Double!
    var hoursShown: String!

    init(idealSleepInMinute: Int, averageMinutesSlept: Int) {
        self.idealSleepInMinute = idealSleepInMinute
        self.averageMinutesSlept = averageMinutesSlept
        self.calculation = (Double(averageMinutesSlept) / Double(idealSleepInMinute) / 2.0) + 0.5
        let minutes = idealSleepInMinute % 60 > 0 ? " \(idealSleepInMinute%60)min" : ""
        self.hoursShown = "\(String(Int(idealSleepInMinute/60)))h\(minutes)"
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(Color(ColorConstant.BLUE), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .opacity(0.5)
                .frame(width: 150, height: 110)
            
            Circle()
                .trim(from: 0.5, to: calculation)
                .stroke(Color(ColorConstant.BLUE), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 150, height: 110)
            
            VStack {
                TextView(text: "Sono Ideal:", color: Color(ColorConstant.LIGHT_GRAY), type: .idealSleep)
                TextView(text: hoursShown, color: .white, type: .value)
            }
            .frame(width: 150, height: 110)
        }
    }
}
