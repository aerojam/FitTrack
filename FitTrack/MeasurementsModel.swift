//
//  Measurements.swift
//  FitTrack
//
//  Created by Martin on 01.04.2023.
//

import Foundation

class MeasurementsModel: ObservableObject {
    @Published var measurements: [Measurement]
    
    init() {
        measurements = []
        load()
    }
    
    func add(date: Date, weight: Double, bmi: Double, bodyFat: Double,muscles: Double,
             visceral: Int, restingMetabolism: Int, notes: String) {
        let measurement = Measurement(id: UUID(), date: date, weight: weight,
                                      bmi: bmi, bodyFat: bodyFat, muscles: muscles, visceral: visceral,
                                      restingMetabolism: restingMetabolism, notes: notes)
        measurements.append(measurement)
        save()
    }
    
    func add(_ measurement: Measurement) {
        measurements.append(measurement)
        save()
    }
    
    func removeMeasurement(_ measurement: Measurement?) {
        guard let id = measurement?.id else {
            return
        }
        
        measurements.removeAll { measurement in
            measurement.id == id
        }
        
        save()
    }
    
    private var appSupportURL: URL? {
        guard let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return appSupportURL
    }
    
    private var appDirectoryURL: URL? {
        appSupportURL?.appendingPathComponent("FitTrack")
    }
    
    private var jsonURL: URL? {
        appDirectoryURL?.appendingPathComponent("data.json")
    }
    
    func load() {
        let decoder = JSONDecoder()
        
        if jsonURL != nil, let jsonData = try? Data(contentsOf: jsonURL!) {
            do {
                measurements = try decoder.decode([Measurement].self, from: jsonData)
            } catch {
                fatalError("Could not decode JSON data: \(error)")
            }
        }
    }
    
    func save() {
        if let appDirectoryURL = appDirectoryURL {
            do {
                try FileManager.default.createDirectory(at: appDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Could not create directory: \(error)")
            }
        }
        
        if let jsonURL = jsonURL {
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(measurements)
                try jsonData.write(to: jsonURL)
            } catch {
                fatalError("Could not encode or write JSON data: \(error)")
            }
        }
    }
    
    func exportCSV(_ url: URL) {
        var content = "\u{FEFF}\"date\",\"weight\",\"bmi\",\"bodyFat\",\"muscles\",\"visceral\",\"restingMetabolism\",\"notes\"\n"

        for measurement in measurements {
            let row = "\(measurement.date),\(measurement.weight),\(measurement.bmi),\(measurement.bodyFat),\(measurement.muscles),\(measurement.visceral),\(measurement.restingMetabolism),\"\(measurement.notes.replacingOccurrences(of: "\"", with: "\"\""))\"\n".replacingOccurrences(of: "\n", with: " ")
            content += row + "\n"
        }
        
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Could not save CSV file: \(error.localizedDescription)")
        }
    }
    
    func saveJSON(_ url: URL) {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(measurements)
            try jsonData.write(to: url)
        } catch {
            print("Coulud not encode or write JSON data: \(error.localizedDescription)")
        }
    }
}
