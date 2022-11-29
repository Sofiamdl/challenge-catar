//
//  SomeView.swift
//  challenge-catar Watch App
//
//  Created by sml on 25/11/22.
//

import SwiftUI

struct SomeView: View {
    var body: some View {
        VStack{
            Button("Oi") {
                print("oi")
            }
            DailyProgressGraphicView(values: [4,6,5,8,6,8,9], labels: ["S","T","Q","Q","S","S","D"], maxValue: 9, screen: .runningScreen)
        }
    }
}


struct SomeView_Previews: PreviewProvider {
    static var previews: some View {
        SomeView()
    }
}
