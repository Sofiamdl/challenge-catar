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
            return TextStyle(size: 12, weight: .bold)
        case .value:
            return TextStyle(size: 16, weight: .bold)
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

enum IconStatus: String {
    case increasing = "arrow.up"
    case decreasing = "arrow.down"
    case withoutIcon
}

enum TitleCardInformation: String {
    case today = "Hoje"
    case avarage = "Média Semanal"
}

struct ColorConstant {
    static let BLUE = "blue"
    static let LIGHT_GRAY = "light_gray"
    static let PURPLE = "purple"
}

enum Screen {
    case running
    case sleep
}

struct CardValues {
    let leftSideContent: String
    let rightSideContent: String
}

struct CardInformation: View {
    
    let values: CardValues
    let iconStatus: IconStatus
    let title: TitleCardInformation
    let page: Screen
    
    let insets = EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            
            HStack(spacing: 8){
                TextView(text: title.rawValue,
                         color: Color(page == .sleep ? ColorConstant.PURPLE : ColorConstant.BLUE),
                         type: .title)
                .padding(insets)
                
                if iconStatus != .withoutIcon {
                    Image(systemName: iconStatus.rawValue)
                        .foregroundColor(
                            iconStatus == .increasing ? .green : .red
                        )
                        .font(.system(size: 12, weight: .bold))
                }
            }
                        
            HStack(spacing: page == .sleep ? 56 : 40){
                TextView(text: page == .sleep ? "Tempo" : "Distância",
                         color: Color(ColorConstant.LIGHT_GRAY),
                         type: .description)
                TextView(text: page == .sleep ? "Qualidade" : "Velocidade",
                         color: Color(ColorConstant.LIGHT_GRAY),
                         type: .description)
            }
            .padding(insets)
            
            HStack(spacing: page == .sleep ? 18 : 22) {
                TextView(text: values.leftSideContent,
                         color: .white,
                         type: .value)
                Line(orienttion: .vertical,
                     withColor: Color(page == .sleep ? ColorConstant.PURPLE : ColorConstant.BLUE))
                
                TextView(text: values.rightSideContent,
                         color: .white,
                         type: .value)
            }
            .padding(insets)
            
            Line(orienttion: .horizontal,
                 withColor: Color(page == .sleep ? ColorConstant.PURPLE : ColorConstant.BLUE))
        }
    }
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
