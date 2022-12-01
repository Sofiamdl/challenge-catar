//
//  Health.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 30/11/22.
//

import Foundation
import HealthKit


class HealthSession {
    
    typealias HandleAuthorizedHealthKit = (Bool?, Error?) -> Void
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(_ completion: @escaping HandleAuthorizedHealthKit ){
        
        let types = Set([HKQuantityType(.runningSpeed), HKCategoryType(.sleepAnalysis)])
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("cant access healthkit")
        }
        
        healthKitStore.requestAuthorization(toShare: types,
                                            read: types){ (success, error) in
            
            if let error = error  { completion(nil, error) }
            
            completion(success, nil)
        }
    }
}
