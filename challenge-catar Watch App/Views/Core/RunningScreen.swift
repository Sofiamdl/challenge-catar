//
//  RunningScreen.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 29/11/22.
//

import SwiftUI
import HealthKit

struct RunningScreen: View {
    
    @State private var meters: [Float] = []
    @State private var speed: [Float] = []
    @State private var averageSpeed: Double = 0.0
    @State private var todaySpeed: Double = 0.0
    
    let healthSession = HealthSession()

    let speedCalculate = SpeedCalculate()

    private var todayMeters: Float {
        return meters.last ?? 0.0
    }
    
    private var averageMeters: Float {
        let sumAllMeters = meters.reduce(0,+)
        return sumAllMeters/Float(meters.count)
    }
    

    

    var body: some View {
        let todayDistanceVelocityValues = CardValues(leftSideContent: "\(ceil(todayMeters*10)/10) km",
                                                     rightSideContent: "\(ceil(todaySpeed*10)/10) k/h")
        
        let averageDistanceVelocityValues = CardValues(leftSideContent: "\(ceil(averageMeters*10)/10) km",
                                                       rightSideContent: "\(ceil(averageSpeed*10)/10) k/h")
        ScrollView {
            VStack(alignment: .center, spacing: 8){
                
                CardInformation(values: todayDistanceVelocityValues,
                                iconStatus: .withoutIcon,
                                title: .today, page: .running)
                
                CardInformation(values: averageDistanceVelocityValues,
                                iconStatus: .withoutIcon,
                                title: .average,
                                page: .running)
                
                DailyProgressGraphicView(values: meters,
                                         screen: .runningScreen)
            }
            .padding()
        }
        .navigationBarTitle("Corrida")
        .onAppear {
            healthSession.authorizeHealthKit{ (authorized, error) in
                healthSession.statisticsCollection(.distanceWalking){ staticsCollection in
                    switch staticsCollection {
                    case .success(let statistics):
                        updateViewWith(statistics)
                    case .failure:
                        print("deu mt ruim")
                    }
                }
            }
            speedCalculate.calculte(){ (averageSpeed, orderedWeekSpeedAverage) in
                self.averageSpeed = averageSpeed
                self.todaySpeed = orderedWeekSpeedAverage.last!
            }
            
        }
    }
    
    func updateViewWith(_ statistics: HKStatisticsCollection){
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: -6,
                                              to: Date())!
        let endDate = Date()
        statistics.enumerateStatistics(from: startDate,
                                  to: endDate) { (statistic, _) in
            let meter = DistanceHandler.adapt(quantity: statistic)
            let metersToKM = meter/1000
            meters.append(metersToKM)
        }
        
        meters = meters.shiftRight(6)
    }
}


struct RunningScreen_Previews: PreviewProvider {
    static var previews: some View {
        RunningScreen()
    }
}
