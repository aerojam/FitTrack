//
//  MeasurementView.swift
//  FitTrack
//
//  Created by Martin on 02.04.2023.
//

import SwiftUI

struct MeasurementView: View {
    @State var measurement: Measurement
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Formatter.mediumDate.string(from: measurement.date).uppercased())
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            HStack {
                CardView(title: String(localized: "Weight"), value: Formatter.decimalNumber(measurement.weight), units: "kg", background: .blue, foreground: .white)
                
                CardView(title: String(localized: "BMI"), value: Formatter.decimalNumber(measurement.bmi), units: "", background: .green, foreground: .white)
            }
            
            HStack {
                CardView(title: String(localized: "Body Fat"), value: Formatter.decimalNumber(measurement.bodyFat), units: "%", background: .orange, foreground: .black)
                
                CardView(title: String(localized: "Muscles"), value: Formatter.decimalNumber(measurement.muscles), units: "%", background: .red, foreground: .white)
            }
            
            HStack {
                CardView(title: String(localized: "Visceral Fat"), value: String(measurement.visceral), units: "", background: .purple, foreground: .white)
                
                CardView(title: String(localized: "Resting Metabolism"), value: String(measurement.restingMetabolism), units: "kcal", background: .yellow, foreground: .black)
            }
            
            Text(measurement.notes)
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
}

struct MeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementView(measurement: Measurement.example)
    }
}
