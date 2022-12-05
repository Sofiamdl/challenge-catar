//
//  SleepScreen.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 30/11/22.
//

import SwiftUI

struct SleepScreen: View {


    
    @State private var inBed: [Float] = []
    @State private var allSleep: [Double] = []
    
    private var todaySleep: Float {
        return Float(floor(((inBed.last ?? 0.0)/60)*10)/10)
    }
    
    private var sleepQuality: Int {
        return Int(floor(allSleep.last ?? 0.0))
    }
    
    private var averageHour: Float {
        let inBedFiltered = inBed.filter{ value in
            return value != 0.0
        }
        
        let sum = inBedFiltered.reduce(0,+)
        let average = sum / Float(inBedFiltered.count * 60)
        return floor(average)
    }
    
    private var avarageWeekSleep: Float {
        let allSleepFiltered = allSleep.filter{ value in
            return value != 0.0
        }
        
        let average = allSleepFiltered.reduce(0.0, +) / Double(allSleepFiltered.count)
        return Float(floor(average))
    }

    let healthSession: HealthSession = HealthSession()
    let sleepAnalysis = SleepAnalysis()
    var body: some View {
        
        let sleepingHours = CardValues(leftSideContent: "\(todaySleep) horas",
                                                     rightSideContent: "\(sleepQuality)%")
        
        let averageSleepingHours = CardValues(leftSideContent: "\(averageHour) horas",
                                              rightSideContent: "\(avarageWeekSleep)%")
        ScrollView {
            VStack(alignment: .center, spacing: 8){
                
                CardInformation(values: sleepingHours,
                                iconStatus: .withoutIcon,
                                title: .today,
                                page: .sleep)
                
                CardInformation(values: averageSleepingHours,
                                iconStatus: .withoutIcon,
                                title: .average,
                                page: .sleep)
                
                DailyProgressGraphicView(values: inBed,
                                         screen: .sleepScreen)
            }
            .padding()
        }
        .navigationBarTitle("Sono")
        .onAppear {
            healthSession.authorizeHealthKit { (authorized, error) in
                sleepAnalysis.calculte(){ resultSleepCollection in
                    switch resultSleepCollection {
                    case .success(let sleepDate):
                        updateView(with: sleepDate)
                    case .failure:
                        print("deu ruim")
                    }
                }
            }
        }
    }
    
    func updateView(with data: SleepDataCollection){
        
        let keys = (data.map({ (key, _) -> String in
            return key
        }) as Array)
        
        let keySorted = keys.sorted()
        keySorted.enumerated().forEach{ (index, date) in
//            let (values, type) = data[date]!
            
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
    }
    

}

struct SleepScreen_Previews: PreviewProvider {
    static var previews: some View {
        SleepScreen()
    }
}
