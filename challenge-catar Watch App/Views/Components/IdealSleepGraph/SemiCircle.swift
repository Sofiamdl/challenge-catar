//
//  SemiCircle.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 02/12/22.
//

import SwiftUI

struct SemiCircle: View {
    
    let completed: Double
    
    var body: some View {
        Circle()
            .trim(from: 0.5, to: completed)
            .stroke(Color(ColorConstant.BLUE),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .opacity(0.5)
            .frame(width: 150, height: 110)
    }
}
