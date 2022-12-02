//
//  DistanceCalculate.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit

class DistanceCalculate: HealthCalculable {
    
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -6
    }
    
    func calculte(with healthStore: HKHealthStore, _ completion: @escaping StatisticsCollectionHandler ) {
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: Constant.SEVEN_DAYS_BEFORE,
                                              to: Date())
        let endDate = Date()
        let predicateDate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: endDate,
                                                        options: .strictStartDate)
        let daily = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: HKQuantityType(.distanceWalkingRunning),
                                    quantitySamplePredicate: predicateDate,
                                                anchorDate: .now,
                                    intervalComponents: daily)
        
        query.initialResultsHandler = { _, statisticsCollection, error in
//            guard let _ = error else {
//                completion(.failure(StatisticsError.getInitialStatistics))
//                return
//            }
            
            guard let statisticsCollection = statisticsCollection else { return }
            completion(.success(statisticsCollection))
        }
        
        healthStore.execute(query)
    }
}
