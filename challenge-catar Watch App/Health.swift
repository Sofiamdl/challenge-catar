//
//  Health.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 30/11/22.
//

import Foundation
import HealthKit

typealias StatisticsCollectionHandler = ((Result<HKStatisticsCollection, Error>) -> Void)

class HealthSession {
    
    typealias AuthorizedHealthKitHandler = (Bool, Error?) -> Void
    
    private let healthKitStore: HKHealthStore = HKHealthStore()
 
    func authorizeHealthKit(_ completion: @escaping AuthorizedHealthKitHandler ){
        
        let typesHealthKitToAskPermission = Set([HKQuantityType(.runningSpeed),
                         HKQuantityType(.distanceWalkingRunning),
                         HKQuantityType(.stepCount),
                         HKCategoryType(.sleepAnalysis),
                         HKCategoryType(.sleepChanges)])
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("cant access healthkit")
        }
        
        healthKitStore.requestAuthorization(toShare: typesHealthKitToAskPermission,
                                            read: typesHealthKitToAskPermission){ (success, error) in
            
            if let error = error  { completion(false, error) }
            completion(success, nil)
        }
    }
    
    func statisticsCollection(_ type: CalculationType, _ completion: @escaping StatisticsCollectionHandler){
        let healthCalculateFactory = HealthCalculateFactory.of(type)
        healthCalculateFactory.calculte(with: healthKitStore){ statisticsCollection in
            completion(statisticsCollection)
        }
    }
}


enum CalculationType {
    case running
    case distanceWalking
    case sleep
}

protocol HealthCalculable {
    func calculte(with healthStore: HKHealthStore, _ completion: @escaping StatisticsCollectionHandler)
}

class HealthCalculateFactory {
    
    static func of(_ calculation: CalculationType) -> HealthCalculable {
        if calculation == .running {
            return RunningCalculate()
        }
        
        if calculation == .distanceWalking {
            return DistanceCalculate()
        }
        
        return SleepAnalysis()
    }
}

class RunningCalculate: HealthCalculable {
    
    func calculte(with healthStore: HKHealthStore, _ completion: @escaping StatisticsCollectionHandler) {
    }
}

enum StatisticsError: Error {
    case getInitialStatistics
}


class DistanceCalculate: HealthCalculable {
    
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -7
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

class SleepAnalysis: HealthCalculable {
    
    func calculte(with healthStore: HKHealthStore,  _ completion: @escaping StatisticsCollectionHandler) {
        
    }
}

