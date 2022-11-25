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

struct ContentView: View {
    @EnvironmentObject private var coordinator: Coordinator

    let data = [Data(id: UUID().uuidString, time: 2, value: 20),
                Data(id: UUID().uuidString, time: 1, value: 10),
                Data(id: UUID().uuidString, time: 2, value: 120),
                Data(id: UUID().uuidString, time: 3, value: 30),
                Data(id: UUID().uuidString, time: 2, value: 20)]
    var body: some View {
        HStack{
            Chart {
                
                ForEach(data) { temp in
                    
                    LineMark(
                        
                        x: .value("Time", temp.time),
                        
                        y: .value("Temp", temp.value)
                        
                    )
                    
                }
                
            }
            
            .frame(height: 200)
            .padding()
        }
        Button("Oi") {
            coordinator.goToSomeView()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
