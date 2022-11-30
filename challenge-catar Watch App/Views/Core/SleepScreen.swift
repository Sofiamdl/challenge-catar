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
    
    let avarageSleepingHours = CardValues(leftSideContent: "5 horas",
                                          rightSideContent: "80%")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8){
                
                CardInformation(values: sleepingHours,
                                iconStatus: .withoutIcon,
                                title: .today,
                                page: .sleep)
                
                CardInformation(values: avarageSleepingHours,
                                iconStatus: .increasing,
                                title: .avarage,
                                page: .sleep)
                
                DailyProgressGraphicView(values: [1,2,3,4,5,6,7],
                                         labels: ["S", "T", "Q", "Q", "S", "S", "D"],
                                         screen: .sleepScreen)
            }
            .padding()
        }
        .navigationBarTitle("Sono")
    }
}

struct SleepScreen_Previews: PreviewProvider {
    static var previews: some View {
        SleepScreen()
    }
}
