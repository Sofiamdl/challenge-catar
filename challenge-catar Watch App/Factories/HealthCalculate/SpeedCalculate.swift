//
//  RunningCalculate.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit

class SpeedCalculate {
    
    typealias StatisticsCollectionType = [HKSample]
        
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -6
    }
    private let healthKitStore: HKHealthStore = HKHealthStore()

    
    typealias SpeedCollectionHandler = ((Double, [Double]) -> Void)
    
    
    func calculte( _ completion: @escaping SpeedCollectionHandler ) {
        
        let start = Calendar.current.date(byAdding: .day,
                                          value: Constant.SEVEN_DAYS_BEFORE,
                                          to: Date())
        let end = Date()
      
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end)

        let runningSpeedType = HKSampleType.quantityType(forIdentifier: .runningSpeed)!
        
        let sortByStartDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                               ascending: true)
    
        let query = HKSampleQuery(sampleType: runningSpeedType,
                                   predicate: datePredicate,
                                   limit: HKObjectQueryNoLimit,
                                   sortDescriptors: [sortByStartDate]) { (_, sample, error) in
            
            let (averageSpeed, orderedWeekSpeedAverage) = self.updateSpeedData(with: sample)
            completion(averageSpeed, orderedWeekSpeedAverage)
        }
                
        healthKitStore.execute(query)
    }
    
    private func getVelocity(withSpeed value: HKQuantitySample) -> Double {
        let metersPerSecond = HKUnit.meter().unitDivided(by: HKUnit.second())
        return value.quantity.doubleValue(for: metersPerSecond) * 3.6
    }
    
    private func updateSpeedData(with collection: [HKSample]? ) -> (Double, [Double]) {
        
        guard let statisticsCollection = collection else { return (0, []) }
        var weekSpeedAverage: [Double] = [0,0,0,0,0,0,0]
        
        var runningData: [Int: [Double]] = [:]
        
        let converted = statisticsCollection.compactMap{ sample in
            return sample as? HKQuantitySample
        }
        
        let speedCollection = converted.map{ speedElement in
            return self.getVelocity(withSpeed: speedElement)
        }
        
        converted.enumerated().forEach{ (index, speed) in
            let day = speed.startDate.dayNumberOfWeek() ?? 1
            
            let velocity = speedCollection[index]
            
            if runningData[day-1] == nil {
                runningData[day-1] = [velocity]
            } else {
                runningData[day-1]?.append(velocity)
            }
        }
        
        let today = Date().dayNumberOfWeek()!
        
        runningData.forEach{ (key, values) in
            weekSpeedAverage[key] = values.reduce(0, +) / Double(values.count)
        }
        
        let orderedWeekSpeedAverage = weekSpeedAverage.shiftRight(today)
        
        let averageSpeed = speedCollection.reduce(0, +) / Double( speedCollection.count)
        
        return (averageSpeed, orderedWeekSpeedAverage)
    }
}


