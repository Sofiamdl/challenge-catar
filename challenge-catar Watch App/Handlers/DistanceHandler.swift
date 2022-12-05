//
//  DistanceHandler.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit


class DistanceHandler: StatisticsHandler {
    
    typealias typeStatisticComputed = Float
        
    static func adapt(quantity value: HKStatistics? ) -> Float {
        guard let value = value else { return 0 }
        let valueInMeters = value.sumQuantity()?.doubleValue(for: .meter())
        return Float(valueInMeters ?? 0)
    }
}
