//
//  TextType.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 27/11/22.
//

import SwiftUI

enum TextType {
    
    case title
    case description
    case value
    case graphTitle
    case idealSleep
    case secondValue
    case reportDescription
    case regular
    

    var textStyle: TextStyle {
        switch self {
        case .title:
            return TextStyle(size: 14, weight: .medium)
        case .description:
            return TextStyle(size: 12, weight: .bold)
        case .value:
            return TextStyle(size: 16, weight: .bold)
        case .graphTitle:
            return TextStyle(size: 12, weight: .medium)
        case .idealSleep:
            return TextStyle(size: 12, weight: .medium)
        case .secondValue:
            return TextStyle(size: 16, weight: .medium)
        case .reportDescription:
            return TextStyle(size: 13, weight: .medium)
        case .regular:
            return TextStyle(size: 12, weight: .regular)

        }
        
    }
}
