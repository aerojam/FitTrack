//
//  AddMeasurementView.swift
//  FitTrack
//
//  Created by Martin on 06.04.2023.
//

import SwiftUI
        
struct AddMeasurementView: View {
    @EnvironmentObject var dataModel: MeasurementsModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var newDate: Date = Date()
    @State private var newWeight: Double!
    @State private var newBmi: Double!
    @State private var newBodyFat: Double!
    @State private var newMuscles: Double!
    @State private var newVisceral: Int!
    @State private var newRestingMetabolism: Int!
    @State private var newDescription: String = ""
    
    var body: some View {
        VStack {
            Form {
                DatePicker("Measurement date:", selection: $newDate)
                TextField("Weight:", value: $newWeight, format: .number)
                TextField("BMI:", value: $newBmi, format: .number)
                TextField("Body fat:", value: $newBodyFat, format: .number)
                TextField("Muscles:", value: $newMuscles, format: .number)
                TextField("Visceral:", value: $newVisceral, format: .number)
                TextField("Resting metabolism:", value: $newRestingMetabolism, format: .number)
                TextField("Note:", text: $newDescription)
            }
            .padding([.top, .bottom])
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Insert") {
                    dataModel.add(date: newDate, weight: newWeight, bmi: newBmi,
                                  bodyFat: newBodyFat, muscles: newMuscles, visceral: newVisceral,
                                  restingMetabolism: newRestingMetabolism, notes: newDescription)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(disableForm)
            }
        }
        .padding()
    }
    
    var disableForm: Bool {
        newWeight == nil || newBmi == nil || newBodyFat == nil || newMuscles == nil || newVisceral == nil || newRestingMetabolism == nil
    }
}

struct AddMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        AddMeasurementView()
    }
}
