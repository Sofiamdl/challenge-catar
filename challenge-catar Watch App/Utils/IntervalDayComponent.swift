//
//  IntervalDayComponent.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 04/12/22.
//

import Foundation

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
