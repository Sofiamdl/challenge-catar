//
//  ReportsScreen.swift
//  challenge-catar Watch App
//
//  Created by sml on 29/11/22.
//

import SwiftUI

struct ReportsScreen: View {
    var body: some View {
        ScrollView {
            VStack (spacing: 6){
                Avarage(distancePerHour: "50km/h", sleepingHours: "4h")
                IdealSleepGraph(idealSleepInMinute: 5, averageMinutesSlept: 4)
                    .padding(.top, 32)
                TextView(text: "Você está com problemas \("na qualidade do") sono.", color: .white, type: .reportDescription)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                Line(orienttion: .horizontal, withColor: Color(ColorConstant.BLUE))
                TextView(text: "A porcentagem ideal é acima de 85% enquanto a sua foi de x%.", color: Color(ColorConstant.LIGHT_GRAY), type: .idealSleep)
                Line(orienttion: .horizontal, withColor: Color(ColorConstant.BLUE))
                TextView(text: "Aqui estão algumas dicas para melhorar sua qualidade de sono:", color: Color(ColorConstant.BLUE), type: .idealSleep)
                BulletList(elements: ["Estabeleça uma rotina de sono.",
                                      "Respeite o horário de ir dormir.",
                                      "Desligue a TV e demais aparelhos eletrônicos próximo ao horário do sono."])


            }
            .navigationBarTitle("Relatório Semanal")
            
        }
        

    }
}
