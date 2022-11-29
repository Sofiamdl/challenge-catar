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

protocol ScrollableDirection {
    func execute(with screens: [ScreenAvaiable], andCurrent scrolling: Int) -> ([ScreenAvaiable], Int)
}

class ScrollUp: ScrollableDirection {
    
    func execute(with screens: [ScreenAvaiable], andCurrent scrolling: Int) -> ([ScreenAvaiable], Int) {
        var newScreens = screens
        var newScrolling = scrolling
        newScrolling -= 1
        if newScrolling < 0 { newScrolling = 0 }
        newScreens[newScrolling].height = 96

        return (newScreens, newScrolling)
    }
}

class ScrollDown: ScrollableDirection {
    
    func execute(with screens: [ScreenAvaiable], andCurrent scrolling: Int) -> ([ScreenAvaiable], Int) {
        var newScreens = screens
        var newScrolling = scrolling
        if newScrolling != screens.count - 1 { newScreens[scrolling].height = 82 }
        newScrolling += 1
        if newScrolling == screens.count { newScrolling -= 1 }
        return (newScreens, newScrolling)
    }

}

class ScrollFactory {
    
    static func scrollToUpOrDown(withGesture value: DragGesture.Value) -> ScrollableDirection {
        if value.translation.height < 0 {
            return ScrollDown()
        }
        return ScrollUp()
    }
}

struct ScreenButtonViewModel {
    let imageName: String
    let textLabel: String
}



struct ScreenButton: View {

    let screenSelect: ScreenAvaiable
    
    var body: some View {
        NavigationLink(value: Route.sleepScreen, label: {
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

enum Route: Hashable {
    case selectScreen
    case runningScreen
    case sleepScreen
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
                .navigationDestination(for: Route.self){ route in
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

