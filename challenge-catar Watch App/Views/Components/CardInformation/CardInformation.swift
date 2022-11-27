//
//  CardInformation.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 27/11/22.
//

import SwiftUI

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