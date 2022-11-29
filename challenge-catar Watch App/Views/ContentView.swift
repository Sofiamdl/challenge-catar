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

struct ScreenAvaiable: Identifiable {
    let id: Int
    let name: String
    var height: CGFloat
}

class ScreenObserver: ObservableObject {

    @Published var screens: [ScreenAvaiable] = [
        ScreenAvaiable(id: 0, name: "opa", height: 96),
        ScreenAvaiable(id: 1, name: "opa1", height: 96),
        ScreenAvaiable(id: 2, name: "opa2", height: 96)
    ]
}




struct ScreenButtonViewModel {
    let imageName: String
    let textLabel: String
}


struct ScreenButton: View {

    let screenSelect: ScreenAvaiable
    
    var body: some View {
        NavigationLink(value: RouteScreen.sleepScreen, label: {
            VStack(alignment: .leading, spacing: 8){
                Image(systemName: "figure.run")
                    .foregroundColor(Color(ColorConstant.PURPLE))
                    .font(.system(size: 38, weight: .bold))
                TextView(text: "Relatório Semanal",
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
    
    private let insets = EdgeInsets(top: 24,
                            leading: 0,
                            bottom: 12,
                            trailing: 0)
    
    private var selectScreenList: some View {
        List {
            ForEach(screenObserver.screens, id: \.id){ screen in
                ScreenButton(screenSelect: screen)
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
                    case .selectScreen:
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

