//
//  AppendableSleepData.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 04/12/22.
//

import Foundation

protocol AppendableSleepData {
    
    func doChange(at sleepData: SleepDataCollection,
                  andValues values: SleepData, intervals: Intervals) -> SleepDataCollection
}
