//
//  Measurement.swift
//  FitTrack£
//
//  Created by Martin on 01.04.2023.
//

import Foundation

struct Measurement: Identifiable, Codable, Hashable, Comparable {
    let id: UUID
    let date: Date
    let weight: Double
    let bmi: Double
    let bodyFat: Double
    let muscles: Double
    let visceral: Int
    let restingMetabolism: Int
    let notes: String
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
    
    static func < (lhs: Measurement, rhs: Measurement) -> Bool {
        lhs.date < rhs.date
    }
    
    // Just for debugging purposes
    static let example = Measurement(id: UUID(), date: Date(), weight: 95.4,
                                     bmi: 28.5, bodyFat: 29.6, muscles: 32.5,
                                     visceral: 12, restingMetabolism: 1921,
                                     notes: "Moje poslední hodnoty, slouží jako příklad.")
}
