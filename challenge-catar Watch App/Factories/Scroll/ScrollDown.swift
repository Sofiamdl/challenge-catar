//
//  ScrollDown.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 28/11/22.
//

import Foundation


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
