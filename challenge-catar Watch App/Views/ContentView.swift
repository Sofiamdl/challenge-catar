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

struct TextStyle {
    let size: CGFloat
    let weight: Font.Weight
}

enum TextType {
    
    case title
    case description
    case value
    
    var textStyle: TextStyle {
        switch self {
        case .title:
            return TextStyle(size: 14, weight: .medium)
        case .description:
            return TextStyle(size: 12, weight: .medium)
        case .value:
            return TextStyle(size: 16, weight: .medium)
        }
    }
}

struct TextView: View {
    
    let text: String
    let color: Color
    let type: TextType
    
    var body: some View {
        Text(text)
            .font(.system(size: type.textStyle.size,
                          weight: type.textStyle.weight,
                          design: .rounded))
            .foregroundColor(color)
    }
}

enum StatusValue {
    case increasing
    case decreasing
    case withoutIcon
}

struct ColorConstant {
    static let BLUE = "blue"
    static let LIGHT_GRAY = "light_gray"
}

struct CardInformation: View {
    let status: StatusValue
    
    let insets = EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextView(text: "Hoje",
                     color: Color(ColorConstant.BLUE),
                     type: .title)
                .padding(insets)
            
            HStack(spacing: 56){
                TextView(text: "Tempo",
                         color: Color(ColorConstant.LIGHT_GRAY),
                         type: .description)
                TextView(text: "Qualidade",
                         color: Color(ColorConstant.LIGHT_GRAY),
                         type: .description)
            }
            .padding(insets)
            
            HStack(spacing: 18) {
                TextView(text: "5 horas",
                         color: .white,
                         type: .value)
                Line(orienttion: .vertical,
                     withColor: Color(ColorConstant.BLUE))
                
                TextView(text: "80%",
                         color: .white,
                         type: .value)
            }
            .padding(insets)
            
            Line(orienttion: .horizontal,
                 withColor: Color(ColorConstant.BLUE))
    }
    
}

struct ContentView: View {
    @EnvironmentObject private var coordinator: Coordinator

//    let data = [Data(id: UUID().uuidString, time: 2, value: 20),
//                Data(id: UUID().uuidString, time: 1, value: 10),
//                Data(id: UUID().uuidString, time: 2, value: 120),
//                Data(id: UUID().uuidString, time: 3, value: 30),
//                Data(id: UUID().uuidString, time: 2, value: 20)]
    

    
    var body: some View {
        CardInformation(status: .increasing)
    
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
