//
//  SleepDataFactory.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 04/12/22.
//

import Foundation

class SleepDataFactory {

    static func create(atSleepData value: SleepDataCollection, and date: String) -> AppendableSleepData {
        
        if value[date] == nil {
            return NullableSleepData(at: date)
        }
        return AppendSleepData(at: date)
    }
}
