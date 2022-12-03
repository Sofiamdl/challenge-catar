//
//  HealthCalculateFactory.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation


class HealthCalculateFactory {
    
    static func of(_ calculation: CalculationType) -> any HealthCalculable {
        if calculation == .speed {
            return RunningCalculate()
        }
        
        if calculation == .distanceWalking {
            return DistanceCalculate()
        }
        
        return SleepAnalysis()
    }
}
