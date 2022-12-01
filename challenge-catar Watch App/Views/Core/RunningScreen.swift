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
    
    private var todayMeters: Float {
        return meters.last ?? 0.0
    }
    
    private var averageMeters: Float {
        let sumAllMeters = meters.reduce(0,+)
        return sumAllMeters/Float(meters.count)
    }
    

    let healthSession = HealthSession()

    var body: some View {
        
        let todayDistanceVelocityValues = CardValues(leftSideContent: "\(todayMeters) km",
                                                     rightSideContent: "18 km/h")
        
        let avarageDistanceVelocityValues = CardValues(leftSideContent: "\(averageMeters) km",
                                                       rightSideContent: "18 km/h")
        
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
            meters.append(meter/1000)
            
        }
    }
}


struct RunningScreen_Previews: PreviewProvider {
    static var previews: some View {
        RunningScreen()
    }
}
