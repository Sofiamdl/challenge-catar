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

struct teste: Identifiable {
    let id: Int
    let name: String
    var height: CGFloat
}

class Opa: ObservableObject {

    @Published var testes: [teste] = [
        teste(id: 0, name: "opa", height: 87),
        teste(id: 1, name: "opa1", height: 87),
        teste(id: 2, name: "opa2", height: 87)
    ]
}

struct ContentView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject var testao = Opa()
        
    @State private var scrolling = 0

    var body: some View {
        
        
//        let cardContent = CardValues(leftSideContent: "5 horas", rightSideContent: "80%")
//        CardInformation(values: cardContent,
//                        iconStatus: .withoutIcon,
//                        title: .today,
//                        page: .sleep)
        
        VStack{
            Spacer()
            ScrollViewReader { scroll in
                
                List {
                    ForEach(testao.testes, id: \.id){ test in
                        Button(action: {
                            print("oi")
                        }, label: {
                            Text("testando \(test.id)")
                                .frame(height: test.height)
                        })
                        .id(test.id)
                    }
                }
                .padding(EdgeInsets(top: 24,
                                    leading: 0, bottom: 0,
                                    trailing: 0))
                .scrollDisabled(true)
                 .onChange(of: scrolling, perform: { _ in
                     withAnimation{
                         scroll.scrollTo(scrolling)
                     }

                    })
            }
            .gesture(
                DragGesture(minimumDistance: 0).onEnded { value in
                    if value.translation.height < 0 {
                        testao.testes[scrolling].height = 70
                        scrolling = (scrolling+1) % testao.testes.count
      
                    } else {
                        scrolling -= 1
                        testao.testes[scrolling].height = 87
                        if scrolling < 0 {
                            scrolling = 0
                        }
                        
                    }
                }
            )
            Spacer()
        }
    }
            
}
            
//        NavigationStack {
//            NavigationLink("Some view", destination: SomeView())
//        }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
