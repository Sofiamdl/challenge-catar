//
//  SleepAnalysis.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit

typealias SleepyDay = String
typealias TypeSleepAndTime = [(Double, Int)]
typealias SleepDataCollection = [SleepyDay : TypeSleepAndTime]
typealias SleepData = (Double, Int)

typealias Intervals = (TimeInterval, TimeInterval, TimeInterval)


typealias CollectionHandler<T> = ((Result<T, Error>) -> Void)
typealias StatisticsCollectionHandler = CollectionHandler<HKStatisticsCollection>

class SleepAnalysis {
    
    typealias SleepCollectionHandler = ((Result<SleepDataCollection, Error>) -> Void)
    
    private var sleepData: SleepDataCollection = [:]
    private let healthKitStore: HKHealthStore = HKHealthStore()
    
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -7
    }
    
    func calculte(_ completion: @escaping SleepCollectionHandler ) {
        
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: Constant.SEVEN_DAYS_BEFORE,
                                              to: Date())!
        
        let endDate = Calendar.current.date(byAdding: .day,
                                            value: 0,
                                            to: Date())!
        
        let predicateDate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: endDate)
        
        let sortDescriptorEndDate = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                                     ascending: true)
        
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis),
                                  predicate: predicateDate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptorEndDate]){
            (query, sleepAnalysisResult, error) in
            
            guard let sleepAnalysisCollection = sleepAnalysisResult else { return }
            
            let sleepAnalysisCollectionConverted = sleepAnalysisCollection.compactMap { currentAnalyse in
                return currentAnalyse as? HKCategorySample
            }
            
            self.updateSleepData(with: sleepAnalysisCollectionConverted)
            
            let sleepDataWithoutFakeTime = RemoveFakeTime(of: self.sleepData).execute()
            self.sleepData = sleepDataWithoutFakeTime
            
            completion(.success(self.sleepData))
        }
        
        healthKitStore.execute(query)
    }
    
    private func updateSleepData(with collection: [HKCategorySample]){
        collection.forEach { currentAnalyse in
            
            let initialSleepAnalysesAfterFormatter = AnalysisDateFormatter.create(with: currentAnalyse.startDate)
            let (day, month, year) = AnalysisDateFormatter.getDayMonthYer(withString: initialSleepAnalysesAfterFormatter)
            let (initialIntervalDayDate, endIntervalDayDate) = IntervalDayComponent.create(with: day,
                                                                                           month,
                                                                                           and: year)
            let pointInterval = currentAnalyse.startDate.timeIntervalSince1970
            let endIntervalDay = endIntervalDayDate?.timeIntervalSince1970
            let initialIntervalDay = initialIntervalDayDate?.timeIntervalSince1970
            
            let intervals = (initialIntervalDay!, endIntervalDay!, pointInterval)
            
            let timeMinutes = SleepTimer.timeInMinutes(between: currentAnalyse.endDate,
                                                       and: currentAnalyse.startDate)
            
            let sleepDataFactory = SleepDataFactory.create(atSleepData: self.sleepData,
                                                           and: initialSleepAnalysesAfterFormatter)
            let newSleepValues = (timeMinutes, currentAnalyse.value)
            let newSleepData = sleepDataFactory.doChange(at: self.sleepData, andValues: newSleepValues, intervals: intervals)
            self.sleepData = newSleepData
        }
    }
}
