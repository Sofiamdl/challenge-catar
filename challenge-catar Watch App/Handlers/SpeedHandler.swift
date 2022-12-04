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
        //let time = value.duration()?.doubleValue(for: .minute())
        let teste = value.sumQuantity()
        let testeEnd = value.averageQuantity()?.doubleValue(for: HKUnit.meter().unitDivided(by: HKUnit.second()))
        print("value of speed ", value)
        print("averageQuantity of speed ", testeEnd)
        print("sumQuantity of speedHandler ", teste)
        print(value)
        return Float(0)
    }
}
