//
//  RunningCalculate.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit

typealias TesteHandler = CollectionHandler<(Double, [Double])>

class SpeedCalculate {
    typealias StatisticsCollectionType = [HKSample]
        
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -6
    }
    private let healthKitStore: HKHealthStore = HKHealthStore()

    
    func calculte( _ completion: @escaping ((Double, [Double]) -> Void)) {
        
        let start = Calendar.current.date(byAdding: .day,
                                          value: Constant.SEVEN_DAYS_BEFORE,
                                          to: Date())
        
        var weekSpeedAverage: [Double] = [0,0,0,0,0,0,0]
        
        let end = Date()
      
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

        let runningSpeedType = HKSampleType.quantityType(forIdentifier: .runningSpeed)!
        let sortByStartDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: runningSpeedType,
                                   predicate: datePredicate,
                                   limit: HKObjectQueryNoLimit,
                                   sortDescriptors: [sortByStartDate]) { (_, sample, error) in
            guard let statisticsCollection = sample else { return }
            
            let converted = statisticsCollection.compactMap{ sample in
                return sample as? HKQuantitySample
            }
            
            let speedCollection = converted.map{ speedElement in
                return (speedElement.quantity.doubleValue(for: HKUnit.meter().unitDivided(by: HKUnit.second()))) * 3.6
            }
            
            var runningData: [Int: [Double]] = [:]
            
            
            let averageSpeed = speedCollection.reduce(0, +) / Double( speedCollection.count)
            
            converted.enumerated().forEach{ (index, speed) in
                let day = speed.startDate.dayNumberOfWeek() ?? 0
                
                if runningData[day-1] == nil {
                    runningData[day-1] = [speedCollection[index]]
                } else {
                    runningData[day-1]?.append(speedCollection[index])
                }
            }
            
            let today = Date().dayNumberOfWeek()
            
            runningData.forEach{ (key, values) in
                weekSpeedAverage[key] = values.reduce(0, +) / Double(values.count)
            }
            
            let orderedWeekSpeedAverage = weekSpeedAverage.shiftRight(today!)
            completion(averageSpeed, orderedWeekSpeedAverage)
        }
                
        healthKitStore.execute(query)
    }
}

extension Array {
    func shiftRight(_ amount: Int = 1) -> [Element] {
        var newAmount = amount
        guard count > 0 else { return self }
        assert(-count...count ~= newAmount, "Shift amount out of bounds")
        if newAmount < 0 { newAmount += count }  // this needs to be >= 0
        return Array(self[newAmount ..< count] + self[0 ..< newAmount])
    }

    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}
