//
//  Decimal.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 06/12/22.
//

import Foundation


class Decimal {
    
    
    static func fixNumber(with value: Float) -> Float {
        return ceil(value*10)/10
    }
    
    static func fixNumber(with value: Double) -> Double {
        return ceil(value*10)/10
    }
}


