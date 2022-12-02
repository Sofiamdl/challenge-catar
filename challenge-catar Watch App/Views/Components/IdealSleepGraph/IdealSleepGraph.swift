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
    var calculation: Double
    var hoursShown: String
    
    private struct Constant {
        static let ALL_COMPLETED: Double = 1
    }

    init(idealSleepInMinute: Int, averageMinutesSlept: Int) {
        self.idealSleepInMinute = idealSleepInMinute
        self.averageMinutesSlept = averageMinutesSlept
        
        let howMuchCompleted = (Double(averageMinutesSlept) / Double(idealSleepInMinute) / 2.0) + 0.5
        self.calculation = howMuchCompleted
        
        let minutes = idealSleepInMinute % 60 > 0 ? " \(idealSleepInMinute%60)min" : ""
        let hours = Int(idealSleepInMinute/60)
        self.hoursShown = "\(hours)h\(minutes)"
    }
            
    var body: some View {
        ZStack (alignment: .bottom) {
            semiCircles
            semiCircleText
        }
    }
    
    private var semiCircles: some View {
        ZStack {
            SemiCircle(completed: Constant.ALL_COMPLETED)
            SemiCircle(completed: calculation)
        }
        .frame(width: 150, height: 5)
    }
    
    private var semiCircleText: some View {
        VStack {
            TextView(text: "Sono Ideal",
                     color: Color(ColorConstant.LIGHT_GRAY),
                     type: .idealSleep)
            
            TextView(text: hoursShown,
                     color: .white,
                     type: .value)
        }
    }
}

struct IdealSleepGraph_Previews: PreviewProvider {
    static var previews: some View {
        IdealSleepGraph(idealSleepInMinute: 5, averageMinutesSlept: 4)
    }
}

