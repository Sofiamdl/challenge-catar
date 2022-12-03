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
    var labels: [String] = ["D","S","T","Q","Q","S","S"]
    let screen: RouteScreen
    
    var blueOrPurple: Color {
        return screen == .runningScreen ? Color(ColorConstant.BLUE) : Color(ColorConstant.PURPLE)
    }
    
    var hrsOrKm: String {
        return screen == .runningScreen ? "km" : "hrs"
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
            
            VStack(alignment: .center){
                ZStack{
                    HStack {
                        VStack (spacing: 16){
                            TextView(text: String(ceil(Double(values.max() ?? 0)*10)/10)+hrsOrKm, color: Color.green, type: TextType.description).opacity(0.6)
                            
                            TextView(text: "0"+hrsOrKm , color: Color.red, type: TextType.description).opacity(0.6)
                            Spacer().frame(height: 4)
                        }
                        Spacer().frame(width: 8)
                        ForEach(values.indices, id: \.self) { index in
                            
                            let label = labels[(index+Int(Date().dayNumberOfWeek()!))%7]
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
                                            .frame(width: 8, height: CGFloat((value/(values.max() ?? 0))*45))
                                            .cornerRadius(4)
                                            .foregroundStyle(blueOrPurple)
                                    }
                                }
                                if index < 6 {
                                    TextView(text: label, color: Color(ColorConstant.LIGHT_GRAY), type: TextType.description)
                                }
                                else {
                                    TextView(text: label, color: Color.white, type: TextType.description)
                                }
                            }
                        }
                        Spacer()
                    }
                    let sum = values.reduce(0,+)
                    let length = values.count
                    let avg = Float(sum)/Float(length)
                    let desempenho = CGFloat(avg/(values.max() ?? 0))
                    
                    if desempenho > 0.5 {
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(dash: [3.1]))
                            .frame(width: 130, height: 1)
                            .offset(x: 17,y: (CGFloat(avg/(values.max() ?? 0))*(-44))+13)
                            .foregroundColor(Color.green)
                            .opacity(0.8)
                    }
                    else {
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(dash: [3.1]))
                            .frame(width: 130, height: 1)
                            .offset(x: 17,y: (CGFloat(avg/(values.max() ?? 0))*(-44))+13)
                            .foregroundColor(Color.red)
                            .opacity(0.8)
                    }
                }
            }
        }
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

struct DailyProgressGraphicView_Previews: PreviewProvider {
    static var previews: some View {
        DailyProgressGraphicView(values: [0,0,0,0,0,0,9], screen: .runningScreen)
    }
}
