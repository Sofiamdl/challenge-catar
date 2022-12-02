//
//  VelocityHandler.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 02/12/22.
//

import Foundation

class VelocityHandler {
    
    static func toKM(withTimeDuration time: Float, andDistance distance: Float) -> Float{
        return (distance / time) * 3.6
    }
}
