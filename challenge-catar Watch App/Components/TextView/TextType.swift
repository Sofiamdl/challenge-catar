//
//  TextType.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 27/11/22.
//

import Foundation

enum TextType {
    
    case title
    case description
    case value
    
    var textStyle: TextStyle {
        switch self {
        case .title:
            return TextStyle(size: 14, weight: .medium)
        case .description:
            return TextStyle(size: 12, weight: .bold)
        case .value:
            return TextStyle(size: 16, weight: .bold)
        }
    }
}
