//
//  RemoveFakeTime.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 04/12/22.
//

import Foundation

class RemoveFakeTime {
    
    var sleepData: SleepDataCollection
    
    init(of data: SleepDataCollection){
        self.sleepData = data
    }
    
    func execute() -> SleepDataCollection {
        var newSleepData = self.sleepData
        sleepData.forEach{ (key , data) in
            let index = data.firstIndex(where: { (minutes, type) in
                return minutes >= 600
            })
            newSleepData[key]?.remove(at: index ?? 0)
            
        }
        return newSleepData
    }
}
