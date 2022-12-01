//
//  SelectScreen.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 29/11/22.
//

import SwiftUI
import HealthKit

struct SelectScreen: View {
    
    @ObservedObject var screenObserver = ScreenObserver()
    @State private var scrolling = 0
    
    let healthSession = HealthSession()
    
    private let routesScreen: [RouteScreen] = [ .reportScreen, .runningScreen, .sleepScreen ]
    
    private var selectScreenList: some View {
        List {
            ForEach(0..<screenObserver.screens.count){ index in
                let screen = screenObserver.screens[index]
                let route = routesScreen[index]
                ScreenButton(screenSelect: screenObserver.screens[index],
                             withRouteScreen: route)
                .id(screen.id)
            }
        }
        .scrollDisabled(true)
    }
    
    private var scrollViewReaderWithAnimation: some View {
        ScrollViewReader { scroll in
            selectScreenList
                .onChange(of: scrolling, perform: { _ in
                    withAnimation {
                        scroll.scrollTo(scrolling)
                    }
                })
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            scrollViewReaderWithAnimation
            .gesture(
                DragGesture().onEnded { value in
                    let scrollDirection = ScrollFactory.scrollToUpOrDown(withGesture: value)
                    let (screens, newScrolling) = scrollDirection.execute(with: screenObserver.screens,
                                                                          andCurrent: scrolling)
                    scrolling = newScrolling
                    screenObserver.screens = screens
                }
            )
            Spacer()
        }.onAppear{
            healthSession.authorizeHealthKit{ (authorized, error) in
                healthSession.statisticsCollection(.distanceWalking){ staticsCollection in
                    switch staticsCollection {
                        
                    case .success(let statics):
                        print(statics)
                        testaAi(teste: statics)
                    case .failure:
                        print("deu mt ruim")
                    }
                }
            }
        }
    }
    
    func testaAi(teste: HKStatisticsCollection){
        let startDate = Calendar.current.date(byAdding: .day,
                                              value: -7,
                                              to: Date())!
        let endDate = Date()
        
        teste.enumerateStatistics(from: startDate,
                                  to: endDate) { (statiss, stop) in
    
            print(statiss.sumQuantity() ?? "0 m")
        }
        

    }
}
