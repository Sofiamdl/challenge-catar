//
//  LineOrientation.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 27/11/22.
//

import SwiftUI

enum LineOrientation {
    
    case vertical
    case horizontal
        
    var size: CGSize {
        switch self {
        case .horizontal:
            return CGSize(width: WKInterfaceDevice.size.width, height: 1)
        case .vertical:
            return CGSize(width: 3, height: 19)
        }
    }
}
