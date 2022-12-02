//
//  StatisticsCollectionHandler.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 02/12/22.
//

import Foundation
import HealthKit

typealias StatisticsCollectionHandler = ((Result<HKStatisticsCollection, Error>) -> Void)
