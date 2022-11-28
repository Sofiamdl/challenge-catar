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
        ScreenAvaiable(id: 0, name: "opa", height: 87),
        ScreenAvaiable(id: 1, name: "opa1", height: 87),
        ScreenAvaiable(id: 2, name: "opa2", height: 87)
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
        newScreens[newScrolling].height = 87

        return (newScreens, newScrolling)
    }
}

class ScrollDown: ScrollableDirection {
    
    func execute(with screens: [ScreenAvaiable], andCurrent scrolling: Int) -> ([ScreenAvaiable], Int) {
        var newScreens = screens
        var newScrolling = scrolling
        if newScrolling != screens.count - 1 { newScreens[scrolling].height = 70 }
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



struct ScreenButton: View {
    
    typealias HandleWithUserAction = (() -> ())
    
    let screenSelect: ScreenAvaiable
    let didUseTapButton: HandleWithUserAction
    
    var body: some View {
        Button(action: {
            didUseTapButton()
        }, label: {
            Text("testando")
        })
        .frame(width: WKInterfaceDevice.size.width, height: screenSelect.height)
    }
}

struct ContentView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    @ObservedObject var screenObserver = ScreenObserver()
    @State private var scrolling = 0

    var body: some View {
        
        VStack {
            Spacer()
            ScrollViewReader { scroll in
                List {
                    ForEach(screenObserver.screens, id: \.id){ screen in
                        ScreenButton(screenSelect: screen){
                            print("oi")
                        }
                        .id(screen.id)
                    }
                }
                .padding(EdgeInsets(top: 24,
                                    leading: 0, bottom: 12,
                                    trailing: 0))
                .scrollDisabled(true)
                 .onChange(of: scrolling, perform: { _ in
                     withAnimation{
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
            


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
