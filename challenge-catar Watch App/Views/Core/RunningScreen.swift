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
        
        let avarageDistanceVelocityValues = CardValues(leftSideContent: "\(averageMeters) km",
                                                       rightSideContent: "\(averageSpeed) km/h")
        ScrollView {
            VStack(alignment: .center, spacing: 8){
                
                CardInformation(values: todayDistanceVelocityValues,
                                iconStatus: .withoutIcon,
                                title: .today, page: .running)
                
                CardInformation(values: avarageDistanceVelocityValues,
                                iconStatus: .increasing,
                                title: .avarage,
                                page: .running)
                
                DailyProgressGraphicView(values: meters,
                                         screen: .runningScreen)
            }
            .padding()
        }
        .navigationBarTitle("Corrida")
        .onAppear{
            healthSession.authorizeHealthKit{ (authorized, error) in
                healthSession.statisticsCollection(.distanceWalking){ staticsCollection in
                    switch staticsCollection {
                        
                    case .success(let statistics):
                        updateViewWith(statistics: statistics)
                    case .failure:
                        print("deu mt ruim")
                    }
                }
            }
        }
        
    }
    
    func updateViewWith(statistics: HKStatisticsCollection){
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: -6,
                                              to: Date())!
        let endDate = Date()
        statistics.enumerateStatistics(from: startDate,
                                  to: endDate) { (statistic, stop) in
            let meter = DistanceHandler.adapt(quantity: statistic)
            let seconds = TimeHandler.adapt(quantity: statistic)
            let velocityKM = VelocityHandler.toKM(withTimeDuration: seconds,
                                                  andDistance: meter)
            meters.append(meter/1000)
            speed.append(velocityKM)
        }
    }
}


struct RunningScreen_Previews: PreviewProvider {
    static var previews: some View {
        RunningScreen()
    }
}
