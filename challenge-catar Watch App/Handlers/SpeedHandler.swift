//
//  SpeedHandler.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 02/12/22.
//

import Foundation
import HealthKit


class SpeedHandler: StatisticsHandler {

    typealias typeStatisticComputed = Float
    
    static func adapt(quantity value: HKStatistics?) -> Float {
        guard let value = value else { return 1 }
        return Float(0)
    }
}
