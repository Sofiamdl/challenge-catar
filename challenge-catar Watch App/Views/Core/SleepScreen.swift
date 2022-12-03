//
//  SleepScreen.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 30/11/22.
//

import SwiftUI

struct SleepScreen: View {

    let sleepingHours = CardValues(leftSideContent: "5 horas",
                                                 rightSideContent: "80%")
    
    let averageSleepingHours = CardValues(leftSideContent: "5 horas",
                                          rightSideContent: "80%")
    
    let healthSession: HealthSession = HealthSession()
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8){
                
                CardInformation(values: sleepingHours,
                                iconStatus: .withoutIcon,
                                title: .today,
                                page: .sleep)
                
                CardInformation(values: averageSleepingHours,
                                iconStatus: .increasing,
                                title: .average,
                                page: .sleep)
                
                DailyProgressGraphicView(values: [1,2,3,4,5,6,7],
                                         labels: ["S", "T", "Q", "Q", "S", "S", "D"],
                                         screen: .sleepScreen)
            }
            .padding()
        }
        .navigationBarTitle("Sono")
        .onAppear {
            healthSession.authorizeHealthKit { (authorized, error) in
                healthSession.statisticsCollection(.sleep){ _ in
                    print("rolou")
                }
            }
        }
    }
}

struct SleepScreen_Previews: PreviewProvider {
    static var previews: some View {
        SleepScreen()
    }
}
