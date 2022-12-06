//
//  StatisticsCollectionHandler.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 02/12/22.
//

import Foundation
import HealthKit


typealias CollectionHandler<T> = ((Result<T, Error>) -> Void)
typealias StatisticsCollectionHandler = CollectionHandler<HKStatisticsCollection>
typealias SleepCollectionHandler = CollectionHandler<SleepDataCollection>
