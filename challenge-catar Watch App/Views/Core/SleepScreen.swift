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
        let todayMinutes = inBed.last ?? 0.0
        let todayHours =  todayMinutes / 60
        return Decimal.fixNumber(with: todayHours)
    }
    
    private var sleepQuality: Int {
        let todaySleepQuality = allSleep.last ?? 0.0
        return Int(floor(todaySleepQuality))
    }
    
    private var averageHour: Float {
        
        let inBedFiltered = inBed.filter{ currentInBed in
            return currentInBed != 0.0
        }

        let inBedFilteredSum = inBedFiltered.reduce(0,+)
        let inBedAverage = inBedFilteredSum / Float(inBedFiltered.count * 60)
        return floor(inBedAverage)
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
       let (newInBed, newAllSleep) = UpdateViewHandler.create(data)
       inBed = newInBed
       allSleep = newAllSleep
    }
}

struct SleepScreen_Previews: PreviewProvider {
    static var previews: some View {
        SleepScreen()
    }
}
