//
//  ScrollUp.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 28/11/22.
//

import Foundation


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
