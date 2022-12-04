//
//  SleepDateFormatter.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 04/12/22.
//

import Foundation
import HealthKit

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
