//
//  WKInterfaceDevice+Size.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 27/11/22.
//

import SwiftUI

extension WKInterfaceDevice {
    
    static var size: CGRect {
        return WKInterfaceDevice.current().screenBounds
    }
}
