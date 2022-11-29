//
//  ScrollableDirection.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 28/11/22.
//

import Foundation


protocol ScrollableDirection {
    func execute(with screens: [ScreenAvaiable], andCurrent scrolling: Int) -> ([ScreenAvaiable], Int)
}
