//
//  VelocityHandler.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit


class TimeHandler: StatisticsHandler {

    typealias typeStatisticComputed = Float
    
    static func adapt(quantity value: HKStatistics?) -> Float {
        guard let value = value else { return 1 }
        let time = value.duration()?.doubleValue(for: .second())
        return Float(time ?? 1)
    }
}
