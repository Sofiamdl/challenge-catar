//
//  ReportsScreen.swift
//  challenge-catar Watch App
//
//  Created by sml on 29/11/22.
//

import SwiftUI

struct ReportsScreen: View {
    @State private var averageSpeed: Double = 0.0
    @State private var inBed: [Float] = []
    @State private var orderedWeekSpeedAverage: [Double] = []
    @State private var allSleep: [Double] = []

    let healthSession = HealthSession()
    let sleepAnalysis = SleepAnalysis()

    let speedCalculate = SpeedCalculate()

    private var averageHour: Float {
        let inBedFiltered = inBed.filter{ value in
            return value != 0.0
        }
        
        let sum = inBedFiltered.reduce(0,+)
        let average = sum / Float(inBedFiltered.count)
        return floor(average)
    }
    
    var body: some View {
        
        ScrollView {
            VStack (spacing: 6){
                Average(distancePerHour: "\(ceil(averageSpeed*10)/10)k/h", sleepingHours: "\(ceil((averageHour/60)*10)/10)h")
                IdealSleepGraph(idealSleepInMinute: Int(inBed.max() ?? 0), averageMinutesSlept: Double(floor(averageHour*10)/10))
                    .padding(.top, 32)
                TextView(text: "Você está com problemas \("na qualidade do") sono.", color: .white, type: .reportDescription)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                Line(orienttion: .horizontal, withColor: Color(ColorConstant.BLUE))
                TextView(text: "A porcentagem ideal é acima de 75% enquanto a sua foi de x%.", color: Color(ColorConstant.LIGHT_GRAY), type: .regular)
                Line(orienttion: .horizontal, withColor: Color(ColorConstant.BLUE))
                TextView(text: "Aqui estão algumas dicas para melhorar sua qualidade de sono:", color: Color(ColorConstant.BLUE), type: .idealSleep)
                BulletList(elements: ["Estabeleça uma rotina de sono.",
                                      "Respeite o horário de ir dormir.",
                                      "Desligue a TV e demais aparelhos eletrônicos próximo ao horário do sono."])
            }
            .navigationBarTitle("Relatório Semanal")
        }.onAppear{
            healthSession.authorizeHealthKit{ (authorized, error) in
                speedCalculate.calculte(){ (averageSpeed, orderedWeekSpeedAverage) in
                    self.averageSpeed = averageSpeed
                    self.orderedWeekSpeedAverage = orderedWeekSpeedAverage
                }
                sleepAnalysis.calculte(){ resultSleepCollection in
                    switch resultSleepCollection {
                    case .success(let sleepDate):
                        updateView(with: sleepDate)
                    case .failure:
                        print("deu ruim")
                    }
                }
            }
            
        }
    }
    
    func updateView(with data: SleepDataCollection){
        
         let (newInBed, newAllSleep) = UpdateViewHandler.create(data)
        
        inBed = newInBed
        allSleep = newAllSleep
    }
}
