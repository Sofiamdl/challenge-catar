//
//  Health.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 30/11/22.
//

import Foundation
import HealthKit


class HealthSession {

    private let healthKitStore: HKHealthStore = HKHealthStore()
 
    func authorizeHealthKit(_ completion: @escaping AuthorizedHealthKitHandler ){
        
        let typesHealthKitToAskPermission = Set([HKQuantityType(.walkingSpeed),
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

enum StatisticsError: Error {
    case getInitialStatistics
}

