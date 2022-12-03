//
//  SleepAnalysis.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit

class SleepAnalysis: HealthCalculable {
    
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -6
    }
    
    func calculte(with healthStore: HKHealthStore,  _ completion: @escaping StatisticsCollectionHandler) {
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: Constant.SEVEN_DAYS_BEFORE,
                                              to: Date())
        let endDate = Date()
        let predicateDate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: endDate,
                                                        options: .strictStartDate)
        
        let sortDescriptorEndDate = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis),
                                  predicate: predicateDate,
                                  limit: 7,
                                  sortDescriptors: [sortDescriptorEndDate]){
            (query, sleepAnalysisResult, error) in
            print(sleepAnalysisResult)
        }
        
        healthStore.execute(query)
        
    }
}
