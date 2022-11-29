//
//  SelectScreen.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 29/11/22.
//

import SwiftUI

struct SelectScreen: View {
    
    @ObservedObject var screenObserver = ScreenObserver()
    @State private var scrolling = 0
    
    private let routesScreen: [RouteScreen] = [ .reportScreen, .runningScreen, .sleepScreen ]
    
    private let insets = EdgeInsets(top: 24,
                            leading: 0,
                            bottom: 12,
                            trailing: 0)
    
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
        .padding(insets)
        .scrollDisabled(true)
    }
    
    var body: some View {
        VStack {
            Spacer()
            ScrollViewReader { scroll in
                selectScreenList
                    .onChange(of: scrolling, perform: { _ in
                        withAnimation {
                            scroll.scrollTo(scrolling)
                        }
                    })
            }
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
        }
    }
}