//
//  RunningCalculate.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit

typealias TesteHandler = CollectionHandler<[HKSample]>

class SpeedCalculate {
    typealias StatisticsCollectionType = [HKSample]
        
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -6
    }
    private let healthKitStore: HKHealthStore = HKHealthStore()

    
    func calculte( _ completion: @escaping TesteHandler) {
        
        let start = Calendar.current.date(byAdding: .day,
                                          value: Constant.SEVEN_DAYS_BEFORE,
                                          to: Date())
        let end = Date()
      
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

        let runningSpeedType = HKSampleType.quantityType(forIdentifier: .runningSpeed)!
        let sortByStartDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: runningSpeedType,
                                   predicate: datePredicate,
                                   limit: HKObjectQueryNoLimit,
                                   sortDescriptors: [sortByStartDate]) { (_, sample, error) in
            guard let statisticsCollection = sample else { return }
            completion(.success(sample!))
        }
                
        healthKitStore.execute(query)
    }
}
