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

class SleepAnalysis {
    
    private var sleepData: SleepDataCollection = [:]
    
    private let healthKitStore: HKHealthStore = HKHealthStore()
    
    private struct Constant {
        static let SEVEN_DAYS_BEFORE = -7
    }
    
    func calculte(_ completion: @escaping ((Result<SleepDataCollection, Error>) -> Void)) {
        
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: Constant.SEVEN_DAYS_BEFORE,
                                              to: Date())!
        
        let endDate = Calendar.current.date(byAdding: .day,
                                            value: 0,
                                            to: Date())!

        let predicateDate = HKQuery.predicateForSamples(withStart: startDate,
                                                        end: endDate)
        
        let sortDescriptorEndDate = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                                     ascending: false)
        
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
            
            completion(.success(self.sleepData))
        }
        
        healthKitStore.execute(query)
    }
    
    private func updateSleepData(with collection: [HKCategorySample]){
        collection.forEach { currentAnalyse in

            let initialSleepAnalysesAfterFormatter = SleepDateFormatter.create(with: currentAnalyse)
            let (day, month, year) = SleepDateFormatter.getDayMonthYer(withString: initialSleepAnalysesAfterFormatter)
            let (initialIntervalDayDate, endIntervalDayDate) = IntervalDayComponent.create(with: day,
                                                                                                 month,
                                                                                           and: year)
            let pointInterval = currentAnalyse.startDate.timeIntervalSince1970
            let endIntervalDay = endIntervalDayDate?.timeIntervalSince1970
            let initialIntervalDay = initialIntervalDayDate?.timeIntervalSince1970
            
            let timeMinutes = SleepTimer.timeInMinutes(between: currentAnalyse.endDate,
                                                       and: currentAnalyse.startDate)
            
            let sleepDataFactory = SleepDataFactory.create(atSleepData: self.sleepData,
                                                           and: initialSleepAnalysesAfterFormatter)
            
            let intervals = (initialIntervalDay!, endIntervalDay!, pointInterval)
            let sleepDataDecorator = ModifySleepDataFactory.change(with: intervals)
            
            let newSleepValues = (timeMinutes, currentAnalyse.value)
            
            let newSleepData = sleepDataFactory.doChange(at: self.sleepData,
                                                         withDecorator: sleepDataDecorator,
                                                         andValues: newSleepValues)
            self.sleepData = newSleepData
        }
    }

}

protocol AppendableSleepData {
    
    func doChange(at sleepData: SleepDataCollection,
                  withDecorator decorator: ChangeableSleepData,
                  andValues values: SleepData ) -> SleepDataCollection
}

protocol ChangeableSleepData {
    
    func execute(with sleepData: SleepDataCollection,
                 atKey key: String,
                 and values: SleepData) -> SleepDataCollection
}

class ModifySleepDataFactory {
    
    typealias Intervals = (TimeInterval, TimeInterval, TimeInterval)
    
    static func change(with intervals: Intervals) -> ChangeableSleepData {
        let (initialIntervalDay, endIntervalDay, pointInterval) = intervals
        if initialIntervalDay <= pointInterval && pointInterval < endIntervalDay {
            return CreateNewSleepDataKeyValue()
        }
        return AppendNewSleepData()
    }
}

class CreateNewSleepDataKeyValue: ChangeableSleepData {
    
    func execute(with sleepData: SleepDataCollection, atKey key: String, and values: SleepData) -> SleepDataCollection {
        var newSleepData = sleepData
        newSleepData[key] = [values]
        return newSleepData
    }

}

class AppendNewSleepData: ChangeableSleepData {
    
    func execute(with sleepData: SleepDataCollection, atKey key: String, and values: SleepData) -> SleepDataCollection {
        var newSleepData = sleepData
        let (day, month, year) = SleepDateFormatter.getDayMonthYer(withString: key)
        
        let nextDay = String((day + 1)).leftPadding(toLength: 2, withPad: "0")
        let newDay = "\(year)/\(month)/\(nextDay)"

        if (newSleepData[newDay] == nil) {
            newSleepData[newDay] = [values]
        } else {
            newSleepData[newDay]?.append(values)
        }
        return newSleepData
    }
}


class SleepDataFactory {
    
    static func create(atSleepData value: SleepDataCollection, and date: String) -> AppendableSleepData {
        
        if value[date] == nil {
            return NullableSleepData(at: date)
        }
        return AppendSleepData(at: date)
    }
}

class NullableSleepData: AppendableSleepData {
    
    let date: String
    
    init(at date: String){
        self.date = date
    }
    
    func doChange(at sleepData: SleepDataCollection,
                  withDecorator decorator: ChangeableSleepData,
                  andValues values: SleepData) -> SleepDataCollection {
        return decorator.execute(with: sleepData,
                                             atKey: date,
                                             and: values)
    }
}

class AppendSleepData: AppendableSleepData {
    
    let date: String
    
    init(at date: String){
        self.date = date
    }
    
    func doChange(at sleepData: SleepDataCollection, withDecorator decorator: ChangeableSleepData, andValues values: SleepData) -> SleepDataCollection {
        return decorator.execute(with: sleepData,
                                 atKey: date,
                                 and: values)
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

class IntervalDayComponent {
    
    typealias IntervalDateComponent = (Date?, Date?)
    
    private struct Constant {
        static let TIME_TO_START = 16
    }
    
    static func create(with day: Int, _ month: Int, and year: Int) -> IntervalDateComponent {
        let initialIntervalDayComponent = DateComponents(year: year,
                                                         month: month,
                                                         day: day - 1,
                                                         hour: Constant.TIME_TO_START,
                                                         minute: 0,
                                                         second: 0)
        
        let endIntervalDayComponent = DateComponents(year: year,
                                                     month: month,
                                                     day: day,
                                                     hour: Constant.TIME_TO_START,
                                                     minute: 0,
                                                     second: 0)
        
        let initialIntervalDayDate  = NSCalendar.current.date(from: initialIntervalDayComponent)
        let endIntervalDayDate = NSCalendar.current.date(from: endIntervalDayComponent)
        
        return (initialIntervalDayDate, endIntervalDayDate)
    }
}

class SleepDateFormatter {
    
    typealias DayMonthYear = (Int, Int, Int)

    struct Constant {
        static let FORMATTER = "YYYY/MM/dd"
        static let SEPARATOR = "/"
    }
    
    static func create(with analyse: HKCategorySample?) -> String {
        guard let analyse = analyse else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.FORMATTER
        return formatter.string(from: analyse.startDate)
    }
    
    static func getDayMonthYer(withString value: String) -> DayMonthYear {
        let year = value.split(separator: "/")[0]
        let month = value.split(separator: "/")[1]
        let day = value.split(separator: "/")[2]
        
        let yearConverted = Int(year)
        let dayConverted = Int(day)
        let monthConverted = Int(month)
        
        guard let yearConverted = yearConverted,
              let dayConverted = dayConverted,
              let monthConverted = monthConverted else { return (-1, -1, -1) }
        
        return (dayConverted, monthConverted, yearConverted)
    }
}

class SleepTimer {
    
    static func timeInMinutes(between endDate: Date, and startDate: Date) -> Double {
        let timeMinutes = endDate.timeIntervalSince(startDate) / 60
        if timeMinutes > 600 { return 0.0 }
        return timeMinutes
    }
}
