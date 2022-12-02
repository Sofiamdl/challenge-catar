//
//  StatisticsHandler.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 02/12/22.
//

import Foundation
import HealthKit

protocol StatisticsHandler {
    
    associatedtype typeStatisticComputed
    
    static func adapt(quantity value: HKStatistics? ) -> typeStatisticComputed
}
