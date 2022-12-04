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
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: Constant.SEVEN_DAYS_BEFORE,
                                              to: Date())
        let endDate = Date()
        let predicateDate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: endDate,
                                                        options: .strictStartDate)
        let daily = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: HKQuantityType(.appleExerciseTime),
                                    quantitySamplePredicate: predicateDate,
                                                anchorDate: .now,
                                    intervalComponents: daily)
        
        query.initialResultsHandler = { _, statisticsCollection, error in
            guard let statisticsCollection = statisticsCollection else { return }
            completion(.success(statisticsCollection))
        }
        
        healthStore.execute(query)
    }
}
