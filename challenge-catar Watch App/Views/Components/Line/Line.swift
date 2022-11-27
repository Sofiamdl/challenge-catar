//
//  Line.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 27/11/22.
//

import SwiftUI

struct Line: View {

    let orienttion: LineOrientation
    let withColor: Color
    
    var body: some View {
        Rectangle()
            .fill(withColor)
            .frame(width: orienttion.size.width,
                   height: orienttion.size.height,
                   alignment: .center)
            .cornerRadius(2)
    }
}
