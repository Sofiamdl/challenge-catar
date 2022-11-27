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

extension WKInterfaceDevice {
    
    static var size: CGRect {
        return WKInterfaceDevice.current().screenBounds
    }
}

enum LineOrientation {
    
    case vertical
    case horizontal
        
    var size: CGSize {
        switch self {
        case .horizontal:
            return CGSize(width: WKInterfaceDevice.size.width, height: 1)
        case .vertical:
            return CGSize(width: 3, height: 19)
        }
    }
}



struct Line: View {

    let orienttion: LineOrientation
    let withColor: Color
    
    var body: some View {
        Rectangle()
            .fill(withColor)
            .frame(width: orienttion.size.width,
                   height: orienttion.size.height,
                   alignment: .center)
            .cornerRadius(2)
    }
}

struct ContentView: View {
    @EnvironmentObject private var coordinator: Coordinator

//    let data = [Data(id: UUID().uuidString, time: 2, value: 20),
//                Data(id: UUID().uuidString, time: 1, value: 10),
//                Data(id: UUID().uuidString, time: 2, value: 120),
//                Data(id: UUID().uuidString, time: 3, value: 30),
//                Data(id: UUID().uuidString, time: 2, value: 20)]
    
    let insets = EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Hoje")
                .padding(insets)
            HStack(spacing: 32){
                Text("Tempo")
                Text("Qualidade")
            }
            .padding(insets)
            
            HStack(spacing: 24) {
                Text("5 horas")
                Line(orienttion: .vertical, withColor: .blue)
                Text("80%")
            }
            .padding(insets)
            
            Line(orienttion: .horizontal, withColor: .blue)
                    
        }
        

//        HStack{
//            Chart {
//
//                ForEach(data) { temp in
//
//                    LineMark(
//
//                        x: .value("Time", temp.time),
//
//                        y: .value("Temp", temp.value)
//
//                    )
//
//                }
//
//            }
//
//            .frame(height: 200)
//            .padding()
//        }
//        if #available(iOS 16.0, *) {
//            Button("Oi") {
//                coordinator.goToSomeView()
//            }
//        } else {
//            NavigationLink(destination: SomeView()) {
//                Text("Oi")
//            }
//        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
