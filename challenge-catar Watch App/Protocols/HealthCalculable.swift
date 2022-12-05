//
//  HealthCalculable.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit


protocol HealthCalculable {
        
    func calculte(with healthStore: HKHealthStore, _ completion: @escaping StatisticsCollectionHandler)
}
