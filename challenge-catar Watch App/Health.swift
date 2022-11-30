//
//  Health.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 30/11/22.
//

import Foundation
import HealthKit


class Health {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(_ completion: @escaping (Bool?, Error?) -> Void){
        
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
