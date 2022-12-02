//
//  ScreenButton.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 29/11/22.
//

import SwiftUI


struct ScreenButton: View {

    let screenSelect: ScreenAvaiable
    let withRouteScreen: RouteScreen
    
    var body: some View {
        NavigationLink(value: withRouteScreen, label: {
            VStack(alignment: .leading, spacing: 8){
                Image(systemName: withRouteScreen.imageName)
                    .foregroundColor(Color(ColorConstant.PURPLE))
                    .font(.system(size: 38, weight: .bold))
                TextView(text: screenSelect.name,
                         color: .white,
                         type: .value)
            }
        })
        .frame(height: screenSelect.height)
        
    }
}
