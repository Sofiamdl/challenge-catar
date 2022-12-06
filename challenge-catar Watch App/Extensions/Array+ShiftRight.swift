//
//  Array+ShiftRight.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 06/12/22.
//

import Foundation

extension Array {
    
    func shiftRight(_ amount: Int = 1) -> [Element] {
        var newAmount = amount
        guard count > 0 else { return self }
        assert(-count...count ~= newAmount, "Shift amount out of bounds")
        if newAmount < 0 { newAmount += count }  // this needs to be >= 0
        return Array(self[newAmount ..< count] + self[0 ..< newAmount])
    }

    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}
