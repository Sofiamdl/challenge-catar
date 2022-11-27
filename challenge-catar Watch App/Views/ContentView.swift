//
//  ContentView.swift
//  challenge-catar Watch App
//
//  Created by sml on 25/11/22.
//

import SwiftUI
import Charts

struct Data: Identifiable {
    var id: String
    
    var time: Int
    var value:Int
}




enum Screen {
    case running
    case sleep
}

struct ContentView: View {
    
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        let cardContent = CardValues(leftSideContent: "5 horas", rightSideContent: "80%")
        CardInformation(values: cardContent,
                        iconStatus: .withoutIcon,
                        title: .today,
                        page: .sleep)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
