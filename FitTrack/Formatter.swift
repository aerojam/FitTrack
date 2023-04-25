//
//  Formatter.swift
//  FitTrack
//
//  Created by Martin on 23.04.2023.
//

import Foundation

class Formatter {
    public static var mediumDate: DateFormatter {
        let mediumDateFormatter = DateFormatter()
        mediumDateFormatter.dateStyle = .long
        mediumDateFormatter.timeStyle = .none
        return mediumDateFormatter
    }
    
    public static func decimalNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formattedString = formatter.string(from: NSNumber(value: number)) {
            return formattedString
        }
        
        return "--,-"
    }
}
