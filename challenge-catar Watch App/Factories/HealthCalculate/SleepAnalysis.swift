//
//  SleepAnalysis.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 01/12/22.
//

import Foundation
import HealthKit

class SleepAnalysis: HealthCalculable {

    typealias StatisticsCollectionType = HKCategorySample
    
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -6
    }
    
    func calculte(with healthStore: HKHealthStore,  _ completion: @escaping StatisticsCollectionHandler) {
        
        
        var dict: [String: [(Double, Int)]] = [:]
        
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: -7,
                                              to: Date())!
        let endDate = Calendar.current.date(byAdding: .day, value: 0 ,to: Date())!
        
        let predicateDate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: endDate)
        
        let sortDescriptorEndDate = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis),
                                  predicate: predicateDate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptorEndDate]){
            (query, sleepAnalysisResult, error) in
            
            guard let sleepAnalysisCollection = sleepAnalysisResult else { return }
            
            let sleepAnalysisCollectionConverted = sleepAnalysisCollection.compactMap { currentAnalyse in
                return currentAnalyse as? HKCategorySample
            }

            
            sleepAnalysisCollectionConverted.forEach { currentAnalyse in
                
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY/MM/dd"
                            
                let initialSleepAnalyses = Date(primitivePlottable: currentAnalyse.startDate)
                
                let initialSleepAnalysesAfterFormatter = formatter.string(from: initialSleepAnalyses!)
                
                let year = initialSleepAnalysesAfterFormatter.split(separator: "/")[0]
                let month = initialSleepAnalysesAfterFormatter.split(separator: "/")[1]
                let day = initialSleepAnalysesAfterFormatter.split(separator: "/")[2]
                

                let initialIntervalDayComponent = DateComponents(year: Int(year),
                                                   month: Int(month),
                                                   day: Int(day)! - 1,
                                                   hour: 16,
                                                   minute: 0,
                                                   second: 0)
                
                let endIntervalDayComponent = DateComponents(year: Int(year),
                                                month: Int(month),
                                                day: Int(day)!,
                                                hour: 16,
                                                minute: 0,
                                                second: 0)
                
                let initialIntervalDayDate  = NSCalendar.current.date(from: initialIntervalDayComponent)
                let endIntervalDayDate = NSCalendar.current.date(from: endIntervalDayComponent)
                
                
                let pointInterval = currentAnalyse.startDate.timeIntervalSince1970
                let endIntervalDay = endIntervalDayDate?.timeIntervalSince1970
                let initialIntervalDay = initialIntervalDayDate?.timeIntervalSince1970
                
        
                var timeMinutes = currentAnalyse.endDate.timeIntervalSince(currentAnalyse.startDate) / 60
                
        
                if  timeMinutes > 600 {
                    timeMinutes = 0
                }
                
                
                if (dict[initialSleepAnalysesAfterFormatter] == nil) {
                    if initialIntervalDay! <= pointInterval && pointInterval < endIntervalDay! {
                        dict[initialSleepAnalysesAfterFormatter] = [(timeMinutes, currentAnalyse.value)]
                    }else {
                        let fixDay = String(Int(day)! + 1).leftPadding(toLength: 2, withPad: "0")
                        let newDay = "\(year)/\(month)/\(fixDay)"
    
                        if (dict[newDay] == nil) {
                            dict[newDay] = [(timeMinutes, currentAnalyse.value)]
                        } else {
                            dict[newDay]?.append((timeMinutes, currentAnalyse.value))
                        }
                    }
          
                } else {
                    if initialIntervalDay! <= pointInterval && pointInterval < endIntervalDay! {
                        dict[initialSleepAnalysesAfterFormatter]?.append((timeMinutes, currentAnalyse.value))
                    } else {
                        let fixDay = String(Int(day)! + 1).leftPadding(toLength: 2, withPad: "0")
                        let newDay = "\(year)/\(month)/\(fixDay)"

                        if (dict[newDay] == nil) {
                            dict[newDay] = [(timeMinutes, currentAnalyse.value)]
                        } else {
                            dict[newDay]?.append((timeMinutes, currentAnalyse.value))
                        }
                    }
                }
            }
        }
        
            
        healthStore.execute(query)
        print(dict)
    }

}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
