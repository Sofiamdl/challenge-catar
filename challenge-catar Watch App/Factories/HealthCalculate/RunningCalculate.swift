//
//  RunningCalculate.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit


class RunningCalculate: HealthCalculable {
    typealias StatisticsCollectionType = HKStatisticsCollection
        
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -6
    }
    
    func calculte(with healthStore: HKHealthStore, _ completion: @escaping StatisticsCollectionHandler) {
        
        let start = Calendar.current.date(byAdding: .day,
                                          value: Constant.SEVEN_DAYS_BEFORE,
                                          to: Date())
        let end = Date()
      
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

        let runningSpeedType = HKSampleType.quantityType(forIdentifier: .runningSpeed)!
        let sortByStartDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: walkSpeedType,
                                   predicate: datePredicate,
                                   limit: HKObjectQueryNoLimit,
                                   sortDescriptors: [sortByStartDate]) { (_, statisticsCollection, error) in
            guard let statisticsCollection = statisticsCollection else { return }
            completion(.success(statisticsCollection))
        }
        
        healthStore.execute(query)
    }
}
