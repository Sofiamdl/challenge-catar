//
//  UpdateViewHandler.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 06/12/22.
//

import Foundation

typealias UpdatedView = ([Float], [Double])

class UpdateViewHandler {
    
    static func create(_ data: SleepDataCollection) -> UpdatedView {
        
        var inBed : [Float] = []
        var allSleep: [Double] = []
        
        
        let keys = (data.map({ (key, _) -> String in
            return key
        }) as Array)
        
        let keySorted = keys.sorted()
        
        keySorted.enumerated().forEach{ (index, date) in
            
            let allValues = data[date]!
            
            let allValuesInBed = allValues.filter { (minutes, type) in
                return  type == 0
            }
            
            let allValuesSleep = allValues.filter{ (minutes, type) in
                return type == 3 || type == 4 || type == 5
            }
            
            var sumInBed = 0.0
            for (minutes, _) in allValuesInBed {
                sumInBed += minutes
            }
            
            var sumAllSleep = 0.0
            for (minutes, _) in allValuesSleep {
                sumAllSleep += minutes
            }
            
            inBed.append(Float(sumAllSleep))
            allSleep.append((sumAllSleep/(sumInBed == 0 ? 1 : sumInBed))*100)
        }
        
        return (inBed, allSleep)
    }
    
    
    
}
