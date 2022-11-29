//
//  ScrollFactory.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 28/11/22.
//

import SwiftUI

class ScrollFactory {
    
    static func scrollToUpOrDown(withGesture value: DragGesture.Value) -> ScrollableDirection {
        if value.translation.height < 0 {
            return ScrollDown()
        }
        return ScrollUp()
    }
}
