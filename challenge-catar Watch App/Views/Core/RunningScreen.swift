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
    
    let healthSession = HealthSession()

    private var todayMeters: Float {
        return meters.last ?? 0.0
    }
    
    private var averageMeters: Float {
        let sumAllMeters = meters.reduce(0,+)
        return sumAllMeters/Float(meters.count)
    }
    
    private var todaySpeed: Float {
        return speed.last ?? 0.0
    }
    
    private var averageSpeed: Float {
        let sumAllSpeeds = speed.reduce(0,+)
        return sumAllSpeeds/Float(speed.count)
    }

    var body: some View {
        let todayDistanceVelocityValues = CardValues(leftSideContent: "\(todayMeters) km",
                                                     rightSideContent: "\(todaySpeed) km/h")
        
        let averageDistanceVelocityValues = CardValues(leftSideContent: "\(ceil(averageMeters*10)/10) km",
                                                       rightSideContent: "\(averageSpeed) km/h")
        ScrollView {
            VStack(alignment: .center, spacing: 8){
                
                CardInformation(values: todayDistanceVelocityValues,
                                iconStatus: .withoutIcon,
                                title: .today, page: .running)
                
                CardInformation(values: averageDistanceVelocityValues,
                                iconStatus: .increasing,
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
                
                healthSession.statisticsCollection(.speed){ staticsCollection in
                    switch staticsCollection {
                        
                    case .success(let statistics):
                        updateViewWithSpeed(statistics)
                    case .failure:
                        print("deu mt ruim")
                    }
                }
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
            let seconds = TimeHandler.adapt(quantity: statistic)
            let velocityKM = VelocityHandler.toKM(withTimeDuration: seconds,
                                                  andDistance: meter)
            meters.append(metersToKM)
            //speed.append(velocityKM)
        }
    }
    
    func updateViewWithSpeed(_ statistics: HKStatisticsCollection){
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: -6,
                                              to: Date())!
        let endDate = Date()
        statistics.enumerateStatistics(from: startDate,
                                  to: endDate) { (statistic, stop) in
            let speedKM = SpeedHandler.adapt(quantity: statistic)
            
            speed.append(speedKM)
        }
    }
}


struct RunningScreen_Previews: PreviewProvider {
    static var previews: some View {
        RunningScreen()
    }
}
