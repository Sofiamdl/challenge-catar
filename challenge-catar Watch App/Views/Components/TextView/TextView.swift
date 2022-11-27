//
//  TextView.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 27/11/22.
//

import SwiftUI

struct TextView: View {
    
    let text: String
    let color: Color
    let type: TextType
    
    var body: some View {
        Text(text)
            .font(.system(size: type.textStyle.size,
                          weight: type.textStyle.weight,
                          design: .rounded))
            .foregroundColor(color)
    }
}
