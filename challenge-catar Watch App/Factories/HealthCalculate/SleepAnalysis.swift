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

class SleepDataFactory {
    
    static func create(atSleepData value: SleepDataCollection, and date: String) -> AppendableSleepData {
        
        if value[date] == nil {
            return NullableSleepData(at: date)
        }
        return AppendSleepData(at: date)
    }
}

protocol AppendableSleepData {
    
    func doChange(at sleepData: SleepDataCollection,
                  andValues values: SleepData, intervals: Intervals) -> SleepDataCollection
}

class NullableSleepData: AppendableSleepData {
    
    let date: String
    
    init(at date: String){
        self.date = date
    }
    
    func doChange(at sleepData: SleepDataCollection,
                  andValues values: SleepData, intervals: Intervals) -> SleepDataCollection {
        
        var newSleepData = sleepData
        
        let (initialIntervalDay, endIntervalDay, pointInterval) = intervals
        let (day,month,year) = SleepDateFormatter.getDayMonthYer(withString: self.date)
        
        let today = String(day).leftPadding(toLength: 2, withPad: "0")
        let key = "\(year)/\(month)/\(today)"
        
        if initialIntervalDay <= pointInterval && pointInterval < endIntervalDay {
            newSleepData[key] = [values]
        } else {
            
            let fixDay = String((day + 1)).leftPadding(toLength: 2, withPad: "0")
            let newDay = "\(year)/\(month)/\(fixDay)"
            
            if (newSleepData[newDay] == nil) {
                newSleepData[newDay] = [values]
            } else {
                newSleepData[newDay]?.append(values)
            }
        }
        
        return newSleepData
    }
}

class AppendSleepData: AppendableSleepData {
    
    let date: String
    
    init(at date: String){
        self.date = date
    }
    
    func doChange(at sleepData: SleepDataCollection, andValues values: SleepData, intervals: Intervals) -> SleepDataCollection {
        var newSleepData = sleepData
        
        let (initialIntervalDay, endIntervalDay, pointInterval) = intervals
        let (day,month,year) = SleepDateFormatter.getDayMonthYer(withString: self.date)
        
        let today = String(day).leftPadding(toLength: 2, withPad: "0")
        let key = "\(year)/\(month)/\(today)"
        
        if initialIntervalDay <= pointInterval && pointInterval < endIntervalDay {
            newSleepData[key]?.append(values)
        } else {
            let fixDay = String((day + 1)).leftPadding(toLength: 2, withPad: "0")
            let newDay = "\(year)/\(month)/\(fixDay)"
            
            if (newSleepData[newDay] == nil) {
                newSleepData[newDay] = [values]
            } else {
                newSleepData[newDay]?.append(values)
            }
        }
        
        return newSleepData
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
