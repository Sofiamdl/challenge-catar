//
//  DailyProgressGraphicView.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 29/11/22.
//

import SwiftUI
import Charts

struct DailyProgressGraphicView: View {
    
    let values: [Float]
    let labels: [String]
    let maxValue: Float
    let screen: RouteScreen
    
    var blueOrPurple: Color {
        return screen == .runningScreen ? Color(ColorConstant.BLUE) : Color(ColorConstant.PURPLE)
    }
    
    var body: some View {
        VStack{
            Spacer().frame(height: 4)
            
            HStack{
                Image(systemName: "calendar").foregroundStyle(blueOrPurple)
                Spacer().frame(width: 12)
                
                TextView(text: "Progresso Diário", color: .white, type: TextType.graphTitle)
                
                Spacer()
            }
            
            Spacer().frame(height: 8)
            
            VStack{
                HStack {
                    VStack (spacing: 16){
                        TextView(text: String(Int(maxValue)), color: Color(ColorConstant.LIGHT_GRAY), type: TextType.description)
                        TextView(text: "0", color: Color(ColorConstant.LIGHT_GRAY), type: TextType.description)
                        Spacer().frame(height: 4)
                    }
                    Spacer().frame(width: 12)
                    ForEach(values.indices, id: \.self) { index in
                        
                        let label = labels[index]
                        let value = values[index]
                        
                        VStack {
                            HStack {
                                Rectangle()
                                    .frame(width: 1,height: CGFloat(10*5))
                                    .foregroundColor(Color(ColorConstant.MEDIUM_BLACK))
                                
                                ZStack (alignment: .bottom){
                                    Rectangle()
                                        .frame(width: 8, height: CGFloat(45))
                                        .cornerRadius(4)
                                        .foregroundStyle(blueOrPurple)
                                        .opacity(0.26)
                                    
                                    Rectangle()
                                        .frame(width: 8, height: CGFloat((value/maxValue)*45))
                                        .cornerRadius(4)
                                        .foregroundStyle(blueOrPurple)
                                }
                            }
                            TextView(text: label, color: Color(ColorConstant.LIGHT_GRAY), type: TextType.description)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct DailyProgressGraphicView_Previews: PreviewProvider {
    static var previews: some View {
        DailyProgressGraphicView(values: [4,6,5,8,6,8,9], labels: ["S","T","Q","Q","S","S","D"], maxValue: 9, screen: .runningScreen)
    }
}
