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
    
    func exportCSV(_ url: URL, completion: @escaping (Error?) -> Void) {
        var content = "\u{FEFF}\"date\",\"weight\",\"bmi\",\"bodyFat\",\"muscles\",\"visceral\",\"restingMetabolism\",\"notes\"\n"

        for measurement in measurements {
            let row = "\(measurement.date),\(measurement.weight),\(measurement.bmi),\(measurement.bodyFat),\(measurement.muscles),\(measurement.visceral),\(measurement.restingMetabolism),\"\(measurement.notes.replacingOccurrences(of: "\"", with: "\"\""))\"\n".replacingOccurrences(of: "\n", with: " ")
            content += row + "\n"
        }
        
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            completion(nil)
        } catch {
            completion(error)
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
    
    private func parseCSVRow(input: String) -> [String] {
        var result = [String]()
        var value = ""
        var inQuotes = false

        for character in input {
            if character == "\"" {
                inQuotes = !inQuotes
            } else if character == "," {
                if inQuotes {
                    value.append(character)
                } else {
                    result.append(value)
                    value = ""
                }
            } else {
                value.append(character)
            }
        }
        
        // Don't forget to add the last value
        if !value.isEmpty {
            result.append(value)
        }

        return result
    }
    
    func importCSV(_ url: URL) {
        do {
            let data = try String(contentsOf: url)
            let lines = data.components(separatedBy: .newlines)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            for line in lines.dropFirst() { // dropFirst is used to skip the header line
                let parts = parseCSVRow(input: line)
                
                if parts.count == 8, // Ensure that we have the correct number of data fields
                   let date = dateFormatter.date(from: parts[0].trimmingCharacters(in: .init(charactersIn: "\""))),
                   let weight = Double(parts[1]),
                   let bmi = Double(parts[2]),
                   let bodyFat = Double(parts[3]),
                   let muscles = Double(parts[4]),
                   let visceral = Int(parts[5]),
                   let restingMetabolism = Int(parts[6]) {
                    let notes = parts[7].trimmingCharacters(in: .init(charactersIn: "\""))
                    
                    add(date: date, weight: weight, bmi: bmi, bodyFat: bodyFat, muscles: muscles,
                        visceral: visceral, restingMetabolism: restingMetabolism, notes: notes)
                }
            }
        } catch {
            print("Error reading data from URL: \(url), error: \(error)")
        }
    }

}
