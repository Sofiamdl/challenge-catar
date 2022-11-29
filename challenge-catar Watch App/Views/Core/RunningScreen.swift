//
//  RunningScreen.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 29/11/22.
//

import SwiftUI

struct RunningScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8){
                let todayDistanceVelocityValues = CardValues(leftSideContent: "36 km", rightSideContent: "18 km/h")
                
                CardInformation(values: todayDistanceVelocityValues,
                                iconStatus: .withoutIcon,
                                title: .today, page: .running)
                
                let avarageDistanceVelocityValues = CardValues(leftSideContent: "36 km",
                                                               rightSideContent: "18 km/h")
                
                CardInformation(values: avarageDistanceVelocityValues,
                                iconStatus: .increasing,
                                title: .avarage,
                                page: .running)
                
                DailyProgressGraphicView(values: [ 1,2,3,4,5,6,7],
                                         labels: ["S", "T", "Q", "Q", "S", "S", "D"] )
            }
            .padding()
            
        }
    }
}

struct RunningScreen_Previews: PreviewProvider {
    static var previews: some View {
        RunningScreen()
    }
}
