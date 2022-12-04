//
//  AppendSleepData.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 04/12/22.
//

import Foundation

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
