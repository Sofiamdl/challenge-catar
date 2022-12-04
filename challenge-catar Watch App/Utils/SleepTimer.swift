//
//  SleepTimer.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 04/12/22.
//

import Foundation

class SleepTimer {
    
    static func timeInMinutes(between endDate: Date, and startDate: Date) -> Double {
        let timeMinutes = endDate.timeIntervalSince(startDate) / 60
        return timeMinutes
    }
}
