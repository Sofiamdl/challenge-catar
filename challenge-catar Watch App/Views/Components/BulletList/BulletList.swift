//
//  BulletList.swift
//  challenge-catar Watch App
//
//  Created by sml on 30/11/22.
//


import SwiftUI

struct BulletList: View {
    let elements: [String]
    
    var body: some View {
        VStack (alignment: .leading) {
            ForEach (elements, id: \.self) { element in
                HStack (alignment: .top) {
                    TextView(text: " • ", color: .white, type: .idealSleep)
                    TextView(text: element, color: .white, type: .idealSleep)

                }
            }
        }
  
    }
}
