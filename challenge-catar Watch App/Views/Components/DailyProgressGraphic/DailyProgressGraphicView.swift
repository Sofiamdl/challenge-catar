//
//  DailyProgressGraphicView.swift
//  challenge-catar Watch App
//
//  Created by gabrielfelipo on 29/11/22.
//

import SwiftUI
import Charts

struct DailyProgressGraphicView: View {
    
    let values: [Int]
    let labels: [String]
    
    var body: some View {
        VStack{
            Spacer().frame(height: 4)
            
            HStack{
                Image(systemName: "calendar").foregroundStyle(Color(ColorConstant.PURPLE))
                Spacer().frame(width: 12)
                
                TextView(text: "Progresso Diário", color: .white, type: TextType.graphTitle)
                
                Spacer()
            }
            
            //            HStack{
            //                Spacer().frame(width: 24)
            //                Chart{
            //                    BarMark(
            //                        x: .value("Dia da semana", "Seg"),
            //                        y: .value("Tempo", 6)
            //                    )
            //
            //                    BarMark(
            //                        x: .value("Dia da semana", "Ter"),
            //                        y: .value("Tempo", 4)
            //                    )
            //
            //                    BarMark(
            //                        x: .value("Dia da semana", "Qua"),
            //                        y: .value("Tempo", 5)
            //                    )
            //
            //                    BarMark(
            //                        x: .value("Dia da semana", "Qui"),
            //                        y: .value("Tempo", 8)
            //                    )
            //
            //                    BarMark(
            //                        x: .value("Dia da semana", "Sex"),
            //                        y: .value("Tempo", 5)
            //                    )
            //
            //                    BarMark(
            //                        x: .value("Dia da semana", "Sab"),
            //                        y: .value("Tempo", 9)
            //                    )
            //
            //                    BarMark(
            //                        x: .value("Dia da semana", "Dom"),
            //                        y: .value("Tempo", 8)
            //                    )
            //                }.foregroundStyle(Color(ColorConstant.PURPLE))
            //                    .frame(height: 60)
            //                Spacer().frame(width: 16)
            //            }
            
            Spacer().frame(height: 8)
            
            HStack(alignment: .bottom) {
                ForEach(values.indices, id: \.self) { index in
                    
                    let label = labels[index]
                    let value = values[index]
                    
                    VStack {
                        HStack {
                            Rectangle()
                                .frame(width: 1,height: CGFloat(9*4))
                                .foregroundColor(Color(ColorConstant.MEDIUM_BLACK))
                            
                            ZStack (alignment: .bottom){
                                Rectangle()
                                    .frame(width: 8, height: CGFloat(9*4))
                                    .cornerRadius(4)
                                    .foregroundStyle(Color.white)
                                
                                Rectangle()
                                    .frame(width: 8, height: CGFloat(value*4))
                                    .cornerRadius(4)
                                    .foregroundStyle(Color(ColorConstant.PURPLE))
                            }
                        }
                        TextView(text: label, color: Color(ColorConstant.LIGHT_GRAY), type: TextType.description)
                    }
                }
            }
        }
    }
}

struct DailyProgressGraphicView_Previews: PreviewProvider {
    static var previews: some View {
        DailyProgressGraphicView(values: [4,6,5,8,6,8,9], labels: ["S","T","Q","Q","S","S","D"])
    }
}
