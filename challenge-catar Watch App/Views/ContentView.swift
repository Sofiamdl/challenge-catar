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


struct SelectScreen: View {
    
    @ObservedObject var screenObserver = ScreenObserver()
    @State private var scrolling = 0
    
    private let routesScreen: [RouteScreen] = [
        .reportScreen, .runningScreen, .sleepScreen
    ]
    
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

struct ContentView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        NavigationStack {
            SelectScreen()
                .navigationDestination(for: RouteScreen.self){ route in
                    switch route {
                    case .runningScreen:
                        SomeView()
                    case .sleepScreen:
                        SomeView()
                    case .reportScreen:
                        SomeView()
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

