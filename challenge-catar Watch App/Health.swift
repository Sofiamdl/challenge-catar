//
//  Health.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 30/11/22.
//

import Foundation
import HealthKit


class HealthSession {
    
    typealias AuthorizedHealthKitHandler = (Bool, Error?) -> Void
    
    private let healthKitStore: HKHealthStore = HKHealthStore()
 
    func authorizeHealthKit(_ completion: @escaping AuthorizedHealthKitHandler ){
        
        let typesHealthKitToAskPermission = Set([HKQuantityType(.runningSpeed),
                         HKQuantityType(.distanceWalkingRunning),
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
    
    func calculate(_ type: CalculationType){
        let healthCalculateFactory = HealthCalculateFactory.of(type)
        healthCalculateFactory.calculte()
    }
}


enum CalculationType {
    case runningSpeed
    case distanceWalking
    case sleep
}

protocol HealthCalculable {
    func calculte()
}

class HealthCalculateFactory {
    
    static func of(_ calculation: CalculationType) -> HealthCalculable {
        if calculation == .runningSpeed {
            return RunningCalculate()
        }
        
        if calculation == .distanceWalking {
            return DistanceCalculate()
        }
        
        return SleepAnalysis()
    }
}

class RunningCalculate: HealthCalculable {
    
    func calculte() {
    }
}


class DistanceCalculate: HealthCalculable {
    
    func calculte() {
    }
}

class SleepAnalysis: HealthCalculable {
    
    func calculte() {
        
    }
}

